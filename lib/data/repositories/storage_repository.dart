import 'dart:io';

/// Abstract class defining the contract for storage operations.
///
/// This repository handles interactions with a file storage service,
/// such as uploading profile images or other user-generated content.
abstract class StorageRepository {
  /// Uploads a profile image for a given user.
  ///
  /// - [userId]: The unique identifier of the user.
  /// - [imageFile]: The [File] object representing the image to be uploaded.
  ///
  /// Returns a [Future] that completes with the download URL ([String])
  /// of the uploaded image.
  /// Throws an exception if the upload fails.
  Future<String> uploadProfileImage(String userId, File imageFile);
}
