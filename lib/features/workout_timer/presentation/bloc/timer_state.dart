// =====================================================
// lib/features/workout_timer/presentation/bloc/timer_state.dart
// =====================================================
part of 'timer_bloc.dart';

abstract class TimerState {}

class TimerInitial extends TimerState {
  final WorkoutConfig config;
  TimerInitial(this.config);
}

class TimerRunning extends TimerState {
  final WorkoutConfig config;
  final List<WorkoutPhase> sequence;
  final int currentIndex;
  final int remainingSeconds;
  final bool isPaused;
  final DateTime lastTick;

  TimerRunning({
    required this.config,
    required this.sequence,
    required this.currentIndex,
    required this.remainingSeconds,
    this.isPaused = false,
    DateTime? lastTick,
  }) : lastTick = lastTick ?? DateTime.now();

  String get currentPhaseName => sequence[currentIndex].name;
  PhaseType get currentPhaseType => sequence[currentIndex].type;
  int get currentSet => sequence[currentIndex].currentSet;
  int get totalSets => sequence[currentIndex].totalSets;

  bool get isLastPhase => currentIndex == sequence.length - 1;

  TimerRunning copyWith({
    int? remainingSeconds,
    bool? isPaused,
    int? currentIndex,
  }) {
    return TimerRunning(
      config: config,
      sequence: sequence,
      currentIndex: currentIndex ?? this.currentIndex,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      isPaused: isPaused ?? this.isPaused,
      lastTick: DateTime.now(),
    );
  }
}

class TimerFinished extends TimerState {}