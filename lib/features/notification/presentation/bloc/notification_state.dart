part of 'notification_bloc.dart';

final class NotificationState extends Equatable {
  final NotificationEntity? lastNotification;
  final String? navigationTarget;
  final String? errorMessage;
  final bool isLoading;
  const NotificationState({
    this.lastNotification,
    this.navigationTarget,
    this.errorMessage,
    this.isLoading = false,
  });

  const NotificationState.initial()
    : lastNotification = null,
      navigationTarget = null,
      errorMessage = null,
      isLoading = false;

  NotificationState copyWith({
    NotificationEntity? lastNotification,
    String? navigationTarget,
    String? errorMessage,
    bool? isLoading,
  }) {
    return NotificationState(
      lastNotification: lastNotification ?? this.lastNotification,
      navigationTarget: navigationTarget ?? this.navigationTarget,
      errorMessage: errorMessage ?? this.errorMessage,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [lastNotification, navigationTarget, errorMessage, isLoading];
}
