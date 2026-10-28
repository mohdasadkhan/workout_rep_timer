// domain/usecases/delete_custom_exercise_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:fitflow/core/failure/failure.dart';
import 'package:fitflow/core/usecases/usecase.dart';
import 'package:fitflow/features/rep_tracker/domain/repositories/exercise_catalog_repository.dart';

class DeleteCustomExerciseUseCase implements UseCase<void, String> {
  final ExerciseCatalogRepository repository;
  DeleteCustomExerciseUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(String name) =>
      repository.deleteCustomExercise(name);
}
