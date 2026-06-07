import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationDebugPanel extends StatefulWidget {
  const NotificationDebugPanel({super.key});

  @override
  State<NotificationDebugPanel> createState() => _NotificationDebugPanelState();
}

class _NotificationDebugPanelState extends State<NotificationDebugPanel> {
  final _notifications = FlutterLocalNotificationsPlugin();
  String _log = 'Tap a button to debug...';

  void _append(String msg) {
    setState(() => _log = '$_log\n$msg');
    debugPrint('[NotifDebug] $msg');
  }

  Future<void> _testImmediate() async {
    setState(() => _log = '--- IMMEDIATE TEST ---');
    try {
      await _notifications.show(
        id: 999,
        title: '🔥 Immediate Test',
        body: 'If you see this, basic notifications work!',
        notificationDetails: NotificationDetails(
          android: AndroidNotificationDetails(
            'workout_reminder_channel',
            'Workout Reminders',
            importance: Importance.max,
            priority: Priority.max,
          ),
        ),
      );
      _append('✅ show() called successfully');
    } catch (e) {
      _append('❌ show() threw: $e');
    }
  }

  Future<void> _testScheduledSoon() async {
    setState(() => _log = '--- SCHEDULED IN 15s TEST ---');
    try {
      final now = tz.TZDateTime.now(tz.local);
      final scheduled = now.add(const Duration(seconds: 15));
      _append('Now:       ${now.toString()}');
      _append('Scheduled: ${scheduled.toString()}');
      _append('tz.local:  ${tz.local.name}');

      await _notifications.zonedSchedule(
        id: 998,
        title: '⏰ Scheduled Test',
        body: 'Scheduled 15s after you tapped the button',
        scheduledDate: scheduled,
        notificationDetails: NotificationDetails(
          android: AndroidNotificationDetails(
            'workout_reminder_channel',
            'Workout Reminders',
            importance: Importance.max,
            priority: Priority.max,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
      _append('✅ zonedSchedule() called — wait 15 seconds...');
    } catch (e) {
      _append('❌ zonedSchedule() threw: $e');
    }
  }

  Future<void> _checkPending() async {
    setState(() => _log = '--- PENDING NOTIFICATIONS ---');
    try {
      final pending = await _notifications.pendingNotificationRequests();
      _append('Count: ${pending.length}');
      for (final n in pending) {
        _append('ID: ${n.id} | Title: ${n.title} | Body: ${n.body}');
      }
      if (pending.isEmpty) {
        _append('⚠️ Nothing scheduled — scheduling failed silently');
      }
    } catch (e) {
      _append('❌ pendingNotificationRequests() threw: $e');
    }
  }

  Future<void> _checkPermissions() async {
    setState(() => _log = '--- PERMISSIONS CHECK ---');
    try {
      final android = _notifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();

      if (android == null) {
        _append('⚠️ Not running on Android');
        return;
      }

      final granted = await android.areNotificationsEnabled();
      _append('Notifications enabled: $granted');

      final exactAlarm = await android.canScheduleExactNotifications();
      _append('Can schedule exact alarms: $exactAlarm');

      if (exactAlarm == false) {
        _append('❌ EXACT ALARM PERMISSION MISSING!');
        _append('   Add to AndroidManifest.xml:');
        _append(
          '   <uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM"/>',
        );
        _append('   OR request it:');
        _append('   android.requestExactAlarmsPermission()');
      }
    } catch (e) {
      _append('❌ Permission check threw: $e');
    }
  }

  void _checkTimezone() {
    setState(() => _log = '--- TIMEZONE CHECK ---');
    final now = tz.TZDateTime.now(tz.local);
    _append('tz.local name: ${tz.local.name}');
    _append('TZDateTime.now: $now');
    _append('DateTime.now:   ${DateTime.now()}');
    _append('UTC offset: ${now.timeZoneOffset}');

    if (tz.local.name == 'UTC') {
      _append('❌ TIMEZONE IS UTC! Call tz.setLocalLocation() in main()');
      _append('   Expected: Asia/Kolkata for IST');
    } else {
      _append('✅ Timezone looks correct');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black87,
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '🐛 Notification Debugger',
              style: TextStyle(
                color: Colors.greenAccent,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                _btn('Immediate', _testImmediate, Colors.green),
                _btn('In 15s', _testScheduledSoon, Colors.orange),
                _btn('Pending?', _checkPending, Colors.blue),
                _btn('Permissions', _checkPermissions, Colors.red),
                _btn('Timezone', _checkTimezone, Colors.purple),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              constraints: const BoxConstraints(maxHeight: 220),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(8),
              ),
              child: SingleChildScrollView(
                child: Text(
                  _log,
                  style: const TextStyle(
                    color: Colors.greenAccent,
                    fontFamily: 'monospace',
                    fontSize: 11,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _btn(String label, VoidCallback onTap, Color color) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        textStyle: const TextStyle(fontSize: 11),
      ),
      child: Text(label),
    );
  }
}
