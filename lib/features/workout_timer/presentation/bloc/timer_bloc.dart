// =====================================================
// lib/features/workout_timer/presentation/bloc/timer_bloc.dart
// =====================================================
import 'dart:async';
import 'dart:developer';
import 'package:app_lifecycle/core/utils/foreground_task_handler.dart';
import 'package:app_lifecycle/features/workout_timer/domain/entity/workout_config.dart';
import 'package:app_lifecycle/features/workout_timer/domain/entity/workout_phase.dart';
import 'package:app_lifecycle/features/workout_timer/domain/usecases/generate_workout_usecase.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';

part 'timer_event.dart';
part 'timer_state.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  Timer? _ticker;
  WorkoutConfig _currentConfig = const WorkoutConfig();
  List<WorkoutPhase> _sequence = [];
  int _currentIndex = 0;
  int _remainingSeconds = 0;

  TimerBloc() : super(TimerInitial(const WorkoutConfig())) {
    on<TimerStarted>(_onStarted);
    on<TimerPaused>(_onPaused);
    on<TimerResumed>(_onResumed);
    on<TimerTicked>(_onTicked);
    on<TimerNextPhase>(_onNextPhase);
    on<TimerStopped>(_onStopped);
    on<TimerConfigChanged>(_onConfigChanged);
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
    if (state is TimerRunning) {
      emit((state as TimerRunning).copyWith(isPaused: true));
    }
    FlutterForegroundTask.updateService(notificationText: 'Timer paused');
  }

  void _onResumed(TimerResumed event, Emitter<TimerState> emit) {
    if (state is TimerRunning) {
      final runningState = state as TimerRunning;
      emit(runningState.copyWith(isPaused: false));
      _startTicker();
      _startForegroundTask();
    }
  }

  void _onTicked(TimerTicked event, Emitter<TimerState> emit) {
    if (state is! TimerRunning || (state as TimerRunning).isPaused) return;

    final runningState = state as TimerRunning;
    final newRemaining = runningState.remainingSeconds - 1;

    if (newRemaining <= 0) {
      add(TimerNextPhase());
    } else {
      emit(runningState.copyWith(remainingSeconds: newRemaining));
      _updateForegroundNotification();
    }
  }

  void _onNextPhase(TimerNextPhase event, Emitter<TimerState> emit) async {
    if (state is! TimerRunning) return;
    final runningState = state as TimerRunning;

    if (runningState.isLastPhase) {
      _ticker?.cancel();
      FlutterForegroundTask.stopService();
      await FlutterForegroundTask.stopService();
      emit(TimerFinished());
      return;
    }

    _currentIndex++;
    _remainingSeconds = runningState.sequence[_currentIndex].durationSeconds;

    emit(
      TimerRunning(
        config: runningState.config,
        sequence: runningState.sequence,
        currentIndex: _currentIndex,
        remainingSeconds: _remainingSeconds,
      ),
    );

    _updateForegroundNotification();
  }

  void _onStopped(TimerStopped event, Emitter<TimerState> emit) async {
    log('inside onStopped >>>>>>>>>><<<<<<<<<<<<<,');
    _ticker?.cancel();

    FlutterForegroundTask.stopService();
    await FlutterForegroundTask.stopService();
    emit(TimerInitial(_currentConfig));
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
  // Future<void> _startForegroundTask() async {
  //   try {
  //     debugPrint('🔄 Starting foreground service...');

  //     if (await FlutterForegroundTask.isRunningService) {
  //       await FlutterForegroundTask.restartService();
  //       debugPrint('✅ Restarted existing service');
  //       _updateForegroundNotification();
  //       return;
  //     }

  //     // Start service with VERY minimal initial text
  //     final result = await FlutterForegroundTask.startService(
  //       notificationTitle: 'Tabata Timer',
  //       notificationText: 'Starting...', // Keep super short
  //       callback: startCallback,
  //     );

  //     if (result is ServiceRequestFailure) {
  //       debugPrint(
  //         '❌ ServiceRequestFailure: ${result.error}',
  //       );
  //     } else {
  //       debugPrint('✅ Foreground service started successfully!');
  //       // Small delay to let the isolate settle
  //       await Future.delayed(const Duration(milliseconds: 400));
  //       _updateForegroundNotification();
  //     }
  //   } catch (e, stack) {
  //     debugPrint('❌ Exception starting service: $e');
  //     debugPrint(stack.toString());
  //   }
  // }
  // Future<void> _startForegroundTask() async {
  //   try {
  //     debugPrint('🔄 Starting foreground service...');

  //     if (await FlutterForegroundTask.isRunningService) {
  //       await FlutterForegroundTask.restartService();
  //       debugPrint('✅ Restarted existing service');
  //       _updateForegroundNotification();
  //       return;
  //     }

  //     // Start service with VERY minimal initial text
  //     final result = await FlutterForegroundTask.startService(
  //       notificationTitle: 'Tabata Timer',
  //       notificationText: 'Starting...', // Keep super short
  //       callback: startCallback,
  //     );

  //     if (result is ServiceRequestFailure) {
  //       debugPrint('❌ ServiceRequestFailure: ${result.error}');
  //     } else {
  //       debugPrint('✅ Foreground service started successfully!');
  //       // Small delay to let the isolate settle
  //       await Future.delayed(const Duration(milliseconds: 400));
  //       _updateForegroundNotification();
  //     }
  //   } catch (e, stack) {
  //     debugPrint('❌ Exception starting service: $e');
  //     debugPrint(stack.toString());
  //   }
  // }

  // void _updateForegroundNotification() {
  //   if (state is TimerRunning) {
  //     final s = state as TimerRunning;
  //     FlutterForegroundTask.updateService(
  //       notificationTitle:
  //           '${s.currentPhaseName} • Set ${s.currentSet}/${s.totalSets}',
  //       notificationText: _buildNotificationText(),
  //     );
  //   }
  // }
  // void _updateForegroundNotification() {
  //   if (state is! TimerRunning) return;
  //   final s = state as TimerRunning;
  //   final min = (s.remainingSeconds ~/ 60).toString().padLeft(2, '0');
  //   final sec = (s.remainingSeconds % 60).toString().padLeft(2, '0');

  //   FlutterForegroundTask.updateService(
  //     notificationTitle:
  //         '${s.currentPhaseName} • Set ${s.currentSet}/${s.totalSets}',
  //     notificationText: '$min:$sec remaining',
  //   );
  // }
  void _updateForegroundNotification() async {
    final isRunning = await FlutterForegroundTask.isRunningService;
    if (!isRunning) return;

    if (state is! TimerRunning) return;

    final s = state as TimerRunning;

    final min = (s.remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final sec = (s.remainingSeconds % 60).toString().padLeft(2, '0');

    await FlutterForegroundTask.updateService(
      notificationTitle:
          '${s.currentPhaseName} • Set ${s.currentSet}/${s.totalSets}',
      notificationText: '$min:$sec remaining',
    );
  }

  String _buildNotificationText() {
    if (state is! TimerRunning) return 'Timer finished';
    final s = state as TimerRunning;
    final min = (s.remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final sec = (s.remainingSeconds % 60).toString().padLeft(2, '0');
    return '$min:$sec remaining';
  }

  @override
  Future<void> close() {
    _ticker?.cancel();
    FlutterForegroundTask.stopService();
    return super.close();
  }
}
