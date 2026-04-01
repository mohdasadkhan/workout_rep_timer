part of 'notification_bloc.dart';

sealed class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object> get props => [];
}

final class NotificationListenerStarted extends NotificationEvent {
  const NotificationListenerStarted();
}

final class ForegroundNotificationReceived extends NotificationEvent {
  final NotificationEntity notification;
  const ForegroundNotificationReceived(this.notification);
}

final class NotificationTapped extends NotificationEvent {
  final NotificationEntity notificationEntity;
  const NotificationTapped(this.notificationEntity);
}

final class TopicSubscriptionRequested extends NotificationEvent {
  final String topic;
  const TopicSubscriptionRequested(this.topic);
}
