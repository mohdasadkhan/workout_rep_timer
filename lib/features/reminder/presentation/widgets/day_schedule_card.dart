import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/reminder_schedule.dart';
import '../bloc/reminder_bloc.dart';
import '../bloc/reminder_event.dart';

class DayScheduleCard extends StatelessWidget {
  final ReminderSchedule schedule;
  final bool masterEnabled;

  static const List<String> _dayLabels = [
    'SUNDAY',
    'MONDAY',
    'TUESDAY',
    'WEDNESDAY',
    'THURSDAY',
    'FRIDAY',
    'SATURDAY',
  ];

  const DayScheduleCard({
    super.key,
    required this.schedule,
    required this.masterEnabled,
  });

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';

    return '$hour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final isActive = schedule.isEnabled && masterEnabled;

    final primary = theme.colorScheme.primary;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 220),
      opacity: masterEnabled ? 1 : .45,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          color: isActive
              ? primary.withOpacity(.08)
              : theme.colorScheme.surface,
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: masterEnabled
              ? () {
                  context.read<ReminderBloc>().add(
                    ReminderToggleDay(schedule.dayOfWeek),
                  );
                }
              : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      _dayLabels[schedule.dayOfWeek],
                      style: theme.textTheme.labelSmall?.copyWith(
                        letterSpacing: 1.4,
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.onSurface.withOpacity(.42),
                      ),
                    ),
                    const Spacer(),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isActive
                            ? primary
                            : theme.colorScheme.outline.withOpacity(.20),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                Text(
                  _formatTime(schedule.time),
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: -1.3,
                    height: 1,
                    color: isActive
                        ? theme.colorScheme.onSurface
                        : theme.colorScheme.onSurface.withOpacity(.55),
                  ),
                ),

                const SizedBox(height: 8),

                Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isActive
                            ? primary
                            : theme.colorScheme.outline.withOpacity(.35),
                      ),
                    ),

                    const SizedBox(width: 6),

                    Text(
                      isActive ? 'Active' : 'Disabled',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isActive
                            ? primary
                            : theme.colorScheme.onSurface.withOpacity(.40),
                      ),
                    ),

                    const Spacer(),

                    if (masterEnabled)
                      InkWell(
                        borderRadius: BorderRadius.circular(50),
                        onTap: () => _pickTime(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: theme.colorScheme.surfaceContainerHighest
                                .withOpacity(.55),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.edit_outlined,
                                size: 12,
                                color: theme.colorScheme.onSurface.withOpacity(
                                  .60,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Change',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: schedule.time,
      helpText: 'Set reminder time for ${_dayLabels[schedule.dayOfWeek]}',
    );

    if (picked != null && context.mounted) {
      context.read<ReminderBloc>().add(
        ReminderUpdateTime(dayOfWeek: schedule.dayOfWeek, time: picked),
      );
    }
  }
}
