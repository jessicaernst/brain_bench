// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$currentUserModelHash() => r'7a1ae60fe7be34179919285741594540f60ed411';

/// Stream that provides the current user model based on the authentication state.
/// Retrieves the current user model as a stream of [UserModelState].
/// The [UserModelState] represents the state of the user model, including loading, unauthenticated, error, or data.
/// This function listens to the authentication state changes and fetches the user model from the database.
/// If the user model does not exist, it attempts to create one.
///
/// Parameters:
/// - [ref]: The reference to the current provider.
///
/// Returns:
/// A stream of [UserModelState] representing the state of the user model.
///
/// Copied from [currentUserModel].
@ProviderFor(currentUserModel)
final currentUserModelProvider =
    AutoDisposeStreamProvider<UserModelState>.internal(
      currentUserModel,
      name: r'currentUserModelProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$currentUserModelHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentUserModelRef = AutoDisposeStreamProviderRef<UserModelState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
