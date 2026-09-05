import 'package:dartz/dartz.dart';
import 'package:fitflow/core/failure/failure.dart';
import 'package:fitflow/core/usecases/usecase.dart';
import 'package:fitflow/features/ai_coach/domain/entities/fitness_context.dart';
import 'package:fitflow/features/ai_coach/domain/entities/user_fitness_profile.dart';
import 'package:fitflow/features/ai_coach/domain/repositories/fitness_context_repository.dart';
import 'package:fitflow/features/rep_tracker/domain/entities/personal_record.dart';
import 'package:fitflow/features/rep_tracker/domain/entities/workout_session.dart';
import 'package:fitflow/features/rep_tracker/domain/repositories/workout_repository.dart';
import 'package:fitflow/features/rep_tracker/domain/usecases/get_personal_records.dart';
import 'package:fitflow/features/rep_tracker/domain/usecases/get_workout_history.dart';

class FitnessContextRepositoryImpl implements FitnessContextRepository {
  final GetWorkoutHistory _getWorkoutHistory;
  final GetPersonalRecords _getPersonalRecords;
  final WorkoutRepository _workoutRepository;

  const FitnessContextRepositoryImpl({
    required GetWorkoutHistory getWorkoutHistory,
    required GetPersonalRecords getPersonalRecords,
    required WorkoutRepository workoutRepository,
  }) : _getWorkoutHistory = getWorkoutHistory,
       _getPersonalRecords = getPersonalRecords,
       _workoutRepository = workoutRepository;

  @override
  Future<Either<Failure, FitnessContext>> getFitnessContext() async {
    final historyResult = await _getWorkoutHistory(NoParams());
    if (historyResult.isLeft()) {
      return Left(
        historyResult.fold(
          (failure) => failure,
          (_) => throw StateError('Expected left branch'),
        ),
      );
    }

    final sessions = historyResult.getOrElse(() => const []);
    final prsResult = await _getPersonalRecords(NoParams());
    final personalRecords = prsResult.getOrElse(() => const []);
    final activeSession = await _workoutRepository.loadActiveSession();

    return Right(
      _buildContext(
        sessions: sessions,
        personalRecords: personalRecords,
        activeExerciseCount: activeSession.fold(
          () => 0,
          (session) => session.exercises.length,
        ),
        hasActiveSession: activeSession.isSome(),
      ),
    );
  }

  FitnessContext _buildContext({
    required List<WorkoutSession> sessions,
    required List<PersonalRecord> personalRecords,
    required bool hasActiveSession,
    required int activeExerciseCount,
  }) {
    final now = DateTime.now();
    final lastWorkoutDate = sessions.isEmpty ? null : sessions.first.date;
    final daysSinceLastWorkout = lastWorkoutDate == null
        ? null
        : _daysBetween(lastWorkoutDate, now);

    return FitnessContext(
      lastWorkoutDate: lastWorkoutDate,
      daysSinceLastWorkout: daysSinceLastWorkout,
      sessionsLast7Days: _countSessionsSince(sessions, now.subtract(const Duration(days: 7))),
      sessionsLast30Days: _countSessionsSince(sessions, now.subtract(const Duration(days: 30))),
      totalSessions: sessions.length,
      topPersonalRecords: _topPersonalRecords(personalRecords),
      frequentExercises: _frequentExercises(sessions),
      hasActiveSession: hasActiveSession,
      activeSessionExerciseCount: activeExerciseCount,
      profile: UserFitnessProfile.empty,
    );
  }

  int _daysBetween(DateTime from, DateTime to) {
    final fromDay = DateTime(from.year, from.month, from.day);
    final toDay = DateTime(to.year, to.month, to.day);
    return toDay.difference(fromDay).inDays;
  }

  int _countSessionsSince(List<WorkoutSession> sessions, DateTime since) {
    return sessions.where((session) => !session.date.isBefore(since)).length;
  }

  List<PersonalRecord> _topPersonalRecords(List<PersonalRecord> records) {
    final sorted = List<PersonalRecord>.from(records)
      ..sort((a, b) => b.bestWeightKg.compareTo(a.bestWeightKg));
    return sorted.take(3).toList();
  }

  List<String> _frequentExercises(List<WorkoutSession> sessions) {
    final counts = <String, int>{};

    for (final session in sessions.take(5)) {
      for (final exercise in session.exercises) {
        counts.update(exercise.name, (value) => value + 1, ifAbsent: () => 1);
      }
    }

    final entries = counts.entries.toList()
      ..sort((a, b) {
        final countCompare = b.value.compareTo(a.value);
        if (countCompare != 0) return countCompare;
        return a.key.compareTo(b.key);
      });

    return entries.map((entry) => entry.key).take(5).toList();
  }
}
