import 'package:brain_bench/data/infrastructure/database_providers.dart';
import 'package:brain_bench/data/infrastructure/quiz/answer_providers.dart';
import 'package:brain_bench/data/models/quiz/answer.dart';
// Importiere die tatsächliche Klasse/Interface, die der Provider erwartet
import 'package:brain_bench/data/repositories/quiz_mock_database_repository_impl.dart'; // Passe den Pfad an, falls nötig
// ODER
// import 'package:brain_bench/data/infrastructure/quiz/i_quiz_database_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart' hide Answer;

// --- Mocks ---
class MockQuizDatabaseRepository extends Mock
    implements QuizMockDatabaseRepository {}

// Helper function to create mock Answer objects
Answer _createAnswer(String id) {
  return Answer(
    id: id,
    textEn: 'Answer EN $id',
    textDe: 'Antwort DE $id',
    isCorrect: id.contains('correct'),
  );
}

void main() {
  late MockQuizDatabaseRepository mockRepository;
  late ProviderContainer container;

  // Sample data
  final answerIds = ['id1', 'id2', 'id-correct'];
  const languageCode = 'en';
  final mockAnswers = [
    _createAnswer('id1'),
    _createAnswer('id2'),
    _createAnswer('id-correct'),
  ];

  setUp(() {
    mockRepository = MockQuizDatabaseRepository();
    container = ProviderContainer(
      overrides: [
        quizMockDatabaseRepositoryProvider.overrideWith(
          (ref) => mockRepository,
        ),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  // --- Added Group ---
  group('answersProvider', () {
    test('should fetch answers from repository and return list on success',
        () async {
      // Arrange
      // Stub the getAnswers method to return the mock list when called with specific args
      when(() => mockRepository.getAnswers(answerIds, languageCode))
          .thenAnswer((_) async => mockAnswers);

      // Act
      // Read the provider's future and await its result
      final result =
          await container.read(answersProvider(answerIds, languageCode).future);

      // Assert
      // Verify the result matches the mock data
      expect(result, equals(mockAnswers));
      // Verify that the repository method was called exactly once with the correct arguments
      verify(() => mockRepository.getAnswers(answerIds, languageCode))
          .called(1);
    });

    test('should return empty list when repository returns empty list',
        () async {
      // Arrange
      // Stub the getAnswers method to return an empty list
      when(() => mockRepository.getAnswers(answerIds, languageCode))
          .thenAnswer((_) async => []);

      // Act
      final result =
          await container.read(answersProvider(answerIds, languageCode).future);

      // Assert
      expect(result, isEmpty);
      verify(() => mockRepository.getAnswers(answerIds, languageCode))
          .called(1);
    });

    test('should throw exception when repository throws exception', () async {
      // Arrange
      final testException = Exception('Database error');
      // Stub the getAnswers method to throw an exception
      when(() => mockRepository.getAnswers(answerIds, languageCode))
          .thenThrow(testException);

      // Act & Assert
      // Expect that awaiting the future from the provider throws the same exception
      // that the repository threw. The provider itself doesn't catch it.
      await expectLater(
        container.read(answersProvider(answerIds, languageCode).future),
        throwsA(testException),
      );
      // Verify the repository method was still called
      verify(() => mockRepository.getAnswers(answerIds, languageCode))
          .called(1);
    });

    test('should call repository with different arguments', () async {
      // Arrange
      final differentIds = ['diff1', 'diff2'];
      const differentLang = 'de';
      final differentMockAnswers = [_createAnswer('diff1')];
      when(() => mockRepository.getAnswers(differentIds, differentLang))
          .thenAnswer((_) async => differentMockAnswers);

      // Act
      final result = await container
          .read(answersProvider(differentIds, differentLang).future);

      // Assert
      expect(result, equals(differentMockAnswers));
      verify(() => mockRepository.getAnswers(differentIds, differentLang))
          .called(1);
      // Verify the original arguments were NOT used in this specific call
      verifyNever(() => mockRepository.getAnswers(answerIds, languageCode));
    });
  });
}
