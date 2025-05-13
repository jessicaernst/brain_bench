import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

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

  /// Provides access to the underlying Firebase Storage instance.
  /// This might be needed for more advanced operations not covered by the repository methods.
  firebase_storage.FirebaseStorage get storageInstance;
}
