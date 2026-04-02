import 'package:app_lifecycle/features/background_lifecycle/data/local/timer_preferences.dart';
import 'package:app_lifecycle/features/background_lifecycle/domain/entities/timer_session.dart';
import 'package:app_lifecycle/features/background_lifecycle/domain/repositories/timer_repository.dart';

class TimerRepositoryImpl implements TimerRepository {
  final TimerPreferences _timerPreferences;

  TimerRepositoryImpl({required TimerPreferences timerPreferences})
    : _timerPreferences = timerPreferences;

  @override
  Future<void> saveSession(TimerSession session) async {
    await _timerPreferences.saveSession(session);
  }

  @override
  Future<TimerSession> loadSession() async {
    return _timerPreferences.loadSession();
  }

  @override
  Future<void> clearSession() async {
    await _timerPreferences.clearSession();
  }
}
