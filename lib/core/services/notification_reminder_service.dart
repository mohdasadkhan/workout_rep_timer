import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationReminderService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static bool _initialized = false;

  static Future<void> init() async {
    if (_initialized) return;

    tz.initializeTimeZones();

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    await _notifications.initialize(
      settings: const InitializationSettings(
        android: androidInit,
        iOS: iosInit,
      ),
    );

    _initialized = true;
  }

  static Future<void> scheduleWeeklyReminder({
    required int id,
    required String title,
    required String body,
    required int dayOfWeek,
    required TimeOfDay time,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'workout_reminder_channel',
      'Workout Reminders',
      channelDescription: 'Weekly workout reminders to keep you consistent',
      importance: Importance.high,
      priority: Priority.high,
      enableVibration: true,
      playSound: true,
    );
    const iosDetails = DarwinNotificationDetails(
      sound: 'default',
      badgeNumber: 1,
    );
    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    final scheduledDate = _nextInstanceOfDayAndTime(dayOfWeek, time);

    await _notifications.zonedSchedule(
      id: id,
      title: title,
      body: body,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      notificationDetails: notificationDetails,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      scheduledDate: scheduledDate,
    );
  }

  static Future<void> cancelReminder(int id) async {
    await _notifications.cancel(id: id);
  }

  static tz.TZDateTime _nextInstanceOfDayAndTime(
    int dayOfWeek,
    TimeOfDay time,
  ) {
    final int targetWeekday = dayOfWeek == 0 ? 7 : dayOfWeek;

    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);

    tz.TZDateTime candidate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    while (candidate.weekday != targetWeekday || candidate.isBefore(now)) {
      candidate = candidate.add(const Duration(days: 1));
    }

    return candidate;
  }
}
