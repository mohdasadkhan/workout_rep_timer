import 'package:app_lifecycle/core/failure/failure.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/workout_session.dart';
import '../repositories/workout_repository.dart';

class GetWorkoutHistory implements UseCase<List<WorkoutSession>, NoParams> {
  final WorkoutRepository repository;

  const GetWorkoutHistory(this.repository);

  @override
  Future<Either<Failure, List<WorkoutSession>>> call(NoParams params) {
    return repository.getWorkoutHistory();
  }
}
