import 'dart:convert';

import 'package:app_lifecycle/core/failure/cache_exceptions.dart';
import 'package:app_lifecycle/features/rep_tracker/data/datasources/workout_local_datasource.dart';
import 'package:app_lifecycle/features/rep_tracker/data/models/exercise_model.dart';
import 'package:app_lifecycle/features/rep_tracker/data/models/set_model.dart';
import 'package:app_lifecycle/features/rep_tracker/data/models/workout_session_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

// This annotation tells build_runner to generate typed mocks for these classes
@GenerateMocks([HiveInterface, Box])
import 'workout_local_datasource_test.mocks.dart'; // generated file

void main() {
  late MockHiveInterface mockHive;
  late MockBox<String> mockBox;
  late WorkoutLocalDatasourceImpl datasource;

  final sessionModel = WorkoutSessionModel(
    id: 's1',
    date: DateTime(2026),
    exercises: [
      ExerciseModel(
        id: 'e1',
        name: 'Squat',
        sets: [
          SetModel(
            id: 'set1',
            weightKg: 100,
            reps: 5,
            performedAt: DateTime(2026),
          ),
        ],
      ),
    ],
  );

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    mockHive = MockHiveInterface();
    mockBox = MockBox<String>();
    datasource = WorkoutLocalDatasourceImpl(hive: mockHive);

    // Stub BEFORE datasource is used — these are safe now with typed mocks
    when(mockHive.isBoxOpen('workout_sessions')).thenReturn(true);
    when(mockHive.box<String>('workout_sessions')).thenReturn(mockBox);
  });

  group('saveWorkoutSession', () {
    test('stores encoded json in hive box', () async {
      final jsonValue = jsonEncode(sessionModel.toJson());

      // Stub the put call — void return, so use thenAnswer with Future.value()
      when(mockBox.put('s1', jsonValue)).thenAnswer((_) async {});

      await datasource.saveWorkoutSession(sessionModel);

      verify(mockBox.put('s1', jsonValue)).called(1);
    });

    test('throws CacheException when hive throws', () async {
      when(mockBox.put(any, any)).thenThrow(Exception('hive error'));

      expect(
        () => datasource.saveWorkoutSession(sessionModel),
        throwsA(isA<CacheException>()),
      );
    });
  });

  group('getWorkoutHistory', () {
    test('parses and returns sorted sessions', () async {
      when(mockBox.values).thenReturn([jsonEncode(sessionModel.toJson())]);

      final result = await datasource.getWorkoutHistory();

      expect(result, hasLength(1));
      expect(result.first.id, 's1');
    });

    test('throws CacheException when hive throws', () async {
      when(mockBox.values).thenThrow(Exception('read error'));

      expect(
        () => datasource.getWorkoutHistory(),
        throwsA(isA<CacheException>()),
      );
    });
  });

  group('deleteWorkoutSession', () {
    test('deletes session when key exists', () async {
      when(mockBox.containsKey('s1')).thenReturn(true);
      when(mockBox.delete('s1')).thenAnswer((_) async {});

      await datasource.deleteWorkoutSession('s1');

      verify(mockBox.delete('s1')).called(1);
    });

    test('throws CacheException when session not found', () async {
      when(mockBox.containsKey('missing')).thenReturn(false);

      expect(
        () => datasource.deleteWorkoutSession('missing'),
        throwsA(isA<CacheException>()),
      );
    });
  });

  // SharedPreferences uses fake/mock values — no Hive involved here
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