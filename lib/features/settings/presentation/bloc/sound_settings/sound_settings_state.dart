part of 'sound_settings_bloc.dart';

abstract class SoundSettingsState extends Equatable {
  const SoundSettingsState();

  @override
  List<Object?> get props => [];
}

class SoundSettingsInitial extends SoundSettingsState {
  const SoundSettingsInitial();
}

class SoundSettingsLoaded extends SoundSettingsState {
  final SoundSettings settings;

  const SoundSettingsLoaded(this.settings);

  @override
  List<Object?> get props => [settings];
}

class SoundSettingsError extends SoundSettingsState {
  final String message;

  const SoundSettingsError(this.message);

  @override
  List<Object?> get props => [message];
}