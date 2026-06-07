import '../../domain/entities/reminder_schedule.dart';
import '../../domain/repositories/reminder_repository.dart';
import '../datasources/reminder_local_datasource.dart';

class ReminderRepositoryImpl implements ReminderRepository {
  final ReminderLocalDatasource datasource;

  const ReminderRepositoryImpl(this.datasource);

  @override
  Future<List<ReminderSchedule>> loadSchedules() =>
      datasource.loadSchedules();

  @override
  Future<void> saveSchedules(List<ReminderSchedule> schedules) =>
      datasource.saveSchedules(schedules);

  @override
  Future<bool> loadRemindersEnabled() => datasource.loadEnabled();

  @override
  Future<void> saveRemindersEnabled(bool enabled) =>
      datasource.saveEnabled(enabled);
}

