import 'package:brain_bench/data/infrastructure/auth/auth_repository.dart';
import 'package:brain_bench/data/models/user/app_user.dart';
import 'package:brain_bench/data/repositories/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
  });

  test('authRepositoryProvider returns mocked AuthRepository', () async {
    when(() => mockAuthRepository.signInWithEmail(any(), any())).thenAnswer(
      (_) async =>
          const AppUser(uid: '123', id: '123', email: 'test@example.com'),
    );

    final container = ProviderContainer(
      overrides: [authRepositoryProvider.overrideWithValue(mockAuthRepository)],
    );

    final repository = container.read(authRepositoryProvider);

    await repository.signInWithEmail('test@example.com', 'password123');

    verify(
      () =>
          mockAuthRepository.signInWithEmail('test@example.com', 'password123'),
    ).called(1);
  });
}
