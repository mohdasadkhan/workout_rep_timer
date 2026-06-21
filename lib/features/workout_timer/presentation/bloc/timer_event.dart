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

/// Fired by [SoundSettingsBloc] listener in main.dart whenever sound prefs
/// change at runtime. This avoids any SharedPreferences reads inside the
/// timer loop — we just update the service's in-memory flags.
class TimerSoundSettingsChanged extends TimerEvent {
  final bool soundEnabled;
  final bool hapticEnabled;

  TimerSoundSettingsChanged({
    required this.soundEnabled,
    required this.hapticEnabled,
  });
}