// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_ui_state_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$provisionalProfileImageFileHash() =>
    r'9eb6157a233cfb30e12259c9f3c06623e2ef5ced';

/// Selector: exposes the current XFile? only (reduces rebuilds).
///
/// Copied from [provisionalProfileImageFile].
@ProviderFor(provisionalProfileImageFile)
final provisionalProfileImageFileProvider =
    AutoDisposeProvider<XFile?>.internal(
      provisionalProfileImageFile,
      name: r'provisionalProfileImageFileProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$provisionalProfileImageFileHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ProvisionalProfileImageFileRef = AutoDisposeProviderRef<XFile?>;
String _$provisionalProfileImageVersionHash() =>
    r'b4df79a6f77b85c2159f0b645f62718f40fb538a';

/// Selector: exposes the current version for fine-grained invalidation.
///
/// Copied from [provisionalProfileImageVersion].
@ProviderFor(provisionalProfileImageVersion)
final provisionalProfileImageVersionProvider =
    AutoDisposeProvider<int>.internal(
      provisionalProfileImageVersion,
      name: r'provisionalProfileImageVersionProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$provisionalProfileImageVersionHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ProvisionalProfileImageVersionRef = AutoDisposeProviderRef<int>;
String _$provisionalProfileImageLastModifiedHash() =>
    r'0992151748a92a7be73a669f412b5b0db6b23e1b';

/// Selector: exposes the lastModified timestamp (optional).
///
/// Copied from [provisionalProfileImageLastModified].
@ProviderFor(provisionalProfileImageLastModified)
final provisionalProfileImageLastModifiedProvider =
    AutoDisposeProvider<DateTime?>.internal(
      provisionalProfileImageLastModified,
      name: r'provisionalProfileImageLastModifiedProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$provisionalProfileImageLastModifiedHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ProvisionalProfileImageLastModifiedRef =
    AutoDisposeProviderRef<DateTime?>;
String _$provisionalProfileImageBytesHash() =>
    r'4d620791206ecca26332c0fdcbca6b4abd17e010';

/// Cached bytes of the provisional image. Recomputes only when the file or
/// its version changes. This removes the need for a FutureBuilder in the UI.
///
/// Copied from [provisionalProfileImageBytes].
@ProviderFor(provisionalProfileImageBytes)
final provisionalProfileImageBytesProvider =
    AutoDisposeFutureProvider<Uint8List?>.internal(
      provisionalProfileImageBytes,
      name: r'provisionalProfileImageBytesProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$provisionalProfileImageBytesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ProvisionalProfileImageBytesRef =
    AutoDisposeFutureProviderRef<Uint8List?>;
String _$provisionalProfileImageHash() =>
    r'3fd700f2776352fc4e1a31261253608ca5dd460c';

/// Holds a provisional profile image (e.g., pulled from device contacts)
/// to be shown when no Firebase photoUrl is available.
/// Driven by ProfilePage and readable by other UI parts (e.g., ProfileButtonView).
///
/// Copied from [ProvisionalProfileImage].
@ProviderFor(ProvisionalProfileImage)
final provisionalProfileImageProvider = AutoDisposeNotifierProvider<
  ProvisionalProfileImage,
  ProvisionalImageState
>.internal(
  ProvisionalProfileImage.new,
  name: r'provisionalProfileImageProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$provisionalProfileImageHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ProvisionalProfileImage = AutoDisposeNotifier<ProvisionalImageState>;
String _$showContactImageAutoSaveSnackbarHash() =>
    r'144bf7cc9842b9d9a0f94ff919e80b0d3268ed11';

/// One-shot flag to surface a snackbar when a contact image was auto-saved.
/// Set by `ensureUserExistsIfNeeded`, consumed by any UI widget and reset afterwards.
///
/// Copied from [ShowContactImageAutoSaveSnackbar].
@ProviderFor(ShowContactImageAutoSaveSnackbar)
final showContactImageAutoSaveSnackbarProvider = AutoDisposeNotifierProvider<
  ShowContactImageAutoSaveSnackbar,
  bool
>.internal(
  ShowContactImageAutoSaveSnackbar.new,
  name: r'showContactImageAutoSaveSnackbarProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$showContactImageAutoSaveSnackbarHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ShowContactImageAutoSaveSnackbar = AutoDisposeNotifier<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
