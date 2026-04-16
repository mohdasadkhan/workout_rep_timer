import 'package:app_lifecycle/core/failure/failure.dart';
import 'package:app_lifecycle/core/usecases/usecase.dart';
import 'package:app_lifecycle/features/rep_tracker/domain/repositories/workout_repository.dart';
import 'package:dartz/dartz.dart';

class DeleteWorkoutSessionUsecase implements UseCase<Unit, String> {
  final WorkoutRepository repository;

  const DeleteWorkoutSessionUsecase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(String sessionId) {
    return repository.deleteWorkoutSession(sessionId);
  }
}
