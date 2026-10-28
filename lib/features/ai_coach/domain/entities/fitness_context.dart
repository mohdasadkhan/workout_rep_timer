import 'package:equatable/equatable.dart';
import 'package:fitflow/features/rep_tracker/domain/entities/personal_record.dart';
import 'package:fitflow/features/ai_coach/domain/entities/user_fitness_profile.dart';

/// Local snapshot of the user's fitness state — fed to coach UI and future LLM prompts.
class FitnessContext extends Equatable {
  final DateTime? lastWorkoutDate;
  final int? daysSinceLastWorkout;
  final int sessionsLast7Days;
  final int sessionsLast30Days;
  final int totalSessions;
  final List<PersonalRecord> topPersonalRecords;
  final List<String> frequentExercises;
  final bool hasActiveSession;
  final int activeSessionExerciseCount;
  final UserFitnessProfile profile;

  const FitnessContext({
    required this.lastWorkoutDate,
    required this.daysSinceLastWorkout,
    required this.sessionsLast7Days,
    required this.sessionsLast30Days,
    required this.totalSessions,
    required this.topPersonalRecords,
    required this.frequentExercises,
    required this.hasActiveSession,
    required this.activeSessionExerciseCount,
    required this.profile,
  });

  String get briefingHeadline {
    if (hasActiveSession) {
      return 'Workout in progress';
    }
    if (lastWorkoutDate == null) {
      return 'Ready to start your fitness journey?';
    }

    final days = daysSinceLastWorkout ?? 0;
    if (days == 0) {
      return 'Great work today — keep the momentum';
    }
    if (days == 1) {
      return 'Rest day yesterday — ready to move?';
    }
    if (days <= 3) {
      return '$days days since your last session';
    }
    return 'It\'s been $days days — let\'s get back on track';
  }

  List<String> get briefingBullets {
    final bullets = <String>[];

    if (hasActiveSession) {
      bullets.add(
        '$activeSessionExerciseCount exercise${activeSessionExerciseCount == 1 ? '' : 's'} logged so far',
      );
    }

    if (totalSessions == 0) {
      bullets.add('Log your first workout to unlock personalized insights');
      return bullets;
    }

    if (lastWorkoutDate != null && !hasActiveSession) {
      final days = daysSinceLastWorkout ?? 0;
      if (days == 0) {
        bullets.add('You trained today');
      } else if (days == 1) {
        bullets.add('Last workout was yesterday');
      } else {
        bullets.add('Last workout was $days days ago');
      }
    }

    bullets.add(
      '$sessionsLast7Days session${sessionsLast7Days == 1 ? '' : 's'} this week · '
      '$sessionsLast30Days in the last 30 days',
    );

    if (topPersonalRecords.isNotEmpty) {
      final top = topPersonalRecords.first;
      bullets.add(
        'Top PR: ${top.exerciseName} — ${top.bestWeightKg}kg × ${top.repsAtBestWeight}',
      );
    }

    if (frequentExercises.isNotEmpty) {
      final names = frequentExercises.take(3).join(', ');
      bullets.add('Recent focus: $names');
    }

    return bullets;
  }

  @override
  List<Object?> get props => [
    lastWorkoutDate,
    daysSinceLastWorkout,
    sessionsLast7Days,
    sessionsLast30Days,
    totalSessions,
    topPersonalRecords,
    frequentExercises,
    hasActiveSession,
    activeSessionExerciseCount,
    profile,
  ];
}
