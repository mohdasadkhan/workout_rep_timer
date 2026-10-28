import 'package:dartz/dartz.dart';
import 'package:fitflow/core/failure/failure.dart';
import 'package:fitflow/core/usecases/usecase.dart';
import 'package:fitflow/features/ai_coach/domain/entities/fitness_context.dart';
import 'package:fitflow/features/ai_coach/domain/repositories/fitness_context_repository.dart';

class BuildFitnessContext implements UseCase<FitnessContext, NoParams> {
  final FitnessContextRepository repository;

  const BuildFitnessContext(this.repository);

  @override
  Future<Either<Failure, FitnessContext>> call(NoParams params) {
    return repository.getFitnessContext();
  }
}
