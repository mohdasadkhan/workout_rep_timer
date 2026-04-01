import 'package:app_lifecycle/core/failure/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/workout_session.dart';
import '../repositories/workout_repository.dart';

class SaveWorkoutSession implements UseCase<void, SaveWorkoutParams> {
  final WorkoutRepository repository;

  const SaveWorkoutSession(this.repository);

  @override
  Future<Either<Failure, void>> call(SaveWorkoutParams params) {
    return repository.saveWorkoutSession(params.session);
  }
}

class SaveWorkoutParams extends Equatable {
  final WorkoutSession session;

  const SaveWorkoutParams({required this.session});

  @override
  List<Object> get props => [session];
}
