import 'package:equatable/equatable.dart';
import 'package:fitflow/features/settings/domain/entities/sound_settings.dart';
import 'package:fitflow/features/settings/domain/usecases/get_sound_settings.dart';
import 'package:fitflow/features/settings/domain/usecases/save_sound_settings.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'sound_settings_event.dart';
part 'sound_settings_state.dart';

/// Manages Timer Sounds + Haptic Feedback toggles in the settings screen.
///
/// Uses optimistic UI: the switch flips immediately, then we persist in the
/// background. If persistence fails we revert to the previous state and emit
/// [SoundSettingsError] so the UI can show a snackbar.
class SoundSettingsBloc extends Bloc<SoundSettingsEvent, SoundSettingsState> {
  final GetSoundSettings _getSettings;
  final SaveSoundSettings _saveSettings;

  SoundSettingsBloc({
    required GetSoundSettings getSettings,
    required SaveSoundSettings saveSettings,
  })  : _getSettings = getSettings,
        _saveSettings = saveSettings,
        super(const SoundSettingsInitial()) {
    on<LoadSoundSettings>(_onLoad);
    on<ToggleSoundEnabled>(_onToggleSound);
    on<ToggleHapticEnabled>(_onToggleHaptic);
  }

  Future<void> _onLoad(
    LoadSoundSettings event,
    Emitter<SoundSettingsState> emit,
  ) async {
    final result = await _getSettings();
    result.fold(
      (failure) => emit(SoundSettingsError(failure.message)),
      (settings) => emit(SoundSettingsLoaded(settings)),
    );
  }

  Future<void> _onToggleSound(
    ToggleSoundEnabled event,
    Emitter<SoundSettingsState> emit,
  ) async {
    if (state is! SoundSettingsLoaded) return;

    final previous = (state as SoundSettingsLoaded).settings;
    final optimistic = previous.copyWith(soundEnabled: event.enabled);

    // Flip immediately so the switch feels instant.
    emit(SoundSettingsLoaded(optimistic));

    final result = await _saveSettings(optimistic);
    result.fold(
      (failure) {
        // Persist failed — revert and surface the error.
        emit(SoundSettingsLoaded(previous));
        emit(SoundSettingsError(failure.message));
      },
      (_) {
        // Nothing to do — optimistic state is already correct.
      },
    );
  }

  Future<void> _onToggleHaptic(
    ToggleHapticEnabled event,
    Emitter<SoundSettingsState> emit,
  ) async {
    if (state is! SoundSettingsLoaded) return;

    final previous = (state as SoundSettingsLoaded).settings;
    final optimistic = previous.copyWith(hapticEnabled: event.enabled);

    emit(SoundSettingsLoaded(optimistic));

    final result = await _saveSettings(optimistic);
    result.fold(
      (failure) {
        emit(SoundSettingsLoaded(previous));
        emit(SoundSettingsError(failure.message));
      },
      (_) {},
    );
  }
}
