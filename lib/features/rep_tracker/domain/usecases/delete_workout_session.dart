import 'package:fitflow/core/failure/failure.dart';
import 'package:fitflow/core/usecases/usecase.dart';
import 'package:fitflow/features/rep_tracker/domain/repositories/workout_repository.dart';
import 'package:dartz/dartz.dart';

class DeleteWorkoutSessionUsecase implements UseCase<Unit, String> {
  final WorkoutRepository repository;

  const DeleteWorkoutSessionUsecase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(String sessionId) {
    return repository.deleteWorkoutSession(sessionId);
  }
}
