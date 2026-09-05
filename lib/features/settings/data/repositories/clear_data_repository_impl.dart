// lib/features/settings/data/repositories/clear_data_repository_impl.dart
import 'package:dartz/dartz.dart';
import 'package:fitflow/core/failure/failure.dart';
import 'package:fitflow/features/reminder/domain/repositories/reminder_notification_service.dart';
import 'package:fitflow/features/settings/data/datasources/sound_local_datasource.dart';
import 'package:fitflow/features/settings/data/datasources/theme_local_datasource.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/repositories/clear_data_repository.dart';
import '../../../rep_tracker/data/datasources/workout_local_datasource.dart';

class ClearDataRepositoryImpl implements ClearDataRepository {
  final WorkoutLocalDatasource workoutDatasource;
  final ReminderNotificationService notificationService;
  final SoundLocalDatasource soundDatasource;
  final ThemeLocalDatasource themeDatasource;

  ClearDataRepositoryImpl({
    required this.workoutDatasource,
    required this.notificationService,
    required this.soundDatasource,
    required this.themeDatasource,
  });

  @override
  Future<Either<Failure, Unit>> clearAllData() async {
    try {
      await workoutDatasource.clearAllWorkoutSessions();
      await workoutDatasource.clearActiveSession();

      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      await _clearReminders();

      return const Right(unit);
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to clear all data: $e'));
    }
  }

  Future<void> _clearReminders() async {
    try {
      await notificationService.cancelAllReminders();
    } catch (e) {
      debugPrint('Warning: Failed to clear reminders: $e');
    }
  }
}
