import 'package:app_lifecycle/core/failure/failure.dart';
import 'package:dartz/dartz.dart';
import '../entities/personal_record.dart';
import '../entities/workout_session.dart';

/// D in SOLID — high-level modules depend on this abstraction, not the Hive impl.
abstract class WorkoutRepository {
  Future<Either<Failure, void>> saveWorkoutSession(WorkoutSession session);
  Future<Either<Failure, List<WorkoutSession>>> getWorkoutHistory();
  Future<Either<Failure, List<PersonalRecord>>> getPersonalRecords();
}
