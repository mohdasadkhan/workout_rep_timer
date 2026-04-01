import 'package:app_lifecycle/core/failure/cache_exceptions.dart';
import 'package:app_lifecycle/core/failure/failure.dart';
import 'package:dartz/dartz.dart';
import '../../domain/entities/personal_record.dart';
import '../../domain/entities/workout_session.dart';
import '../../domain/repositories/workout_repository.dart';
import '../datasources/workout_local_datasource.dart';
import '../models/workout_session_model.dart';

class WorkoutRepositoryImpl implements WorkoutRepository {
  final WorkoutLocalDatasource localDatasource;

  const WorkoutRepositoryImpl({required this.localDatasource});

  @override
  Future<Either<Failure, void>> saveWorkoutSession(
      WorkoutSession session) async {
    try {
      await localDatasource
          .saveWorkoutSession(WorkoutSessionModel.fromEntity(session));
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<WorkoutSession>>> getWorkoutHistory() async {
    try {
      final models = await localDatasource.getWorkoutHistory();
      return Right(models.map((m) => m.toEntity()).toList());
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<PersonalRecord>>> getPersonalRecords() async {
    try {
      final models = await localDatasource.getWorkoutHistory();
      final sessions = models.map((m) => m.toEntity()).toList();
      final records = _computePersonalRecords(sessions);
      return Right(records);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  /// Scans all history and keeps the heaviest set per exercise name.
  List<PersonalRecord> _computePersonalRecords(List<WorkoutSession> sessions) {
    final Map<String, PersonalRecord> recordMap = {};

    for (final session in sessions) {
      for (final exercise in session.exercises) {
        final best = exercise.bestSet;
        if (best == null) continue;

        final existing = recordMap[exercise.name];
        if (existing == null || best.weightKg > existing.bestWeightKg) {
          recordMap[exercise.name] = PersonalRecord(
            exerciseName: exercise.name,
            bestWeightKg: best.weightKg,
            repsAtBestWeight: best.reps,
            achievedAt: best.performedAt,
          );
        }
      }
    }

    return recordMap.values.toList()
      ..sort((a, b) => b.achievedAt.compareTo(a.achievedAt));
  }
}
