import 'package:flutter/material.dart';

import '../../domain/entities/reminder_schedule.dart';

sealed class ReminderEvent {}

class ReminderLoadSettings extends ReminderEvent {}

class ReminderToggleEnabled extends ReminderEvent {
  final bool isEnabled;
  ReminderToggleEnabled(this.isEnabled);
}

class ReminderToggleDay extends ReminderEvent {
  final int dayOfWeek;
  ReminderToggleDay(this.dayOfWeek);
}

class ReminderUpdateTime extends ReminderEvent {
  final int dayOfWeek;
  final TimeOfDay time;
  ReminderUpdateTime({required this.dayOfWeek, required this.time});
}

class ReminderSaveSettings extends ReminderEvent {}
