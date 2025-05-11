import 'package:brain_bench/business_logic/auth/current_user_provider.dart';
import 'package:brain_bench/data/infrastructure/database_providers.dart';
import 'package:brain_bench/data/infrastructure/user/user_provider.dart';
import 'package:brain_bench/data/models/user/app_user.dart';
import 'package:brain_bench/data/repositories/database_repository.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_notifier.g.dart';

final _logger = Logger('ProfileNotifier');

@riverpod
class ProfileNotifier extends _$ProfileNotifier {
  @override
  FutureOr<void> build() {
    return null;
  }

  Future<void> updateProfile({
    required String displayName,
    // XFile? newImageFile,
  }) async {
    state = const AsyncLoading();
    _logger.fine('Attempting to update profile...');

    try {
      // 1. Get the Database Repository (asynchronously)
      final DatabaseRepository dbRepository = await ref.read(
        quizMockDatabaseRepositoryProvider.future,
      );

      // 2. Get the current authentication state's AppUser? value
      //    Reading the latest value emitted by the currentUserProvider stream.
      //    This assumes the stream has emitted a value for the logged-in user.
      final AsyncValue<AppUser?> authUserAsyncValue = ref.read(
        currentUserProvider,
      );

      // 3. Extract the userId from the auth state AppUser
      //    valueOrNull safely gets the data if available, otherwise null.
      final String? userId = authUserAsyncValue.valueOrNull?.uid;

      // 4. Check if userId could be obtained (user is logged in and stream has emitted)
      if (userId == null || userId.isEmpty) {
        // This could happen if the user is not logged in, or the stream hasn't emitted yet.
        final error = Exception(
          'User not authenticated or user ID not available',
        );
        _logger.warning('Profile update failed: ${error.toString()}');
        state = AsyncError(error, StackTrace.current);
        return;
      }

      // TODO(YourNameOrTicketId): Implement image upload to Firebase Storage
      // - Check if newImageFile is not null
      // - Inject/Read a StorageService/Repository
      // - Call the upload method (e.g., storageService.uploadProfilePicture)
      // - Get the returned photoUrl
      //String? photoUrl; // Keep this variable for when the TODO is resolved
      // if (newImageFile != null) {
      //   final storageService = ref.read(storageServiceProvider); // Example
      //   photoUrl = await storageService.uploadProfilePicture(userId: userId, file: newImageFile);
      // }

      // 5. Call the database repository method
      _logger.info(
        'Calling updateUserProfile for user $userId with name: $displayName',
      );
      await dbRepository.updateUserProfile(
        userId: userId, // Use the extracted userId
        displayName: displayName,
        // photoUrl: photoUrl,
      );
      _logger.info('Profile update successful in repository for user $userId.');

      // 6. Invalidate the provider that loads the *full* user model from the DB
      //    This ensures that UIs watching currentUserModelProvider get the updated data.
      ref.invalidate(
        currentUserModelProvider,
      ); // Revert to currentUserModelProvider
      _logger.fine('Invalidated currentUserModelProvider.');

      // 7. Set state to success
      state = const AsyncData(null);
      _logger.info('Profile update state set to success.');
    } catch (e, stack) {
      // 8. Set state to error
      // Try to get userId again for logging, might still be null
      final userIdForLog =
          ref.read(currentUserProvider).valueOrNull?.uid ?? 'unknown';
      _logger.severe(
        'Failed to update profile for user $userIdForLog',
        e,
        stack,
      );
      state = AsyncError(e, stack);
    }
  }
}
