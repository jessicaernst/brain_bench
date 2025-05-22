import 'package:brain_bench/business_logic/auth/current_user_provider.dart';
import 'package:brain_bench/data/infrastructure/database_providers.dart';
import 'package:brain_bench/data/infrastructure/quiz/category_providers.dart';
import 'package:brain_bench/data/models/topic/topic.dart';
import 'package:brain_bench/data/models/user/app_user.dart';
import 'package:brain_bench/data/repositories/database_repository.dart';
import 'package:brain_bench/data/repositories/user_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDatabaseRepository extends Mock implements DatabaseRepository {}

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  late MockDatabaseRepository mockDatabaseRepo;
  late MockUserRepository mockUserRepo;
  late AppUser fakeUser;

  setUp(() {
    mockUserRepo = MockUserRepository();
    mockDatabaseRepo = MockDatabaseRepository();
    fakeUser = const AppUser(uid: '123', id: '123', email: 'test@example.com');
  });

  setUpAll(() {
    registerFallbackValue(
      const AppUser(
        uid: 'fallback',
        id: 'fallback',
        email: 'fallback@example.com',
      ),
    );
  });

  test('updateCategoryProgress updates user progress correctly', () async {
    const categoryId = 'cat1';
    const languageCode = 'en';

    final topics = [
      Topic(
        id: 't1',
        nameEn: 'Topic 1',
        nameDe: 'Thema 1',
        descriptionEn: 'Desc 1',
        descriptionDe: 'Beschr 1',
        categoryId: 'cat1',
      ),
      Topic(
        id: 't2',
        nameEn: 'Topic 2',
        nameDe: 'Thema 2',
        descriptionEn: 'Desc 2',
        descriptionDe: 'Beschr 2',
        categoryId: 'cat1',
      ),
    ];
    final userWithProgress = fakeUser.copyWith(
      isTopicDone: {
        categoryId: {'t1': true, 't2': false},
      },
    );

    when(
      () => mockDatabaseRepo.getTopics(categoryId),
    ).thenAnswer((_) async => topics);
    when(
      () => mockUserRepo.getUser(fakeUser.uid),
    ).thenAnswer((_) async => userWithProgress);
    when(() => mockUserRepo.updateUser(any())).thenAnswer((_) async {});

    final container = ProviderContainer(
      overrides: [
        // Override the actual providers used by Categories notifier
        quizFirebaseRepositoryProvider.overrideWithValue(mockDatabaseRepo),
        userFirebaseRepositoryProvider.overrideWithValue(mockUserRepo),
        currentUserProvider.overrideWith((ref) => Stream.value(fakeUser)),
      ],
    );

    final notifier = container.read(categoriesProvider(languageCode).notifier);

    // Act
    await notifier.updateCategoryProgress(categoryId, languageCode);

    final expectedProgress = 0.5;
    final expectedUpdatedUser = userWithProgress.copyWith(
      categoryProgress: {categoryId: expectedProgress},
    );

    verify(() => mockUserRepo.updateUser(expectedUpdatedUser)).called(1);
  });
}
