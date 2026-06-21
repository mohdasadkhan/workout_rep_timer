// lib/features/settings/data/repositories/clear_data_repository_impl.dart
import 'package:dartz/dartz.dart';
import 'package:fitflow/core/failure/failure.dart';
import 'package:fitflow/features/reminder/data/datasources/reminder_local_datasource.dart';
import 'package:fitflow/features/reminder/domain/repositories/reminder_notification_service.dart';
import 'package:fitflow/features/settings/data/datasources/sound_local_datasource.dart';
import 'package:fitflow/features/settings/data/datasources/theme_local_datasource.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/repositories/clear_data_repository.dart';
import '../../../rep_tracker/data/datasources/workout_local_datasource.dart';

class ClearDataRepositoryImpl implements ClearDataRepository {
  final WorkoutLocalDatasource workoutDatasource;
  final ReminderNotificationService notificationService;
  final SoundLocalDatasource soundDatasource;
  final ThemeLocalDatasource themeDatasource;
  final HiveInterface hive;

  ClearDataRepositoryImpl({
    required this.workoutDatasource,
    required this.notificationService,
    required this.soundDatasource,
    required this.themeDatasource,
    required this.hive,
  });

  @override
  Future<Either<Failure, Unit>> clearAllData() async {
    try {
      // 1. Clear Hive (workouts)
      const boxName = 'workout_sessions';
      if (hive.isBoxOpen(boxName)) {
        final box = hive.box<String>(boxName);
        await box.clear();
        await box.close();
      }
      await hive.deleteBoxFromDisk(boxName);

      // 2. Clear SharedPreferences completely
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      // 3. Clear active session explicitly
      await workoutDatasource.clearActiveSession();

      // 4. Clear Reminder Settings + Cancel all scheduled notifications
      await _clearReminders();

      // 5. Optional: Reset sound & theme to defaults if needed
      // await soundDatasource.resetToDefaults();
      // await themeDatasource.resetToDefaults();

      return const Right(unit);
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to clear all data: $e'));
    }
  }

  Future<void> _clearReminders() async {
    try {
      // Cancel all pending notifications
      await notificationService.cancelAllReminders();
    } catch (e) {
      // Don't fail the whole clear if reminder clearing fails
      debugPrint('Warning: Failed to clear reminders: $e');
    }
  }
}
