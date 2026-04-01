import 'package:app_lifecycle/features/notification/domain/entities/notification_entity.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

//Model knows about Firebase. Entity does not


class NotificationModel extends NotificationEntity {
  NotificationModel({
    required super.id,
    super.title,
    super.body,
    required super.data,
  });

  factory NotificationModel.fromRemoteMessage(RemoteMessage message) {
    return NotificationModel(
      id: message.messageId ?? DateTime.now().toIso8601String(),
      title: message.notification?.title,
      body: message.notification?.body,
      data: Map<String, dynamic>.from(message.data),
    );
  }
}
