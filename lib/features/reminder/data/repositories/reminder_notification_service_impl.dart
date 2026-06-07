import 'package:flutter/material.dart';

import '../../domain/repositories/reminder_notification_service.dart';

import 'package:app_lifecycle/core/services/notification_reminder_service.dart';

class ReminderNotificationServiceImpl implements ReminderNotificationService {
  const ReminderNotificationServiceImpl();

  @override
  Future<void> scheduleWeeklyReminder({
    required int id,
    required String title,
    required String body,
    required int dayOfWeek,
    required TimeOfDay time,
  }) async {
    await NotificationReminderService.scheduleWeeklyReminder(
      id: id,
      title: title,
      body: body,
      dayOfWeek: dayOfWeek,
      time: time,
    );
  }

  @override
  Future<void> cancelReminder(int id) async {
    await NotificationReminderService.cancelReminder(id);
  }

  @override
  Future<void> cancelAllReminders() async {
    for (int i = 100; i < 107; i++) {
      await NotificationReminderService.cancelReminder(i);
    }
  }
}
