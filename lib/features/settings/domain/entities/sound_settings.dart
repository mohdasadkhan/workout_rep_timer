import 'package:equatable/equatable.dart';

/// Holds the user's audio/haptic preferences for the workout timer.
/// Immutable value object — follows the same pattern as [AppThemeMode].
class SoundSettings extends Equatable {
  final bool soundEnabled;
  final bool hapticEnabled;

  const SoundSettings({
    this.soundEnabled = true,
    this.hapticEnabled = true,
  });

  SoundSettings copyWith({
    bool? soundEnabled,
    bool? hapticEnabled,
  }) {
    return SoundSettings(
      soundEnabled: soundEnabled ?? this.soundEnabled,
      hapticEnabled: hapticEnabled ?? this.hapticEnabled,
    );
  }

  @override
  List<Object?> get props => [soundEnabled, hapticEnabled];

  @override
  String toString() =>
      'SoundSettings(soundEnabled: $soundEnabled, hapticEnabled: $hapticEnabled)';
}