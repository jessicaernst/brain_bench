import 'package:brain_bench/data/repositories/firebase_storage_repository_impl.dart';
import 'package:brain_bench/data/repositories/storage_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'storage_providers.g.dart';

/// Provides an instance of [StorageRepository].
///
/// This will be an instance of [FirebaseStorageRepositoryImpl].
@Riverpod(keepAlive: true)
StorageRepository storageRepository(Ref ref) {
  return FirebaseStorageRepositoryImpl();
}
