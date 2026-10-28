import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:fitflow/core/database/app_database.dart';
import 'package:fitflow/core/failure/cache_exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/exercise_model.dart';
import '../models/set_model.dart';
import '../models/workout_session_model.dart';

abstract class WorkoutLocalDatasource {
  Future<void> saveWorkoutSession(WorkoutSessionModel session);
  Future<List<WorkoutSessionModel>> getWorkoutHistory();
  Future<void> deleteWorkoutSession(String sessionId);
  Future<void> saveActiveSession(WorkoutSessionModel session);
  Future<WorkoutSessionModel?> loadActiveSession();
  Future<void> clearActiveSession();
  Future<void> clearAllWorkoutSessions();
}

class WorkoutLocalDatasourceImpl implements WorkoutLocalDatasource {
  static const _activeSessionKey = 'active_workout_session';
  final AppDatabase _database;

  const WorkoutLocalDatasourceImpl({required AppDatabase database})
    : _database = database;

  @override
  Future<void> saveWorkoutSession(WorkoutSessionModel session) async {
    try {
      await _database.transaction(() async {
        await _deleteSessionGraph(session.id);

        await _database
            .into(_database.workoutSessions)
            .insert(
              WorkoutSessionsCompanion.insert(
                id: session.id,
                date: session.date,
                notes: Value(session.notes),
              ),
            );

        for (final exercise in session.exercises) {
          await _database
              .into(_database.workoutExercises)
              .insert(
                WorkoutExercisesCompanion.insert(
                  id: exercise.id,
                  sessionId: session.id,
                  name: exercise.name,
                ),
              );

          for (final set in exercise.sets) {
            await _database
                .into(_database.workoutSetRows)
                .insert(
                  WorkoutSetRowsCompanion.insert(
                    id: set.id,
                    exerciseId: exercise.id,
                    weightKg: set.weightKg,
                    reps: set.reps,
                    performedAt: set.performedAt,
                  ),
                );
          }
        }
      });
    } catch (e) {
      throw CacheException(message: 'Failed to save workout: $e');
    }
  }

  @override
  Future<List<WorkoutSessionModel>> getWorkoutHistory() async {
    try {
      final sessionRows =
          await (_database.select(_database.workoutSessions)
                ..orderBy([(row) => OrderingTerm.desc(row.date)]))
              .get();

      final sessions = <WorkoutSessionModel>[];
      for (final sessionRow in sessionRows) {
        final exerciseRows =
            await (_database.select(_database.workoutExercises)
                  ..where((row) => row.sessionId.equals(sessionRow.id)))
                .get();

        final exercises = <ExerciseModel>[];
        for (final exerciseRow in exerciseRows) {
          final setRows =
              await (_database.select(_database.workoutSetRows)
                    ..where((row) => row.exerciseId.equals(exerciseRow.id)))
                  .get();

          exercises.add(
            ExerciseModel(
              id: exerciseRow.id,
              name: exerciseRow.name,
              sets: setRows
                  .map(
                    (row) => SetModel(
                      id: row.id,
                      weightKg: row.weightKg,
                      reps: row.reps,
                      performedAt: row.performedAt,
                    ),
                  )
                  .toList(),
            ),
          );
        }

        sessions.add(
          WorkoutSessionModel(
            id: sessionRow.id,
            date: sessionRow.date,
            notes: sessionRow.notes,
            exercises: exercises,
          ),
        );
      }

      return sessions;
    } catch (e) {
      throw CacheException(message: 'Failed to load history: $e');
    }
  }

  @override
  Future<void> deleteWorkoutSession(String sessionId) async {
    try {
      final existing =
          await (_database.select(_database.workoutSessions)
                ..where((row) => row.id.equals(sessionId)))
              .getSingleOrNull();

      if (existing == null) {
        throw CacheException(message: 'Session not found');
      }

      await _deleteSessionGraph(sessionId);
    } catch (e) {
      if (e is CacheException) rethrow;
      throw CacheException(message: 'Failed to delete workout: $e');
    }
  }

  @override
  Future<void> saveActiveSession(WorkoutSessionModel session) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_activeSessionKey, jsonEncode(session.toJson()));
    } catch (e) {
      throw CacheException(message: 'Failed to save active session: $e');
    }
  }

  @override
  Future<WorkoutSessionModel?> loadActiveSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = prefs.getString(_activeSessionKey);
      if (jsonStr == null) return null;
      return WorkoutSessionModel.fromJson(
        jsonDecode(jsonStr) as Map<String, dynamic>,
      );
    } catch (e) {
      throw CacheException(message: 'Failed to load active session: $e');
    }
  }

  @override
  Future<void> clearActiveSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_activeSessionKey);
    } catch (e) {
      throw CacheException(message: 'Failed to clear active session: $e');
    }
  }

  @override
  Future<void> clearAllWorkoutSessions() async {
    try {
      await _database.clearAllWorkoutData();
    } catch (e) {
      throw CacheException(message: 'Failed to clear workout data: $e');
    }
  }

  Future<void> _deleteSessionGraph(String sessionId) async {
    final exerciseRows =
        await (_database.select(_database.workoutExercises)
              ..where((row) => row.sessionId.equals(sessionId)))
            .get();

    for (final exercise in exerciseRows) {
      await (_database.delete(_database.workoutSetRows)
            ..where((row) => row.exerciseId.equals(exercise.id)))
          .go();
    }

    await (_database.delete(_database.workoutExercises)
          ..where((row) => row.sessionId.equals(sessionId)))
        .go();
    await (_database.delete(_database.workoutSessions)
          ..where((row) => row.id.equals(sessionId)))
        .go();
  }
}
