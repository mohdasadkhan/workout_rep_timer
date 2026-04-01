import 'package:app_lifecycle/core/constants/pref_keys.dart';
import 'package:app_lifecycle/features/background_lifecycle/domain/entities/timer_session.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TimerPreferences {
  final SharedPreferences _sharedPreferences;
  TimerPreferences(this._sharedPreferences);

  Future<void> saveSession(TimerSession session) async {
    await _sharedPreferences.setInt(
      PrefKeys.elapsedSeconds,
      session.elapsedSeconds,
    );
    await _sharedPreferences.setBool(PrefKeys.isRunning, session.isRunning);

    await _sharedPreferences.setInt(
      PrefKeys.setsCompleted,
      session.setsCompleted,
    );
  }

  TimerSession loadSession() => TimerSession(
    elapsedSeconds: _sharedPreferences.getInt(PrefKeys.elapsedSeconds) ?? 0,
    isRunning: _sharedPreferences.getBool(PrefKeys.isRunning) ?? false,
    setsCompleted: _sharedPreferences.getInt(PrefKeys.setsCompleted) ?? 0,
  );

  Future<void> clearSession() async {
    await _sharedPreferences.remove(PrefKeys.elapsedSeconds);
    await _sharedPreferences.remove(PrefKeys.isRunning);
    await _sharedPreferences.remove(PrefKeys.setsCompleted);
  }
}
