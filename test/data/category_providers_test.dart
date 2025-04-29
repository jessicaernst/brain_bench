import 'dart:async';

import 'package:brain_bench/business_logic/auth/current_user_provider.dart';
import 'package:brain_bench/business_logic/categories/categories_provider.dart';
import 'package:brain_bench/data/infrastructure/database_providers.dart';
import 'package:brain_bench/data/infrastructure/quiz/category_providers.dart';
import 'package:brain_bench/data/models/category/category.dart';
import 'package:brain_bench/data/models/topic/topic.dart';
import 'package:brain_bench/data/models/user/app_user.dart';
import 'package:brain_bench/data/repositories/quiz_mock_database_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// --- Mocks ---
class MockQuizDatabaseRepository extends Mock
    implements QuizMockDatabaseRepository {}

// Mock AppUser as well, since currentUserProvider returns it
class MockAppUser extends Mock implements AppUser {}

// --- Mock Notifier ---
class MockCategoriesNotifier
    extends AutoDisposeFamilyAsyncNotifier<List<Category>, String>
    implements Categories {
  @override
  late final String languageCode;

  @override
  Future<List<Category>> build(String arg) async {
    throw UnimplementedError(
        'build() wurde nicht im Mock gestubbt für arg: $arg');
  }

  @override
  Future<void> updateCategoryProgress(
      String categoryId, String languageCodeParam) async {}
}

// --- Helpers ---
Category _createCategory(String id, String name) => Category(
      id: id,
      nameEn: '$name EN',
      nameDe: '$name DE',
      subtitleEn: 'Sub EN',
      subtitleDe: 'Sub DE',
      descriptionEn: 'Desc EN',
      descriptionDe: 'Desc DE',
    );

Topic _createTopic(String id, String categoryId) => Topic(
      id: id,
      nameEn: 'Topic $id EN',
      nameDe: 'Topic $id DE',
      descriptionEn: 'Desc',
      descriptionDe: 'Desc',
      categoryId: categoryId,
    );

AppUser _createAppUser(
  String uid, {
  Map<String, double> categoryProgress = const {},
  Map<String, Map<String, bool>> isTopicDone = const {},
}) =>
    AppUser(
      id: 'doc-$uid', // Firestore doc ID (can be anything unique for the test)
      uid: uid, // Auth UID
      email: '$uid@test.com', // Dummy email
      categoryProgress: categoryProgress,
      isTopicDone: isTopicDone,
    );

// Dummy AppUser instance for fallback registration
final _dummyAppUser = AppUser(
  id: 'dummy_doc_id',
  uid: 'dummy_auth_id',
  email: 'dummy@example.com',
);

// Dummy AsyncValue instance for fallback registration
const _dummyAsyncValue = AsyncLoading<List<Category>>();

