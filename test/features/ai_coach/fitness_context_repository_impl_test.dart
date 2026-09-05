import 'package:dartz/dartz.dart';
import 'package:fitflow/core/failure/failure.dart';
import 'package:fitflow/features/ai_coach/data/repositories/fitness_context_repository_impl.dart';
import 'package:fitflow/features/rep_tracker/domain/entities/exercise.dart';
import 'package:fitflow/features/rep_tracker/domain/entities/exercise_set.dart';
import 'package:fitflow/features/rep_tracker/domain/entities/personal_record.dart';
import 'package:fitflow/features/rep_tracker/domain/entities/workout_session.dart';
import 'package:fitflow/features/rep_tracker/domain/repositories/workout_repository.dart';
import 'package:fitflow/features/rep_tracker/domain/usecases/get_personal_records.dart';
import 'package:fitflow/features/rep_tracker/domain/usecases/get_workout_history.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeWorkoutRepository implements WorkoutRepository {
  Either<Failure, List<WorkoutSession>> historyResult = const Right([]);
  Either<Failure, List<PersonalRecord>> personalRecordsResult = const Right(
    [],
  );
  Option<WorkoutSession> activeSession = none();

  @override
  Future<Option<WorkoutSession>> loadActiveSession() async => activeSession;

  @override
  Future<Either<Failure, Unit>> clearActiveSession() async => const Right(unit);

  @override
  Future<Either<Failure, Unit>> deleteWorkoutSession(String sessionId) async =>
      const Right(unit);

  @override
  Future<Either<Failure, List<WorkoutSession>>> getWorkoutHistory() async =>
      historyResult;

  @override
  Future<Either<Failure, List<PersonalRecord>>> getPersonalRecords() async =>
      personalRecordsResult;

  @override
  Future<Either<Failure, Unit>> saveActiveSession(
    WorkoutSession session,
  ) async => const Right(unit);

  @override
  Future<Either<Failure, Unit>> saveWorkoutSession(
    WorkoutSession session,
  ) async => const Right(unit);
}

void main() {
  test('builds context from workout history and personal records', () async {
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 1));
    final repo = FakeWorkoutRepository()
      ..historyResult = Right([
        WorkoutSession(
          id: '1',
          date: yesterday,
          exercises: [
            Exercise(
              id: 'ex1',
              name: 'Bench Press',
              sets: [
                ExerciseSet(
                  id: 's1',
                  weightKg: 60,
                  reps: 8,
                  performedAt: yesterday,
                ),
              ],
            ),
            Exercise(
              id: 'ex2',
              name: 'Squat',
              sets: [
                ExerciseSet(
                  id: 's2',
                  weightKg: 100,
                  reps: 5,
                  performedAt: yesterday,
                ),
              ],
            ),
          ],
        ),
      ])
      ..personalRecordsResult = Right([
        PersonalRecord(
          exerciseName: 'Squat',
          bestWeightKg: 100,
          repsAtBestWeight: 5,
          achievedAt: yesterday,
        ),
        PersonalRecord(
          exerciseName: 'Bench Press',
          bestWeightKg: 60,
          repsAtBestWeight: 8,
          achievedAt: yesterday,
        ),
      ]);

    final repository = FitnessContextRepositoryImpl(
      getWorkoutHistory: GetWorkoutHistory(repo),
      getPersonalRecords: GetPersonalRecords(repo),
      workoutRepository: repo,
    );

    final result = await repository.getFitnessContext();

    expect(result.isRight(), isTrue);
    result.fold((_) => fail('Expected success'), (context) {
      expect(context.daysSinceLastWorkout, 1);
      expect(context.sessionsLast7Days, 1);
      expect(context.totalSessions, 1);
      expect(context.topPersonalRecords.first.exerciseName, 'Squat');
      expect(context.frequentExercises, contains('Bench Press'));
      expect(context.hasActiveSession, isFalse);
      expect(context.briefingHeadline, contains('Rest day yesterday'));
    });
  });

  test('returns failure when workout history fails', () async {
    final repo = FakeWorkoutRepository()
      ..historyResult = const Left(CacheFailure(message: 'History unavailable'));

    final repository = FitnessContextRepositoryImpl(
      getWorkoutHistory: GetWorkoutHistory(repo),
      getPersonalRecords: GetPersonalRecords(repo),
      workoutRepository: repo,
    );

    final result = await repository.getFitnessContext();

    expect(result.isLeft(), isTrue);
    result.fold((failure) {
      expect(failure.message, 'History unavailable');
    }, (_) => fail('Expected failure'));
  });
}
