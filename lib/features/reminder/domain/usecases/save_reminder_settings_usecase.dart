import '../entities/reminder_schedule.dart';
import '../repositories/reminder_notification_service.dart';
import '../repositories/reminder_repository.dart';
import '../../core/reminder_title_generator.dart';

class SaveReminderSettingsUseCase {
  final ReminderRepository repository;
  final ReminderNotificationService notificationService;

  static const int _baseNotificationId = 100;

  const SaveReminderSettingsUseCase({
    required this.repository,
    required this.notificationService,
  });

  Future<void> call({
    required List<ReminderSchedule> schedules,
    required bool isEnabled,
  }) async {
    await repository.saveSchedules(schedules);
    await repository.saveRemindersEnabled(isEnabled);

    await notificationService.cancelAllReminders();

    if (!isEnabled) return;

    for (final schedule in schedules) {
      if (!schedule.isEnabled) continue;

      final id = _baseNotificationId + schedule.dayOfWeek;
      final title = ReminderTitleGenerator.random();

      await notificationService.scheduleWeeklyReminder(
        id: id,
        title: title,
        body: "You planned this. Now show up. 💪",
        dayOfWeek: schedule.dayOfWeek,
        time: schedule.time,
      );
    }
  }
}
