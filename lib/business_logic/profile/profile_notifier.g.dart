// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$profileNotifierHash() => r'bbb801bc742c3bf4e608f7b1a4a6cd9293d59b56';

/// This class represents the notifier for the profile state in the application.
/// It extends the generated `_$ProfileNotifier` class.
/// The `ProfileNotifier` class is responsible for updating the user's profile,
/// including the display name and profile image.
/// It handles the logic for image compression, validation, and uploading,
/// as well as updating the database with the new profile information.
/// It also manages the state of the profile update operation,
/// indicating whether it is loading, successful, or has encountered an error.
///
/// Copied from [ProfileNotifier].
@ProviderFor(ProfileNotifier)
final profileNotifierProvider =
    AutoDisposeAsyncNotifierProvider<ProfileNotifier, void>.internal(
      ProfileNotifier.new,
      name: r'profileNotifierProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$profileNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ProfileNotifier = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
