import 'dart:convert';
import 'package:app_lifecycle/core/failure/cache_exceptions.dart';
import 'package:hive/hive.dart';

import '../models/workout_session_model.dart';

abstract class WorkoutLocalDatasource {
  Future<void> saveWorkoutSession(WorkoutSessionModel session);
  Future<List<WorkoutSessionModel>> getWorkoutHistory();
}

class WorkoutLocalDatasourceImpl implements WorkoutLocalDatasource {
  static const _boxName = 'workout_sessions';
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
}
