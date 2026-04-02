import 'package:app_lifecycle/core/failure/failure.dart';
import 'package:app_lifecycle/features/notification/data/datasources/fcm_remote_datasource.dart';
import 'package:app_lifecycle/features/notification/data/datasources/local_notification_datasource.dart';
import 'package:app_lifecycle/features/notification/domain/entities/notification_entity.dart';
import 'package:app_lifecycle/features/notification/domain/repositories/notification_repository.dart';
import 'package:dartz/dartz.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final FcmRemoteDatasource _fcmRemoteDatasource;
  final LocalNotificationDatasource _localDataSource;

  const NotificationRepositoryImpl({
    required FcmRemoteDatasource fcmRemoteDatasource,
    required LocalNotificationDatasource localDataSource,
  }) : _fcmRemoteDatasource = fcmRemoteDatasource,
       _localDataSource = localDataSource;

  @override
  Stream<NotificationEntity> get foregroundNotifications =>
      _fcmRemoteDatasource.foregroundMessages;

  @override
  Future<Either<Failure, NotificationEntity?>> getInitialNotification() async {
    try {
      final model = await _fcmRemoteDatasource.getInitialMessage();
      return Right(model);
    } catch (e) {
      return Left(Failure(message: 'Failued to get initial message : $e'));
    }
  }

  @override
  Stream<NotificationEntity> get notificationTaps =>
      _fcmRemoteDatasource.messageOpenedApp;

  @override
  FutureEitherVoid showLocalNotification(NotificationEntity entity) async {
    try {
      await _localDataSource.show(entity);
      return const Right(unit);
    } catch (e) {
      return Left(Failure(message: 'Failed to show local notification: $e'));
    }
  }

  @override
  FutureEitherVoid subscribeToTopic(String topic) async {
    try {
      await _fcmRemoteDatasource.subscribeToTopic(topic);
      return const Right(unit);
    } catch (e) {
      return Left(Failure(message: 'Failed to subscribe to topic: $e'));
    }
  }

  @override
  FutureEitherVoid unsubscribeFromTopic(String topic) async {
    try {
      await _fcmRemoteDatasource.unsubscribeFromTopic(topic);
      return const Right(unit);
    } catch (e) {
      return Left(Failure(message: 'Failed to unsubscribe from topic: $e'));
    }
  }
}
