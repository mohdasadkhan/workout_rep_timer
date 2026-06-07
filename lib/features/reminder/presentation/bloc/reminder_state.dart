import '../../domain/entities/reminder_schedule.dart';

sealed class ReminderState {}

class ReminderInitial extends ReminderState {}

class ReminderLoading extends ReminderState {}

class ReminderLoaded extends ReminderState {
  final List<ReminderSchedule> schedules;
  final bool isEnabled;
  final bool isSaving;

  ReminderLoaded({
    required this.schedules,
    required this.isEnabled,
    this.isSaving = false,
  });

  ReminderLoaded copyWith({
    List<ReminderSchedule>? schedules,
    bool? isEnabled,
    bool? isSaving,
  }) {
    return ReminderLoaded(
      schedules: schedules ?? this.schedules,
      isEnabled: isEnabled ?? this.isEnabled,
      isSaving: isSaving ?? this.isSaving,
    );
  }
}

class ReminderSaveSuccess extends ReminderState {
  final bool isEnabled;
  ReminderSaveSuccess(this.isEnabled);
}

class ReminderError extends ReminderState {
  final String message;
  ReminderError(this.message);
}
