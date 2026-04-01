//SRP only FCM Responsibilities here

import 'package:app_lifecycle/features/notification/data/models/notification_model.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

abstract interface class FcmRemoteDatasource {
  Stream<NotificationModel> get foregroundMessages;
  Stream<NotificationModel> get messageOpenedApp;
  Future<NotificationModel?> getInitialMessage();
  Future<void> subscribeToTopic(String topic);
  Future<void> unsubscribeFromTopic(String topic);
}

class FcmRemoteDatasourceImpl extends FcmRemoteDatasource {
  final FirebaseMessaging _messaging;
  FcmRemoteDatasourceImpl({required FirebaseMessaging messaging})
    : _messaging = messaging;

  @override
  Stream<NotificationModel> get foregroundMessages =>
      FirebaseMessaging.onMessage.map(NotificationModel.fromRemoteMessage);

  @override
  Future<NotificationModel?> getInitialMessage() async {
    final message = await _messaging.getInitialMessage();
    if (message == null) return null;
    return NotificationModel.fromRemoteMessage(message);
  }

  @override
  Stream<NotificationModel> get messageOpenedApp => FirebaseMessaging
      .onMessageOpenedApp
      .map(NotificationModel.fromRemoteMessage);

  @override
  Future<void> subscribeToTopic(String topic) =>
      _messaging.subscribeToTopic(topic);

  @override
  Future<void> unsubscribeFromTopic(String topic) =>
      _messaging.unsubscribeFromTopic(topic);
}
