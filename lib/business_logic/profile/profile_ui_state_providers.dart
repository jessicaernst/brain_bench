import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_ui_state_providers.g.dart';

final _log = Logger('ProfileUiStateProviders');

/// Immutable state for the provisional image.
/// Includes a `version` counter for precise invalidation and `lastModified`
/// to detect content changes even when the path stays the same.
class ProvisionalImageState {
  final XFile? file;
  final int version; // ++ on set/clear → targeted invalidation
  final DateTime? lastModified;

  const ProvisionalImageState({this.file, this.version = 0, this.lastModified});

  ProvisionalImageState copyWith({
    XFile? file,
    int? version,
    DateTime? lastModified,
  }) => ProvisionalImageState(
    file: file ?? this.file,
    version: version ?? this.version,
    lastModified: lastModified ?? this.lastModified,
  );
}

/// Holds a provisional profile image (e.g., pulled from device contacts)
/// to be shown when no Firebase photoUrl is available.
/// Driven by ProfilePage and readable by other UI parts (e.g., ProfileButtonView).
@riverpod
class ProvisionalProfileImage extends _$ProvisionalProfileImage {
  @override
  ProvisionalImageState build() {
    return const ProvisionalImageState();
  }

  /// Idempotent setter: increments version if either path OR content changed.
  /// We compare file paths and the last-modified timestamp to catch in-place
  /// replacements that reuse the same path.
  Future<void> setImage(XFile? image) async {
    final newPath = image?.path;
    final oldPath = state.file?.path;

    DateTime? newModified;
    final DateTime? oldModified = state.lastModified;

    if (image != null) {
      try {
        newModified = await image.lastModified();
      } catch (e, st) {
        _log.fine(
          'setImage(): could not read lastModified for $newPath',
          e,
          st,
        );
        // If lastModified is unavailable (e.g., on some platforms),
        // we still proceed and treat different path as a change.
      }
    }

    final samePath = newPath == oldPath;
    final sameTime = newModified == oldModified;

    if (samePath && sameTime) {
      // no-op: neither path nor modified time changed
      return;
    }

    state = ProvisionalImageState(
      file: image,
      version: state.version + 1,
      lastModified: newModified,
    );
  }

  /// Idempotent clear: increments version only when something was set.
  void clearImage() {
    if (state.file == null && state.lastModified == null) return;
    state = ProvisionalImageState(
      file: null,
      version: state.version + 1,
      lastModified: null,
    );
  }
}

/// Selector: exposes the current XFile? only (reduces rebuilds).
@riverpod
XFile? provisionalProfileImageFile(Ref ref) {
  return ref.watch(provisionalProfileImageProvider.select((s) => s.file));
}

/// Selector: exposes the current version for fine-grained invalidation.
@riverpod
int provisionalProfileImageVersion(Ref ref) {
  return ref.watch(provisionalProfileImageProvider.select((s) => s.version));
}

/// Selector: exposes the lastModified timestamp (optional).
@riverpod
DateTime? provisionalProfileImageLastModified(Ref ref) {
  return ref.watch(
    provisionalProfileImageProvider.select((s) => s.lastModified),
  );
}

/// Cached bytes of the provisional image. Recomputes only when the file or
/// its version changes. This removes the need for a FutureBuilder in the UI.
@riverpod
Future<Uint8List?> provisionalProfileImageBytes(Ref ref) async {
  final file = ref.watch(provisionalProfileImageFileProvider);
  // Also depend on version to invalidate the cache on set/clear/content change.
  final _ = ref.watch(provisionalProfileImageVersionProvider);

  if (file == null) return null;

  // Keep provider alive in memory to avoid re-reading on unrelated rebuilds.
  ref.keepAlive();

  try {
    return await file.readAsBytes();
  } catch (e, st) {
    _log.warning('Reading provisional image bytes failed: $e', e, st);
    // Clear invalid provisional to prevent repeated errors and log spam.
    ref.read(provisionalProfileImageProvider.notifier).clearImage();
    return null; // UI will gracefully fall back to an asset
  }
}

/// One-shot flag to surface a snackbar when a contact image was auto-saved.
/// Set by `ensureUserExistsIfNeeded`, consumed by any UI widget and reset afterwards.
@riverpod
class ShowContactImageAutoSaveSnackbar
    extends _$ShowContactImageAutoSaveSnackbar {
  @override
  bool build() => false;

  void trigger() => state = true;
  void reset() => state = false;
}
