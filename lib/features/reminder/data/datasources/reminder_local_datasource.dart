import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/reminder_schedule.dart';

class ReminderLocalDatasource {
  final SharedPreferences prefs;

  const ReminderLocalDatasource(this.prefs);

  static const String _enabledKey = 'reminders_enabled';
  static const String _hourPrefix = 'reminder_hour_';
  static const String _minutePrefix = 'reminder_minute_';
  static const String _activePrefix = 'reminder_active_';

  Future<bool> loadEnabled() async => prefs.getBool(_enabledKey) ?? false;

  Future<void> saveEnabled(bool value) async =>
      prefs.setBool(_enabledKey, value);

  Future<List<ReminderSchedule>> loadSchedules() async {
    return List.generate(7, (dayIndex) {
      final hour = prefs.getInt('$_hourPrefix$dayIndex') ?? 8;
      final minute = prefs.getInt('$_minutePrefix$dayIndex') ?? 0;
      final isActive = prefs.getBool('$_activePrefix$dayIndex') ?? false;
      return ReminderSchedule(
        dayOfWeek: dayIndex,
        time: TimeOfDay(hour: hour, minute: minute),
        isEnabled: isActive,
      );
    });
  }

  Future<void> saveSchedules(List<ReminderSchedule> schedules) async {
    for (final s in schedules) {
      await prefs.setInt('$_hourPrefix${s.dayOfWeek}', s.time.hour);
      await prefs.setInt('$_minutePrefix${s.dayOfWeek}', s.time.minute);
      await prefs.setBool('$_activePrefix${s.dayOfWeek}', s.isEnabled);
    }
  }
}
