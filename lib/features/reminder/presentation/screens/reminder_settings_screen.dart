import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fitflow/core/theme/app_colors.dart';
import 'package:fitflow/core/theme/app_text_styles.dart';
import '../bloc/reminder_bloc.dart';
import '../bloc/reminder_event.dart';
import '../bloc/reminder_state.dart';
import '../widgets/day_schedule_card.dart';

class ReminderSettingsScreen extends StatelessWidget {
  const ReminderSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ReminderBloc, ReminderState>(
      listener: (context, state) {
        if (state is ReminderSaveSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.isEnabled
                    ? '✅ Reminders scheduled!'
                    : '🔕 Reminders turned off',
                style: TextStyle(color: Colors.white),
              ),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        }
        if (state is ReminderError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${state.message}'),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          // backgroundColor: AppColors.background,
          appBar: AppBar(
            // backgroundColor: AppColors.background,
            elevation: 0,
            centerTitle: true,
            title: Text('Workout Reminders', style: AppTextStyles.titleLarge),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(0.5),
              child: Container(
                height: 0.5,
                color: Colors.white.withOpacity(0.07),
              ),
            ),
          ),
          body: switch (state) {
            ReminderInitial() || ReminderLoading() => const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
            ReminderLoaded(:final schedules, :final isEnabled) => _ReminderBody(
              schedules: schedules,
              isEnabled: isEnabled,
            ),
            ReminderSaveSuccess() => const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
            ReminderError(:final message) => _ErrorView(message: message),
            _ => const SizedBox.shrink(),
          },
        );
      },
    );
  }
}

class _ReminderBody extends StatelessWidget {
  final List schedules;
  final bool isEnabled;

  const _ReminderBody({required this.schedules, required this.isEnabled});

  int get _activeCount => schedules.where((s) => s.isEnabled == true).length;

  String get _nextReminder {
    final next = schedules.where((s) => s.isEnabled == true).toList();
    if (next.isEmpty) return 'None scheduled';
    return 'Tomorrow, ${next.first.time}';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 0),
            children: [
              _SummaryCard(
                isEnabled: isEnabled,
                activeCount: _activeCount,
                total: schedules.length,
                nextReminder: isEnabled ? _nextReminder : 'Reminders off',
                onToggle: (v) =>
                    context.read<ReminderBloc>().add(ReminderToggleEnabled(v)),
              ),

              const SizedBox(height: 10),

              _WeekStrip(schedules: schedules, masterEnabled: isEnabled),

              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('SCHEDULE', style: AppTextStyles.labelSmall),
                  Text(
                    'Tap to toggle · clock to edit',
                    style: AppTextStyles.labelSmall.copyWith(
                      fontSize: 10,
                      color: AppColors.textTertiary.withOpacity(0.5),
                      letterSpacing: 0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              ...schedules.map(
                (schedule) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: DayScheduleCard(
                    schedule: schedule,
                    masterEnabled: isEnabled,
                  ),
                ),
              ),

              const SizedBox(height: 8),
            ],
          ),
        ),

        _SaveButton(schedules: schedules),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final bool isEnabled;
  final int activeCount;
  final int total;
  final String nextReminder;
  final ValueChanged<bool> onToggle;

  const _SummaryCard({
    required this.isEnabled,
    required this.activeCount,
    required this.total,
    required this.nextReminder,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 16, 14, 16),
      decoration: BoxDecoration(
        // color: AppColors.surface,
        // borderRadius: BorderRadius.circular(16),

        // border: isEnabled
        //     ? Border.all(color: AppColors.primary.withOpacity(0.18))
        //     : Border.all(color: Colors.white.withOpacity(0.05)),
        color: theme.cardTheme.color ?? colorScheme.surface,
        border: Border.all(color: colorScheme.onSurface.withOpacity(0.08)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ACTIVE REMINDERS',
                  style: AppTextStyles.labelSmall.copyWith(fontSize: 10),
                ),
                const SizedBox(height: 5),
                Text(
                  isEnabled ? '$activeCount of $total days' : 'Disabled',
                  style: AppTextStyles.headlineMedium.copyWith(fontSize: 22),
                ),
                const SizedBox(height: 4),
                Text(
                  nextReminder,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontSize: 12,
                    color: isEnabled
                        ? AppColors.primary
                        : AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Reminders',
                style: AppTextStyles.bodyMedium.copyWith(fontSize: 11),
              ),
              const SizedBox(height: 6),
              Switch(
                value: isEnabled,
                onChanged: onToggle,
                activeThumbColor: AppColors.primary,
                inactiveThumbColor: AppColors.textTertiary,
                inactiveTrackColor: Colors.white.withOpacity(0.08),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _WeekStrip extends StatelessWidget {
  final List schedules;
  final bool masterEnabled;

  const _WeekStrip({required this.schedules, required this.masterEnabled});

  static const _letters = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    final weekStart = now.subtract(Duration(days: now.weekday % 7));
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: List.generate(schedules.length, (i) {
        final schedule = schedules[i];
        final isOn = masterEnabled && (schedule.isEnabled as bool? ?? false);
        final date = weekStart.add(Duration(days: i));
        final isToday =
            date.day == now.day &&
            date.month == now.month &&
            date.year == now.year;

        return Expanded(
          child: GestureDetector(
            onTap: masterEnabled
                ? () => context.read<ReminderBloc>().add(
                    ReminderToggleDay(schedule.dayOfWeek),
                  )
                : null,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOut,
              margin: EdgeInsets.only(right: i < schedules.length - 1 ? 5 : 0),
              padding: const EdgeInsets.symmetric(vertical: 9),
              decoration: BoxDecoration(
                color: isOn ? AppColors.primary : colorScheme.onPrimary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _letters[i],
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.3,
                      color: isOn
                          ? colorScheme.onSurface.withOpacity(0.65)
                          : AppColors.textTertiary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${date.day}',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: isToday ? FontWeight.w800 : FontWeight.w600,
                      color: isOn
                          ? Colors.white
                          : isToday
                          ? AppColors.primary
                          : colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _SaveButton extends StatelessWidget {
  final List schedules;

  const _SaveButton({required this.schedules});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ReminderBloc>().state;
    final isSaving = state is ReminderLoaded && state.isSaving;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 28),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: colorScheme.onSurfaceVariant.withOpacity(0.06),
          ),
        ),
      ),
      child: FilledButton.icon(
        onPressed: isSaving
            ? null
            : () => context.read<ReminderBloc>().add(ReminderSaveSettings()),
        icon: isSaving
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Icon(Icons.check_rounded, size: 20),
        label: Text(
          isSaving ? 'Saving...' : 'Save Changes',
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 54),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  const _ErrorView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, size: 48, color: AppColors.error),
          const SizedBox(height: 12),
          Text(message, style: AppTextStyles.bodyMedium),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () =>
                context.read<ReminderBloc>().add(ReminderLoadSettings()),
            child: Text(
              'Retry',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