void main() {
  // --- ADD setUpAll FOR FALLBACK VALUES ---
  setUpAll(() {
    registerFallbackValue(_dummyAppUser);
    registerFallbackValue(_dummyAsyncValue);
  });
  // --- END setUpAll ---

  late MockQuizDatabaseRepository mockRepository;
  late MockAppUser mockAuthUser; // Mock for currentUserProvider result
  late ProviderContainer container; // Container für Notifier-Tests
  late MockCategoriesNotifier mockCategoriesNotifier;
  const languageCode = 'en';
  const categoryId1 = 'cat1';
  const categoryId2 = 'cat2';
  const userId = 'user123';

  final category1 = _createCategory(categoryId1, 'Category 1');
  final category2 = _createCategory(categoryId2, 'Category 2');
  final mockCategories = [category1, category2];

  final topic1Cat1 = _createTopic('t1', categoryId1);
  final mockTopicsCat1 = [topic1Cat1, _createTopic('t2', categoryId1)];

  // --- Base Setup für Dependencies (für Notifier Tests) ---
  setUp(() {
    mockRepository = MockQuizDatabaseRepository();
    mockAuthUser = MockAppUser();
    when(() => mockAuthUser.uid).thenReturn(userId);

    container = ProviderContainer(
      overrides: [
        quizMockDatabaseRepositoryProvider
            .overrideWith((ref) => mockRepository),
        currentUserProvider.overrideWith((ref) => Stream.value(mockAuthUser)),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  // --- Notifier Tests ---
  group('Categories Notifier (business_logic)', () {
    group('build', () {
      test('should fetch categories from repository on build', () async {
        // Arrange
        when(() => mockRepository.getCategories(languageCode))
            .thenAnswer((_) async => mockCategories);

        // List to capture emitted states
        final states = <AsyncValue<List<Category>>>[];
        // Listen to the provider and add states to the list
        container.listen<AsyncValue<List<Category>>>(
          categoriesProvider(languageCode),
          (previous, next) => states.add(next),
          fireImmediately: true, // Capture initial state
        );

        // Act
        // Wait for the future to complete
        await container.read(categoriesProvider(languageCode).future);

        // Assert
        // Check the sequence of states emitted
        expect(states, [
          const AsyncLoading<List<Category>>(), // Initial loading state
          AsyncData<List<Category>>(mockCategories), // Final data state
        ]);
        verify(() => mockRepository.getCategories(languageCode)).called(1);
      });

      test('should return AsyncError when repository throws during build',
          () async {
        // Arrange
        final exception = Exception('Failed to load categories');
        when(() => mockRepository.getCategories(languageCode))
            .thenThrow(exception);

        // List to capture emitted states
        final states = <AsyncValue<List<Category>>>[];
        // Listen to the provider and add states to the list
        container.listen<AsyncValue<List<Category>>>(
          categoriesProvider(languageCode),
          (previous, next) => states.add(next),
          fireImmediately: true, // Capture initial state
        );

        // Act
        // Wait for the future to complete (it will throw)
        await expectLater(
          container.read(categoriesProvider(languageCode).future),
          throwsA(exception),
        );

        // Assert
        // Check the sequence of states emitted
        expect(states.length, 2); // Should have emitted loading then error
        expect(states[0], isA<AsyncLoading>()); // First state is loading
        expect(states[1], isA<AsyncError>()); // Second state is error
        // Optionally check the error content
        expect((states[1] as AsyncError).error, equals(exception));

        verify(() => mockRepository.getCategories(languageCode)).called(1);
      });
    });

    group('updateCategoryProgress', () {
      // ... updateCategoryProgress tests remain the same ...
      final userWithProgress = _createAppUser(userId, isTopicDone: {
        categoryId1: {topic1Cat1.id: true}
      });
      setUp(() {
        when(() => mockRepository.getUser(userId))
            .thenAnswer((_) async => userWithProgress);
        when(() => mockRepository.updateUser(any())).thenAnswer((_) async {});
      });
      test('should calculate and update progress correctly (1/2 topics done)',
          () async {
        when(() => mockRepository.getTopics(categoryId1, languageCode))
            .thenAnswer((_) async => mockTopicsCat1);
        final notifier =
            container.read(categoriesProvider(languageCode).notifier);
        await notifier.updateCategoryProgress(categoryId1, languageCode);
        verify(() => mockRepository.getTopics(categoryId1, languageCode))
            .called(1);
        verify(() => mockRepository.getUser(userId)).called(1);
        final captured =
            verify(() => mockRepository.updateUser(captureAny())).captured;
        expect(captured.length, 1);
        final updatedUser = captured.first as AppUser;
        expect(updatedUser.categoryProgress[categoryId1], equals(0.5));
        expect(updatedUser.email, userWithProgress.email);
        expect(updatedUser.isTopicDone, userWithProgress.isTopicDone);
      });
      test('should update progress to 0.0 if no topics exist', () async {
        when(() => mockRepository.getTopics(categoryId1, languageCode))
            .thenAnswer((_) async => []);
        final notifier =
            container.read(categoriesProvider(languageCode).notifier);
        await notifier.updateCategoryProgress(categoryId1, languageCode);
        verify(() => mockRepository.getTopics(categoryId1, languageCode))
            .called(1);
        verify(() => mockRepository.getUser(userId)).called(1);
        final captured =
            verify(() => mockRepository.updateUser(captureAny())).captured;
        final updatedUser = captured.first as AppUser;
        expect(updatedUser.categoryProgress[categoryId1], equals(0.0));
      });
      test('should update progress to 0.0 if user has no progress for category',
          () async {
        final userWithoutProgress = _createAppUser(userId);
        when(() => mockRepository.getUser(userId))
            .thenAnswer((_) async => userWithoutProgress);
        when(() => mockRepository.getTopics(categoryId1, languageCode))
            .thenAnswer((_) async => mockTopicsCat1);
        final notifier =
            container.read(categoriesProvider(languageCode).notifier);
        await notifier.updateCategoryProgress(categoryId1, languageCode);
        verify(() => mockRepository.getTopics(categoryId1, languageCode))
            .called(1);
        verify(() => mockRepository.getUser(userId)).called(1);
        final captured =
            verify(() => mockRepository.updateUser(captureAny())).captured;
        final updatedUser = captured.first as AppUser;
        expect(updatedUser.categoryProgress[categoryId1], equals(0.0));
      });
      test('should return early and not update if getUser returns null',
          () async {
        when(() => mockRepository.getUser(userId))
            .thenAnswer((_) async => null);
        when(() => mockRepository.getTopics(categoryId1, languageCode))
            .thenAnswer((_) async => mockTopicsCat1);
        final notifier =
            container.read(categoriesProvider(languageCode).notifier);
        await notifier.updateCategoryProgress(categoryId1, languageCode);
        verify(() => mockRepository.getTopics(categoryId1, languageCode))
            .called(1);
        verify(() => mockRepository.getUser(userId)).called(1);
        verifyNever(() => mockRepository.updateUser(any()));
      });
      test('should throw if getTopics throws', () async {
        final exception = Exception('Failed to get topics');
        when(() => mockRepository.getTopics(categoryId1, languageCode))
            .thenThrow(exception);
        final notifier =
            container.read(categoriesProvider(languageCode).notifier);
        await expectLater(
          notifier.updateCategoryProgress(categoryId1, languageCode),
          throwsA(exception),
        );
        verify(() => mockRepository.getTopics(categoryId1, languageCode))
            .called(1);
        verifyNever(() => mockRepository.getUser(any()));
        verifyNever(() => mockRepository.updateUser(any()));
      });
      test('should throw if getUser throws', () async {
        final exception = Exception('Failed to get user');
        when(() => mockRepository.getTopics(categoryId1, languageCode))
            .thenAnswer((_) async => mockTopicsCat1);
        when(() => mockRepository.getUser(userId)).thenThrow(exception);
        final notifier =
            container.read(categoriesProvider(languageCode).notifier);
        await expectLater(
          notifier.updateCategoryProgress(categoryId1, languageCode),
          throwsA(exception),
        );
        verify(() => mockRepository.getTopics(categoryId1, languageCode))
            .called(1);
        verify(() => mockRepository.getUser(userId)).called(1);
        verifyNever(() => mockRepository.updateUser(any()));
      });
      test('should throw if updateUser throws', () async {
        final exception = Exception('Failed to update user');
        when(() => mockRepository.getTopics(categoryId1, languageCode))
            .thenAnswer((_) async => mockTopicsCat1);
        when(() => mockRepository.updateUser(any())).thenThrow(exception);
        final notifier =
            container.read(categoriesProvider(languageCode).notifier);
        await expectLater(
          notifier.updateCategoryProgress(categoryId1, languageCode),
          throwsA(exception),
        );
        verify(() => mockRepository.getTopics(categoryId1, languageCode))
            .called(1);
        verify(() => mockRepository.getUser(userId)).called(1);
        verify(() => mockRepository.updateUser(any())).called(1);
      });
    });
  });

  // --- categoryByIdProvider Tests ---
  group('categoryById Provider (business_logic)', () {
    setUp(() {
      mockCategoriesNotifier = MockCategoriesNotifier();
      mockRepository = MockQuizDatabaseRepository();
      mockAuthUser = MockAppUser();
      when(() => mockAuthUser.uid).thenReturn(userId);
    });

    ProviderContainer createContainerWithMockNotifier() {
      return ProviderContainer(
        overrides: [
          categoriesProvider(languageCode).overrideWith(
            () => mockCategoriesNotifier,
          ),
        ],
      );
    }

    test(
        'should return correct category when categoriesProvider build succeeds',
        () async {
      when(() => mockCategoriesNotifier.build(languageCode))
          .thenAnswer((_) async => mockCategories);
      final testContainer = createContainerWithMockNotifier();
      addTearDown(testContainer.dispose);
      final result = await testContainer
          .read(categoryByIdProvider(categoryId1, languageCode).future);
      expect(result, equals(category1));
      verify(() => mockCategoriesNotifier.build(languageCode)).called(1);
    });

    test(
        'should throw when category ID does not exist in categoriesProvider data',
        () async {
      const nonExistentId = 'cat-non-existent';
      when(() => mockCategoriesNotifier.build(languageCode))
          .thenAnswer((_) async => mockCategories);
      final testContainer = createContainerWithMockNotifier();
      addTearDown(testContainer.dispose);
      await expectLater(
        testContainer
            .read(categoryByIdProvider(nonExistentId, languageCode).future),
        throwsA(isA<StateError>()),
      );
      verify(() => mockCategoriesNotifier.build(languageCode)).called(1);
    });

    test('should throw when categoriesProvider build throws', () async {
      final exception = Exception('Failed to load categories');
      when(() => mockCategoriesNotifier.build(languageCode))
          .thenThrow(exception);
      final testContainer = createContainerWithMockNotifier();
      addTearDown(testContainer.dispose);
      await expectLater(
        testContainer
            .read(categoryByIdProvider(categoryId1, languageCode).future),
        throwsA(exception),
      );
      verify(() => mockCategoriesNotifier.build(languageCode)).called(1);
    });

    test('should be in loading state initially (before build completes)', () {
      final completer = Completer<List<Category>>();
      when(() => mockCategoriesNotifier.build(languageCode))
          .thenAnswer((_) => completer.future);
      final testContainer = createContainerWithMockNotifier();
      addTearDown(testContainer.dispose);
      final result =
          testContainer.read(categoryByIdProvider(categoryId1, languageCode));
      expect(result, isA<AsyncLoading>());
      completer.complete([]);
    });
  });
}
