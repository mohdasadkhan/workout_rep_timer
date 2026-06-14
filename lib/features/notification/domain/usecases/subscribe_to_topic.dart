import 'package:fitflow/core/failure/failure.dart';
import 'package:fitflow/features/notification/domain/repositories/notification_repository.dart';
import 'package:dartz/dartz.dart';

class SubscribeToTopic {
  final NotificationRepository _repository;
  const SubscribeToTopic(this._repository);

  Future<Either<Failure, Unit>> call(String topic) =>
      _repository.subscribeToTopic(topic);
}
