import 'dart:async';

import 'package:app_lifecycle/features/notification/domain/entities/notification_entity.dart';
import 'package:app_lifecycle/features/notification/domain/repositories/notification_repository.dart';
import 'package:app_lifecycle/features/notification/domain/usecases/handle_notification_tap.dart';
import 'package:app_lifecycle/features/notification/domain/usecases/listen_foreground_notifications.dart';
import 'package:app_lifecycle/features/notification/domain/usecases/subscribe_to_topic.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final ListenForegroundNotifications _listenForeground;
  final HandleNotificationTap _handleNotificationTap;
  final SubscribeToTopic _subscribeToTopic;
  final NotificationRepository _repository;

  StreamSubscription<NotificationEntity>? _foregroundSub;
  StreamSubscription<NotificationEntity>? _tapSub;

  NotificationBloc({
    required ListenForegroundNotifications listenForeground,
    required HandleNotificationTap handleNotificationTap,
    required SubscribeToTopic subscribeToTopic,
    required NotificationRepository repository,
  }) : _listenForeground = listenForeground,
       _handleNotificationTap = handleNotificationTap,
       _subscribeToTopic = subscribeToTopic,
       _repository = repository,
       super(const NotificationState.initial()) {
    on<NotificationListenerStarted>(_onNotificationListenerStarted);
    on<ForegroundNotificationReceived>(_onForegroundNotificationReceived);
    on<NotificationTapped>(_onNotificationTapped);
    on<TopicSubscriptionRequested>(_onTopicSubscriptionRequested);
  }

  Future<void> _onNotificationListenerStarted(
    NotificationListenerStarted event,
    Emitter<NotificationState> emit,
  ) async {
    final result = await _handleNotificationTap.getInitialTap();
    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (entity) {
        if (entity != null) {
          add(NotificationTapped(entity));
        }
      },
    );
    _foregroundSub = _listenForeground.call().listen((entity) {
      add(ForegroundNotificationReceived(entity));
    });
    _tapSub = _handleNotificationTap.tapStream().listen((entity) {
      add(NotificationTapped(entity));
    });
  }

  Future<void> _onForegroundNotificationReceived(
    ForegroundNotificationReceived event,
    Emitter<NotificationState> emit,
  ) async {
    await _repository.showLocalNotification(event.notification);
    emit(state.copyWith(lastNotification: event.notification));
  }

  Future<void> _onNotificationTapped(
    NotificationTapped event,
    Emitter<NotificationState> emit,
  ) async {
    final target = event.notificationEntity.targetScreen;
    emit(
      state.copyWith(
        lastNotification: event.notificationEntity,
        navigationTarget: target,
      ),
    );
  }

  Future<void> _onTopicSubscriptionRequested(
    TopicSubscriptionRequested event,
    Emitter<NotificationState> emit,
  ) async {
    final result = await _subscribeToTopic(event.topic);
    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (_) => null,
    );
  }

  @override
  Future<void> close() {
    _foregroundSub?.cancel();
    _tapSub?.cancel();
    return super.close();
  }
}
