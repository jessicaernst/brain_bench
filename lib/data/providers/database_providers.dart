import 'package:brain_bench/data/repositories/mock_database_reposity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'database_providers.g.dart';

@riverpod
MockDatabaseRepository mockDatabaseRepository(Ref ref) {
  return MockDatabaseRepository();
}
