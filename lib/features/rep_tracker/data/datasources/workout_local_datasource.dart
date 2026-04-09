import 'dart:convert';
import 'package:app_lifecycle/core/failure/cache_exceptions.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/workout_session_model.dart';

abstract class WorkoutLocalDatasource {
  Future<void> saveWorkoutSession(WorkoutSessionModel session);
  Future<List<WorkoutSessionModel>> getWorkoutHistory();
  Future<void> saveActiveSession(WorkoutSessionModel session);
  Future<WorkoutSessionModel?> loadActiveSession();
  Future<void> clearActiveSession();
}

class WorkoutLocalDatasourceImpl implements WorkoutLocalDatasource {
  static const _boxName = 'workout_sessions';
  static const _activeSessionKey = 'active_workout_session';
  final HiveInterface hive;

  const WorkoutLocalDatasourceImpl({required this.hive});

  Future<Box<String>> get _box async => hive.isBoxOpen(_boxName)
      ? hive.box<String>(_boxName)
      : await hive.openBox<String>(_boxName);

  @override
  Future<void> saveWorkoutSession(WorkoutSessionModel session) async {
    try {
      final box = await _box;

      await box.put(session.id, jsonEncode(session.toJson()));
    } catch (e) {
      throw CacheException(message: 'Failed to save workout: $e');
    }
  }

  @override
  Future<List<WorkoutSessionModel>> getWorkoutHistory() async {
    try {
      final box = await _box;
      return box.values
          .map(
            (raw) => WorkoutSessionModel.fromJson(
              jsonDecode(raw) as Map<String, dynamic>,
            ),
          )
          .toList()
        ..sort((a, b) => b.date.compareTo(a.date));
    } catch (e) {
      throw CacheException(message: 'Failed to load history: $e');
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
}
