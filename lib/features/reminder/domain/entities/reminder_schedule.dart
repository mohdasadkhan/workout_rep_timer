import 'package:flutter/material.dart';

class ReminderSchedule {
  final int dayOfWeek;
  final TimeOfDay time;
  final bool isEnabled;

  const ReminderSchedule({
    required this.dayOfWeek,
    required this.time,
    this.isEnabled = false,
  });

  ReminderSchedule copyWith({
    int? dayOfWeek,
    TimeOfDay? time,
    bool? isEnabled,
  }) {
    return ReminderSchedule(
      dayOfWeek: dayOfWeek ?? this.dayOfWeek,
      time: time ?? this.time,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is ReminderSchedule &&
      other.dayOfWeek == dayOfWeek &&
      other.time == time &&
      other.isEnabled == isEnabled;

  @override
  int get hashCode => Object.hash(dayOfWeek, time, isEnabled);
}
