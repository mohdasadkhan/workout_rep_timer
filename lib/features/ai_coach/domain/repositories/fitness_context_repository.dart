import 'package:dartz/dartz.dart';
import 'package:fitflow/core/failure/failure.dart';
import 'package:fitflow/features/ai_coach/domain/entities/fitness_context.dart';

abstract class FitnessContextRepository {
  Future<Either<Failure, FitnessContext>> getFitnessContext();
}
