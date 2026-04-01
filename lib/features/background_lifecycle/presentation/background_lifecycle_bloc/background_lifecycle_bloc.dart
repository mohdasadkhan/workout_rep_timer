import 'dart:async';
import 'dart:developer';

import 'package:app_lifecycle/features/background_lifecycle/domain/entities/timer_session.dart';
import 'package:app_lifecycle/features/background_lifecycle/domain/repositories/timer_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'background_lifecycle_event.dart';
part 'background_lifecycle_state.dart';

class BackgroundLifecycleBloc extends Bloc<TimerEvent, TimerState> {
  final TimerRepository _timerRepository;
BackgroundLifecycleBloc({required TimerRepository timerRepository})
    : _timerRepository = timerRepository,
      super(TimerInitial()) {
    on<LoadTimerEvent>(_loadTimerEvent);
    on<StartTimerEvent>(_startTimerEvent);
    on<PauseTimerEvent>(_pauseTimerEvent);

    on<CompleteTimerEvent>(_completeTimerEvent);
    on<ResetTimerEvent>(_resetTimerEvent);
    on<_TickEvent>(_onTick);
  }
  Timer? _ticker;
  int _elapsedSeconds = 0;
  int _setsCompleted = 0;

  Future<void> _loadTimerEvent(
    LoadTimerEvent event,
    Emitter<TimerState> emit,
  ) async {
    try {
      final session = await _timerRepository.loadSession();
      _elapsedSeconds = session.elapsedSeconds;
      _setsCompleted = session.setsCompleted;
      emit(TimerLoaded(timerSession: session));
    } catch (e) {
      emit(const TimerError(message: 'Failed to load session'));
    }
  }

  void _startTimerEvent(StartTimerEvent event, Emitter<TimerState> emit) {
    log('inside start timer event');
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      _elapsedSeconds++;
      add(const _TickEvent());
    });
    emit(TimerLoaded(timerSession: _currentSession(isRunning: true)));
  }

  Future<void> _pauseTimerEvent(
    PauseTimerEvent event,
    Emitter<TimerState> emit,
  ) async {
    _ticker?.cancel();
    _ticker = null;
    final session = _currentSession(isRunning: true);
    await _timerRepository.saveSession(session);
    emit(TimerLoaded(timerSession: session));
  }

  void _completeTimerEvent(
    CompleteTimerEvent event,
    Emitter<TimerState> emit,
  ) async {
    _ticker?.cancel();
    _ticker = null;
    _setsCompleted++;
    _elapsedSeconds = 0;
    emit(TimerLoaded(timerSession: _currentSession(isRunning: false)));
  }

  Future<void> _resetTimerEvent(
    ResetTimerEvent event,
    Emitter<TimerState> emit,
  ) async {
    _ticker?.cancel();
    _ticker = null;
    _elapsedSeconds = 0;
    _setsCompleted = 0;
    await _timerRepository.clearSession();
    emit(const TimerInitial());
  }

  TimerSession _currentSession({required bool isRunning}) => TimerSession(
    elapsedSeconds: _elapsedSeconds,
    isRunning: isRunning,
    setsCompleted: _setsCompleted,
  );

  void _onTick(_TickEvent event, Emitter<TimerState> emit) {
    emit(TimerLoaded(timerSession: _currentSession(isRunning: true)));
  }

  @override
  Future<void> close() {
    _ticker?.cancel();
    return super.close();
  }
}

class _TickEvent extends TimerEvent {
  const _TickEvent();
}
