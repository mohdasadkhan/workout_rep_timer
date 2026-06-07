import '../entities/reminder_schedule.dart';

abstract class ReminderRepository {
  Future<List<ReminderSchedule>> loadSchedules();
  Future<void> saveSchedules(List<ReminderSchedule> schedules);
  Future<bool> loadRemindersEnabled();
  Future<void> saveRemindersEnabled(bool enabled);
}
