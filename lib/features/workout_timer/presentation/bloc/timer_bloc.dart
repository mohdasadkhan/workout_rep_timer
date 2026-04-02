import 'dart:async';
import 'dart:developer';
import 'package:app_lifecycle/core/utils/foreground_task_handler.dart';
import 'package:app_lifecycle/features/workout_timer/domain/entity/workout_config.dart';
import 'package:app_lifecycle/features/workout_timer/domain/entity/workout_phase.dart';
import 'package:app_lifecycle/features/workout_timer/domain/usecases/generate_workout_usecase.dart';
import 'package:app_lifecycle/features/workout_timer/presentation/bloc/timer_effect.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';

part 'timer_event.dart';
part 'timer_state.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  Timer? _ticker;
  WorkoutConfig _currentConfig = const WorkoutConfig();
  final _effectController = StreamController<TimerEffect>.broadcast();
  List<WorkoutPhase> _sequence = [];
  int _currentIndex = 0;
  int _remainingSeconds = 0;

  TimerBloc() : super(TimerInitial(const WorkoutConfig())) {
    FlutterForegroundTask.addTaskDataCallback(_onReceiveTaskData);
    on<TimerStarted>(_onStarted);
    on<TimerPaused>(_onPaused);
    on<TimerResumed>(_onResumed);
    on<TimerTicked>(_onTicked);
    on<TimerNextPhase>(_onNextPhase);
    on<TimerStopped>(_onStopped);
    on<TimerConfigChanged>(_onConfigChanged);
    on<TimerStopRequestedEvent>(_onTimerStopRequested);
  }

  Stream<TimerEffect> get effectStream => _effectController.stream;

  void _onReceiveTaskData(Object data) {
    debugPrint('📩 Data from notification: $data');
    if (data is! Map) return;

    final action = data['action'];

    switch (action) {
      case 'pause':
        add(TimerPaused());
        break;
      case 'resume':
        add(TimerResumed());
        break;
      case 'stop':
        add(TimerStopRequestedEvent());
        break;
    }
  }

  Future<void> _onStarted(TimerStarted event, Emitter<TimerState> emit) async {
    _currentConfig = event.config;
    _sequence = generateWorkoutSequence(_currentConfig);
    _currentIndex = 0;
    _remainingSeconds = _sequence[0].durationSeconds;

    emit(
      TimerRunning(
        config: _currentConfig,
        sequence: _sequence,
        currentIndex: _currentIndex,
        remainingSeconds: _remainingSeconds,
      ),
    );

    _startTicker();
    _startForegroundTask();
  }

  void _onPaused(TimerPaused event, Emitter<TimerState> emit) {
    _ticker?.cancel();
    if (state is! TimerRunning) return;

    final updated = (state as TimerRunning).copyWith(isPaused: true);
    emit(updated);
    _updateForegroundNotification(updated);
  }

  void _onResumed(TimerResumed event, Emitter<TimerState> emit) {
    if (state is! TimerRunning) return;

    final updated = (state as TimerRunning).copyWith(isPaused: false);
    emit(updated);
    _startTicker();
    _updateForegroundNotification(updated);
  }

  void _onTicked(TimerTicked event, Emitter<TimerState> emit) {
    if (state is! TimerRunning || (state as TimerRunning).isPaused) return;

    final runningState = state as TimerRunning;
    final newRemaining = runningState.remainingSeconds - 1;

    if (newRemaining <= 0) {
      add(TimerNextPhase());
    } else {
      final updated = runningState.copyWith(remainingSeconds: newRemaining);
      emit(updated);
      _updateForegroundNotification(updated);
    }
  }

  void _onNextPhase(TimerNextPhase event, Emitter<TimerState> emit) async {
    if (state is! TimerRunning) return;
    final runningState = state as TimerRunning;

    if (runningState.isLastPhase) {
      _ticker?.cancel();
      await FlutterForegroundTask.stopService();
      emit(TimerFinished());
      return;
    }

    _currentIndex++;
    _remainingSeconds = runningState.sequence[_currentIndex].durationSeconds;
    final nextState = TimerRunning(
      config: runningState.config,
      sequence: runningState.sequence,
      currentIndex: _currentIndex,
      remainingSeconds: _remainingSeconds,
    );
    emit(nextState);

    _updateForegroundNotification(nextState);
  }

  void _onStopped(TimerStopped event, Emitter<TimerState> emit) async {
    _ticker?.cancel();
    emit(TimerInitial(_currentConfig));
    await FlutterForegroundTask.stopService();
  }

  void _onTimerStopRequested(
    TimerStopRequestedEvent event,
    Emitter<TimerState> emit,
  ) {
    _ticker?.cancel();
    if (state is TimerRunning) {
      final pausedState = (state as TimerRunning).copyWith(isPaused: true);
      emit(pausedState);
    }
    _effectController.add(ShowStopDialogEffect());
  }

  void _onConfigChanged(TimerConfigChanged event, Emitter<TimerState> emit) {
    _currentConfig = event.config;
    if (state is TimerInitial) {
      emit(TimerInitial(_currentConfig));
    }
  }

  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      add(TimerTicked());
    });
  }

  Future<void> _startForegroundTask() async {
    try {
      debugPrint('🔄 Starting foreground service...');

      if (await FlutterForegroundTask.isRunningService) {
        await FlutterForegroundTask.restartService();
        debugPrint('✅ Restarted existing service');
        return;
      }

      final result = await FlutterForegroundTask.startService(
        notificationTitle: 'Tabata Timer',
        notificationText: 'Starting...',
        callback: startCallback,
        notificationButtons: [
          const NotificationButton(id: 'pause', text: 'Pause'),
          const NotificationButton(id: 'resume', text: 'Resume'),
          const NotificationButton(id: 'stop', text: 'Stop'),
        ],
      );

      if (result is ServiceRequestFailure) {
        debugPrint('❌ ServiceRequestFailure: ${result.error}');
        return;
      }

      debugPrint('✅ Foreground service started successfully!');
    } catch (e, stack) {
      debugPrint('❌ Exception starting service: $e');
      debugPrint(stack.toString());
    }
  }

  void _updateForegroundNotification(TimerRunning s) async {
    final isRunning = await FlutterForegroundTask.isRunningService;
    if (!isRunning) return;

    if (state is! TimerRunning) return;

    final min = (s.remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final sec = (s.remainingSeconds % 60).toString().padLeft(2, '0');
    final isPaused = s.isPaused;
    await FlutterForegroundTask.updateService(
      notificationTitle:
          '${s.currentPhaseName} • Set ${s.currentSet}/${s.totalSets}',
      notificationText: isPaused ? 'Paused' : '$min:$sec remaining',
      notificationButtons: [
        if (!isPaused) const NotificationButton(id: 'pause', text: 'Pause'),
        if (isPaused) const NotificationButton(id: 'resume', text: 'Resume'),
        const NotificationButton(id: 'stop', text: 'Stop'),
      ],
    );
  }

  @override
  Future<void> close() {
    _ticker?.cancel();
    _effectController.close();

    FlutterForegroundTask.stopService();

    return super.close();
  }
}
