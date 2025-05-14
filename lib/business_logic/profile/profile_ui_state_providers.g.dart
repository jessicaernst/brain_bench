// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_ui_state_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$provisionalProfileImageHash() =>
    r'5da39e895eedc54f66771401355bccaca7c961ef';

/// Holds a profile image that might be provisionally displayed
/// (e.g., from device contacts) if no Firebase photoUrl is available.
/// This is primarily managed by ProfilePage and can be read by other UI components
/// like ProfileButtonView for consistent display.
///
/// Copied from [ProvisionalProfileImage].
@ProviderFor(ProvisionalProfileImage)
final provisionalProfileImageProvider =
    AutoDisposeNotifierProvider<ProvisionalProfileImage, XFile?>.internal(
      ProvisionalProfileImage.new,
      name: r'provisionalProfileImageProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$provisionalProfileImageHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ProvisionalProfileImage = AutoDisposeNotifier<XFile?>;
String _$showContactImageAutoSaveSnackbarHash() =>
    r'f9b267b080af9cb0ec4c13684155beb549c5d498';

/// Signals that a one-time snackbar for auto-saved contact image should be shown.
/// Set to true by `ensureUserExistsIfNeeded`, consumed and reset by a UI widget.
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
