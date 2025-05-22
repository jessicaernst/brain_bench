import 'dart:io';

import 'package:brain_bench/data/repositories/storage_repository.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:logging/logging.dart';

final Logger _logger = Logger('FirebaseStorageRepositoryImpl');

/// Implementation of [StorageRepository] using Firebase Storage.
///
/// This class handles the actual file upload operations to Firebase Storage.
class FirebaseStorageRepositoryImpl implements StorageRepository {
  final firebase_storage.FirebaseStorage _storage;

  /// Creates an instance of [FirebaseStorageRepositoryImpl].
  ///
  /// An optional [firebase_storage.FirebaseStorage] instance can be provided
  /// for testing purposes. If not provided, the default instance is used.
  FirebaseStorageRepositoryImpl({firebase_storage.FirebaseStorage? storage})
    : _storage = storage ?? firebase_storage.FirebaseStorage.instance;

  @override
  Future<String> uploadProfileImage(String userId, File imageFile) async {
    try {
      // Define a unique path for the image in Firebase Storage.
      final String fileName =
          'profile_images/$userId/${DateTime.now().millisecondsSinceEpoch}_${imageFile.path.split('/').last}';
      _logger.info(
        'Attempting to upload profile image to Firebase Storage: $fileName',
      );

      final firebase_storage.Reference ref = _storage.ref().child(fileName);
      final firebase_storage.UploadTask uploadTask = ref.putFile(imageFile);
      final firebase_storage.TaskSnapshot snapshot = await uploadTask;
      final String downloadUrl = await snapshot.ref.getDownloadURL();
      _logger.info(
        'Profile image uploaded successfully. Download URL: $downloadUrl',
      );
      return downloadUrl;
    } catch (e, stackTrace) {
      _logger.severe(
        'Error uploading profile image for user $userId: $e',
        e,
        stackTrace,
      );
      rethrow;
    }
  }

  @override
  firebase_storage.FirebaseStorage get storageInstance => _storage;
}
