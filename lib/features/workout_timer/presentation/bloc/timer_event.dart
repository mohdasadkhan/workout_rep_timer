part of 'timer_bloc.dart';

abstract class TimerEvent {}

class TimerStarted extends TimerEvent {
  final WorkoutConfig config;
  TimerStarted(this.config);
}

class TimerPaused extends TimerEvent {}

class TimerResumed extends TimerEvent {}

class TimerTicked extends TimerEvent {}

class TimerNextPhase extends TimerEvent {}

class TimerStopped extends TimerEvent {}

class TimerStopRequestedEvent extends TimerEvent {}


class TimerConfigChanged extends TimerEvent {
  final WorkoutConfig config;
  TimerConfigChanged(this.config);
}
