// domain/usecases/get_exercises_for_category_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:fitflow/core/failure/failure.dart';
import 'package:fitflow/core/usecases/usecase.dart';
import 'package:fitflow/features/rep_tracker/domain/repositories/exercise_catalog_repository.dart'; // your shared UseCase<Type, Params>

class GetExercisesForCategoryUseCase
    implements UseCase<List<String>, GetExercisesParams> {
  final ExerciseCatalogRepository repository;
  GetExercisesForCategoryUseCase(this.repository);

  @override
  Future<Either<Failure, List<String>>> call(GetExercisesParams params) {
    return repository.getCustomExercises(params.category);
  }
}

class GetExercisesParams {
  final String category;
  GetExercisesParams(this.category);
}