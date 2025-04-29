import 'package:brain_bench/business_logic/categories/categories_provider.dart';
import 'package:brain_bench/data/infrastructure/quiz/category_providers.dart';
import 'package:brain_bench/data/models/category/category.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

// --- Mock Notifiers for categoriesProvider Dependency ---

/// Mock Notifier for the success case of `categoriesProvider`.
///
/// **Why `extends Categories`?**
/// 1.  **Type Compatibility:** The provider we are testing (`categoryByIdProvider`)
///     depends on `categoriesProvider`. When we override `categoriesProvider` in our
///     tests using `ProviderContainer` and `.overrideWith()`, Riverpod expects the
///     override function to return an instance of the *notifier* associated with
///     `categoriesProvider`. The notifier class for `categoriesProvider` is `Categories`.
///     By extending `Categories`, our `MockSuccessCategoriesNotifier` *is* a `Categories`
///     notifier, satisfying this type requirement.
/// 2.  **Behavior Replacement:** We want to replace the *real* logic of the `Categories`
///     notifier (which likely fetches data from a database or network) with controlled
///     behavior for our test. Extending the class allows us to `@override` the `build`
///     method.
/// 3.  **Simulating Success:** In this specific mock, we override `build` to return a
///     predefined list of `mockData` immediately (after a minimal delay to simulate async),
///     allowing us to test how `categoryByIdProvider` behaves when its dependency
///     successfully provides data.
class MockSuccessCategoriesNotifier extends Categories {
  final List<Category> mockData;
  final String expectedLanguageCode;

  MockSuccessCategoriesNotifier(this.mockData, this.expectedLanguageCode);

  @override
  Future<List<Category>> build(String languageCode) async {
    expect(languageCode, expectedLanguageCode);
    await Future.delayed(Duration.zero); // Simulate async operation
    return mockData; // Return controlled mock data
  }
}

/// Mock Notifier for the error case of `categoriesProvider`.
///
/// **Why `extends Categories`?**
/// 1.  **Type Compatibility:** Same reason as `MockSuccessCategoriesNotifier`. The
///     `.overrideWith()` method requires an instance of the `Categories` notifier class.
///     Extending `Categories` ensures this mock class has the correct type.
/// 2.  **Behavior Replacement:** We need to replace the real `build` logic with logic
///     that simulates an error condition.
/// 3.  **Simulating Error:** Here, we override `build` to `throw` a predefined `error`.
///     This allows us to test how `categoryByIdProvider` handles errors originating
///     from its `categoriesProvider` dependency.
class MockErrorCategoriesNotifier extends Categories {
  // <-- Extends the original Notifier class
  final Exception error;
  final String expectedLanguageCode;

  MockErrorCategoriesNotifier(this.error, this.expectedLanguageCode);

  @override
  Future<List<Category>> build(String languageCode) async {
    // Optional: Verify the correct language code is passed during the test
    expect(languageCode, expectedLanguageCode);
    await Future.delayed(Duration.zero); // Simulate async operation
    throw error; // Throw a controlled error
  }
}

