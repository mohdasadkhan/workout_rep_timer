import 'package:fitflow/core/constants/pref_keys.dart';
import 'package:fitflow/features/settings/domain/entities/sound_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Persists [SoundSettings] to SharedPreferences.
/// Mirrors [ThemeLocalDatasourceImpl] exactly — same constructor pattern,
/// same abstract + impl split.
abstract class SoundLocalDatasource {
  Future<SoundSettings> getSoundSettings();
  Future<void> saveSoundSettings(SoundSettings settings);
}

class SoundLocalDatasourceImpl implements SoundLocalDatasource {
  final SharedPreferences _prefs;

  const SoundLocalDatasourceImpl({required SharedPreferences prefs})
      : _prefs = prefs;

  @override
  Future<SoundSettings> getSoundSettings() async {
    final soundEnabled =
        _prefs.getBool(PrefKeys.soundEnabled) ?? true;
    final hapticEnabled =
        _prefs.getBool(PrefKeys.hapticEnabled) ?? true;
    return SoundSettings(
      soundEnabled: soundEnabled,
      hapticEnabled: hapticEnabled,
    );
  }

  @override
  Future<void> saveSoundSettings(SoundSettings settings) async {
    await _prefs.setBool(PrefKeys.soundEnabled, settings.soundEnabled);
    await _prefs.setBool(PrefKeys.hapticEnabled, settings.hapticEnabled);
  }
}