import 'package:drift/native.dart';
import 'package:fitflow/core/database/app_database.dart';
import 'package:fitflow/core/failure/cache_exceptions.dart';
import 'package:fitflow/features/rep_tracker/data/datasources/workout_local_datasource.dart';
import 'package:fitflow/features/rep_tracker/data/models/exercise_model.dart';
import 'package:fitflow/features/rep_tracker/data/models/set_model.dart';
import 'package:fitflow/features/rep_tracker/data/models/workout_session_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late AppDatabase database;
  late WorkoutLocalDatasourceImpl datasource;

  final sessionModel = WorkoutSessionModel(
    id: 's1',
    date: DateTime(2026, 3, 1, 10),
    exercises: [
      ExerciseModel(
        id: 'e1',
        name: 'Squat',
        sets: [
          SetModel(
            id: 'set1',
            weightKg: 100,
            reps: 5,
            performedAt: DateTime(2026, 3, 1, 10, 15),
          ),
        ],
      ),
    ],
  );

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    database = AppDatabase(NativeDatabase.memory());
    datasource = WorkoutLocalDatasourceImpl(database: database);
  });

  tearDown(() async {
    await database.clearAllWorkoutData();
  });

  group('saveWorkoutSession', () {
    test('persists session with nested exercises and sets', () async {
      await datasource.saveWorkoutSession(sessionModel);

      final history = await datasource.getWorkoutHistory();
      expect(history, hasLength(1));
      expect(history.first.id, 's1');
      expect(history.first.exercises.first.name, 'Squat');
      expect(history.first.exercises.first.sets.first.weightKg, 100);
    });

    test('replaces an existing session with the same id', () async {
      await datasource.saveWorkoutSession(sessionModel);

      final updated = WorkoutSessionModel(
        id: 's1',
        date: sessionModel.date,
        exercises: [
          ExerciseModel(
            id: 'e2',
            name: 'Deadlift',
            sets: [
              SetModel(
                id: 'set2',
                weightKg: 140,
                reps: 3,
                performedAt: DateTime(2026, 3, 1, 10, 30),
              ),
            ],
          ),
        ],
      );

      await datasource.saveWorkoutSession(updated);

      final history = await datasource.getWorkoutHistory();
      expect(history, hasLength(1));
      expect(history.first.exercises.single.name, 'Deadlift');
    });
  });

  group('getWorkoutHistory', () {
    test('returns sessions sorted by date descending', () async {
      final older = WorkoutSessionModel(
        id: 'older',
        date: DateTime(2026, 2, 1),
        exercises: const [],
      );
      final newer = WorkoutSessionModel(
        id: 'newer',
        date: DateTime(2026, 3, 1),
        exercises: const [],
      );

      await datasource.saveWorkoutSession(older);
      await datasource.saveWorkoutSession(newer);

      final history = await datasource.getWorkoutHistory();
      expect(history.map((session) => session.id), ['newer', 'older']);
    });
  });

  group('deleteWorkoutSession', () {
    test('deletes session when it exists', () async {
      await datasource.saveWorkoutSession(sessionModel);
      await datasource.deleteWorkoutSession('s1');

      final history = await datasource.getWorkoutHistory();
      expect(history, isEmpty);
    });

    test('throws CacheException when session not found', () async {
      expect(
        () => datasource.deleteWorkoutSession('missing'),
        throwsA(isA<CacheException>()),
      );
    });
  });

  group('clearAllWorkoutSessions', () {
    test('removes all persisted workout history', () async {
      await datasource.saveWorkoutSession(sessionModel);
      await datasource.clearAllWorkoutSessions();

      final history = await datasource.getWorkoutHistory();
      expect(history, isEmpty);
    });
  });

  group('active session (SharedPreferences)', () {
    test('saveActiveSession persists session', () async {
      await datasource.saveActiveSession(sessionModel);

      final loaded = await datasource.loadActiveSession();
      expect(loaded?.id, 's1');
    });

    test('loadActiveSession returns null when nothing saved', () async {
      final result = await datasource.loadActiveSession();
      expect(result, isNull);
    });

    test('clearActiveSession removes saved session', () async {
      await datasource.saveActiveSession(sessionModel);
      await datasource.clearActiveSession();

      final result = await datasource.loadActiveSession();
      expect(result, isNull);
    });
  });
}