void main() {
  // --- Tests for SelectedCategoryNotifier ---
  group('SelectedCategoryNotifier', () {
    late ProviderContainer container;
    late SelectedCategoryNotifier notifier;

    // Set up a new container before each test
    setUp(() {
      container = ProviderContainer();
      // Read the notifier instance itself to call methods on it
      notifier = container.read(selectedCategoryNotifierProvider.notifier);
      // Ensure container is disposed after each test
      addTearDown(container.dispose);
    });

    test('initial state is null', () {
      // Assert
      // Read the state directly
      expect(container.read(selectedCategoryNotifierProvider), isNull);
    });

    test('selectCategory sets the state to the given categoryId', () {
      // Arrange
      const categoryId = 'test-cat-1';

      // Act
      notifier.selectCategory(categoryId);

      // Assert
      expect(container.read(selectedCategoryNotifierProvider), categoryId);
    });

    test(
        'selectCategory with the same categoryId deselects it (sets state to null)',
        () {
      // Arrange
      const categoryId = 'test-cat-1';
      notifier.selectCategory(categoryId); // Select it first
      expect(container.read(selectedCategoryNotifierProvider),
          categoryId); // Verify initial selection

      // Act
      notifier.selectCategory(categoryId); // Select the same one again

      // Assert
      expect(container.read(selectedCategoryNotifierProvider), isNull);
    });

    test(
        'selectCategory with a different categoryId updates the state to the new ID',
        () {
      // Arrange
      const initialCategoryId = 'test-cat-1';
      const newCategoryId = 'test-cat-2';
      notifier.selectCategory(initialCategoryId); // Select the first one
      expect(container.read(selectedCategoryNotifierProvider),
          initialCategoryId); // Verify initial selection

      // Act
      notifier.selectCategory(newCategoryId); // Select the new one

      // Assert
      expect(container.read(selectedCategoryNotifierProvider), newCategoryId);
    });

    test('selectCategory with null deselects the current category', () {
      // Arrange
      const categoryId = 'test-cat-1';
      notifier.selectCategory(categoryId); // Select it first
      expect(container.read(selectedCategoryNotifierProvider),
          categoryId); // Verify initial selection

      // Act
      notifier.selectCategory(null); // Explicitly deselect

      // Assert
      expect(container.read(selectedCategoryNotifierProvider), isNull);
    });

    test('isCategorySelected returns false when state is null', () {
      // Arrange (initial state is null)

      // Act & Assert
      expect(notifier.isCategorySelected(), isFalse);
    });

    test('isCategorySelected returns true when a category is selected', () {
      // Arrange
      const categoryId = 'test-cat-1';
      notifier.selectCategory(categoryId); // Select a category

      // Act & Assert
      expect(notifier.isCategorySelected(), isTrue);
    });

    test('isCategorySelected returns false after deselecting a category', () {
      // Arrange
      const categoryId = 'test-cat-1';
      notifier.selectCategory(categoryId); // Select a category
      notifier.selectCategory(categoryId); // Deselect the category

      // Act & Assert
      expect(notifier.isCategorySelected(), isFalse);
    });
  });

  // --- Tests for categoryByIdProvider (Your existing tests) ---
  group('categoryByIdProvider', () {
    // Mock data
    final mockCategoriesEn = [
      Category(
          id: 'cat1',
          nameEn: 'Category One EN',
          nameDe: 'Kategorie Eins DE',
          subtitleEn: 'Subtitle One EN',
          subtitleDe: 'Untertitel Eins DE',
          descriptionEn: 'Description One EN',
          descriptionDe: 'Beschreibung Eins DE'),
      Category(
          id: 'cat2',
          nameEn: 'Category Two EN',
          nameDe: 'Kategorie Zwei DE',
          subtitleEn: 'Subtitle Two EN',
          subtitleDe: 'Untertitel Zwei DE',
          descriptionEn: 'Description Two EN',
          descriptionDe: 'Beschreibung Zwei DE'),
    ];
    final specificMockCategoriesDe = [
      Category(
          id: 'cat1-de',
          nameEn: 'Category One EN (for DE test)',
          nameDe: 'Kategorie Eins DE (fuer DE test)',
          subtitleEn: 'Subtitle One EN (for DE test)',
          subtitleDe: 'Untertitel Eins DE (fuer DE test)',
          descriptionEn: 'Description One EN (for DE test)',
          descriptionDe: 'Beschreibung Eins DE (fuer DE test)'),
    ];
    const testLangCodeEn = 'en';
    const testLangCodeDe = 'de';
    final testException = Exception('Failed to load categories');

    test('returns the correct category when ID exists (using EN)', () async {
      // Arrange
      final container = ProviderContainer(
        overrides: [
          // Override the dependency 'categoriesProvider' with our mock notifier
          categoriesProvider(testLangCodeEn).overrideWith(
            // Provide an instance of the mock notifier
            () =>
                MockSuccessCategoriesNotifier(mockCategoriesEn, testLangCodeEn),
          ),
        ],
      );
      addTearDown(container.dispose);

      // Optional: "Warm up" the dependency provider to ensure its 'build' runs
      await container.read(categoriesProvider(testLangCodeEn).future);

      const targetCategoryId = 'cat1';

      // Act
      // Read the future from the provider we are testing
      final category = await container
          .read(categoryByIdProvider(targetCategoryId, testLangCodeEn).future);

      // Assert
      expect(category, isNotNull);
      expect(category.id, targetCategoryId);
      expect(category.nameEn, 'Category One EN');
      expect(category.nameDe, 'Kategorie Eins DE');
      expect(category.subtitleEn, 'Subtitle One EN');
    });

    test('throws StateError when category ID does not exist', () async {
      // Arrange
      final container = ProviderContainer(
        overrides: [
          categoriesProvider(testLangCodeEn).overrideWith(
            () =>
                MockSuccessCategoriesNotifier(mockCategoriesEn, testLangCodeEn),
          ),
        ],
      );
      addTearDown(container.dispose);
      const nonExistentCategoryId = 'cat-non-existent';

      // Optional: "Warm up" the dependency provider
      await container.read(categoriesProvider(testLangCodeEn).future);

      // Act & Assert
      // Use expectLater for futures that should throw
      // The provider itself returns a Future<Category>, so we read that future.
      // The error happens inside the future when firstWhere fails.
      expectLater(
        container.read(
            categoryByIdProvider(nonExistentCategoryId, testLangCodeEn).future),
        // The actual error thrown by firstWhere when no element is found
        throwsA(isA<StateError>()),
      );
    });

    test('uses the correct language code when fetching categories (using DE)',
        () async {
      // Arrange
      final container = ProviderContainer(
        overrides: [
          // Override for 'de'
          categoriesProvider(testLangCodeDe).overrideWith(
            () => MockSuccessCategoriesNotifier(
                specificMockCategoriesDe, testLangCodeDe),
          ),
        ],
      );
      addTearDown(container.dispose);

      // Optional: "Warm up" the 'de' dependency
      await container.read(categoriesProvider(testLangCodeDe).future);

      const targetCategoryId = 'cat1-de';

      // Act
      final category = await container
          .read(categoryByIdProvider(targetCategoryId, testLangCodeDe).future);

      // Assert
      expect(category, isNotNull);
      expect(category.id, targetCategoryId);
      expect(category.nameDe, 'Kategorie Eins DE (fuer DE test)');
      expect(category.nameEn, 'Category One EN (for DE test)');
    });

    test('handles error state from dependency provider', () async {
      // Arrange
      final container = ProviderContainer(
        overrides: [
          // Override with the Error Mock Notifier
          categoriesProvider(testLangCodeEn).overrideWith(
            () => MockErrorCategoriesNotifier(testException, testLangCodeEn),
          ),
        ],
      );
      addTearDown(container.dispose);

      const targetCategoryId = 'cat1';

      // Act & Assert
      // When the dependency (categoriesProvider) throws an error during its build,
      // reading the dependent provider (categoryByIdProvider) will also result
      // in that same error being thrown when its future is awaited.
      expectLater(
        container.read(
            categoryByIdProvider(targetCategoryId, testLangCodeEn).future),
        throwsA(predicate((e) => e == testException)),
      );
    });
  });
}
