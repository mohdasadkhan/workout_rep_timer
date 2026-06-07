import 'package:flutter/material.dart';

abstract class ReminderNotificationService {
  Future<void> scheduleWeeklyReminder({
    required int id,
    required String title,
    required String body,
    required int dayOfWeek,
    required TimeOfDay time,
  });

  Future<void> cancelReminder(int id);

  Future<void> cancelAllReminders();
}
