import 'package:app_lifecycle/core/failure/failure.dart';
import 'package:app_lifecycle/features/notification/domain/entities/notification_entity.dart';
import 'package:app_lifecycle/features/notification/domain/repositories/notification_repository.dart';
import 'package:dartz/dartz.dart';

class HandleNotificationTap {
  final NotificationRepository _repository;
  const HandleNotificationTap(this._repository);

  Stream<NotificationEntity> tapStream() => _repository.notificationTaps;

  Future<Either<Failure, NotificationEntity?>> getInitialTap() =>
      _repository.getInitialNotification();
}
