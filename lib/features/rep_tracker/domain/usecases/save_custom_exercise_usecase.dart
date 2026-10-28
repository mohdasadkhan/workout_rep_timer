// domain/usecases/save_custom_exercise_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:fitflow/core/failure/failure.dart';
import 'package:fitflow/core/usecases/usecase.dart';
import 'package:fitflow/features/rep_tracker/domain/repositories/exercise_catalog_repository.dart';

class SaveCustomExerciseUseCase implements UseCase<void, SaveExerciseParams> {
  final ExerciseCatalogRepository repository;
  SaveCustomExerciseUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(SaveExerciseParams params) {
    return repository.saveCustomExercise(params.category, params.name);
  }
}

class SaveExerciseParams {
  final String category;
  final String name;
  SaveExerciseParams(this.category, this.name);
}
