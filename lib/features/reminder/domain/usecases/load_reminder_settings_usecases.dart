import '../entities/reminder_schedule.dart';
import '../repositories/reminder_repository.dart';

class LoadReminderSettingsUseCase {
  final ReminderRepository repository;

  const LoadReminderSettingsUseCase(this.repository);

  Future<({List<ReminderSchedule> schedules, bool isEnabled})> call() async {
    final schedules = await repository.loadSchedules();
    final isEnabled = await repository.loadRemindersEnabled();
    return (schedules: schedules, isEnabled: isEnabled);
  }
}

