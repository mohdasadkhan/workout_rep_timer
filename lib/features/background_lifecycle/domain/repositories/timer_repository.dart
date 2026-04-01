import 'package:app_lifecycle/features/background_lifecycle/domain/entities/timer_session.dart';

abstract interface class TimerRepository {
  Future<void> saveSession(TimerSession timerSession);
  Future<TimerSession> loadSession();
  Future<void> clearSession();
}
