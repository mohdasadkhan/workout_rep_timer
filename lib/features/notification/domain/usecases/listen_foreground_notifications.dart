import 'package:fitflow/features/notification/domain/entities/notification_entity.dart';
import 'package:fitflow/features/notification/domain/repositories/notification_repository.dart';

class ListenForegroundNotifications {
  final NotificationRepository _repository;
  const ListenForegroundNotifications(this._repository);

  Stream<NotificationEntity> call() => _repository.foregroundNotifications;
}
