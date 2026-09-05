import 'package:drift/native.dart';
import 'package:fitflow/core/database/app_database.dart' hide WorkoutSession;
import 'package:fitflow/features/rep_tracker/data/datasources/workout_local_datasource.dart';
import 'package:fitflow/features/rep_tracker/data/repositories/workout_repository_impl.dart';
import 'package:fitflow/features/rep_tracker/domain/entities/exercise.dart';
import 'package:fitflow/features/rep_tracker/domain/entities/exercise_set.dart';
import 'package:fitflow/features/rep_tracker/domain/entities/workout_session.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late AppDatabase database;
  late WorkoutRepositoryImpl repository;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    database = AppDatabase(NativeDatabase.memory());
    final datasource = WorkoutLocalDatasourceImpl(database: database);
    repository = WorkoutRepositoryImpl(localDatasource: datasource);
  });

  tearDown(() async {
    await database.close();
  });

  test('reads saved history and personal records from Drift', () async {
    final session = WorkoutSession(
      id: 'session-1',
      date: DateTime(2026, 3, 2),
      exercises: [
        Exercise(
          id: 'ex-1',
          name: 'Bench Press',
          sets: [
            ExerciseSet(
              id: 'set-1',
              weightKg: 80,
              reps: 5,
              performedAt: DateTime(2026, 3, 2, 9),
            ),
          ],
        ),
      ],
    );

    final saveResult = await repository.saveWorkoutSession(session);
    expect(saveResult.isRight(), isTrue);

    final historyResult = await repository.getWorkoutHistory();
    historyResult.fold((_) => fail('Expected history'), (history) {
      expect(history, hasLength(1));
      expect(history.first.exercises.first.name, 'Bench Press');
    });

    final prResult = await repository.getPersonalRecords();
    prResult.fold((_) => fail('Expected PRs'), (records) {
      expect(records.single.exerciseName, 'Bench Press');
      expect(records.single.bestWeightKg, 80);
    });
  });
}
