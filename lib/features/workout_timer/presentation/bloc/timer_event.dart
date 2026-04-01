// =====================================================
// lib/features/workout_timer/presentation/bloc/timer_event.dart
// =====================================================
part of 'timer_bloc.dart';

abstract class TimerEvent {}

class TimerStarted extends TimerEvent {
  final WorkoutConfig config;
  TimerStarted(this.config);
}

class TimerPaused extends TimerEvent {}

class TimerResumed extends TimerEvent {}

class TimerTicked extends TimerEvent {} // internal

class TimerNextPhase extends TimerEvent {}


class TimerStopped extends TimerEvent {}
class TimerConfigChanged extends TimerEvent {
  final WorkoutConfig config;
  TimerConfigChanged(this.config);
}