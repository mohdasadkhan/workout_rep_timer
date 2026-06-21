part of 'sound_settings_bloc.dart';

abstract class SoundSettingsEvent {}

/// Fired once on app start / settings screen open to hydrate state from prefs.
class LoadSoundSettings extends SoundSettingsEvent {}

/// User toggled the "Timer Sounds" switch.
class ToggleSoundEnabled extends SoundSettingsEvent {
  final bool enabled;
  ToggleSoundEnabled(this.enabled);
}

/// User toggled the "Haptic Feedback" switch.
class ToggleHapticEnabled extends SoundSettingsEvent {
  final bool enabled;
  ToggleHapticEnabled(this.enabled);
}