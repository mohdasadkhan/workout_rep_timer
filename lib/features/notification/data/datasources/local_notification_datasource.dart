import 'package:fitflow/features/notification/domain/entities/notification_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

abstract interface class LocalNotificationDatasource {
  Future<void> initialize();
  Future<void> show(NotificationEntity entity);
}

class LocalNotificationDataSourceImpl extends LocalNotificationDatasource {
  final FlutterLocalNotificationsPlugin _plugin;

  static const String _channelId = 'high_importance_channel';
  static const String _channelName = 'High Importance Notifications';

  LocalNotificationDataSourceImpl({
    required FlutterLocalNotificationsPlugin plugin,
  }) : _plugin = plugin;

  @override
  Future<void> initialize() async {
    try {
      const androidChannel = AndroidNotificationChannel(
        _channelId,
        _channelName,
        importance: Importance.high,
      );
      await _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.createNotificationChannel(androidChannel);
      await _plugin.initialize(
        settings: const InitializationSettings(
          android: AndroidInitializationSettings('@mipmap/ic_launcher_light'),
          iOS: DarwinInitializationSettings(),
        ),
      );
    } catch (e, stack) {
      // Non-critical — app should still work without notifications
      debugPrint('⚠️ Notification init failed: $e');
      debugPrint('$stack');
    }
  }

  @override
  Future<void> show(NotificationEntity entity) async {
    const NotificationDetails details = NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
        _channelName,
        importance: Importance.high,
        priority: Priority.high,
      ),
    );
    await _plugin.show(
      id: entity.id.hashCode,
      title: entity.title,
      body: entity.body,
      notificationDetails: details,
    );
  }
}
