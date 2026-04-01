import 'package:app_lifecycle/core/failure/failure.dart';
import 'package:app_lifecycle/features/notification/domain/entities/notification_entity.dart';
import 'package:dartz/dartz.dart';

typedef FutureEitherVoid = Future<Either<Failure, Unit>>;

abstract interface class NotificationRepository {
  Stream<NotificationEntity> get foregroundNotifications;

  Future<Either<Failure, NotificationEntity?>> getInitialNotification();

  Stream<NotificationEntity> get notificationTaps;

  FutureEitherVoid subscribeToTopic(String topic);

  FutureEitherVoid unsubscribeFromTopic(String topic);

  FutureEitherVoid showLocalNotification(NotificationEntity entity);
}
