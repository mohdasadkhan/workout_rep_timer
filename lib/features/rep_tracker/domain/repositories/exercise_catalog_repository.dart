// domain/repository/exercise_catalog_repository.dart
import 'package:dartz/dartz.dart';
import 'package:fitflow/core/failure/failure.dart';

abstract class ExerciseCatalogRepository {
  /// Returns custom (user-added) exercise names saved for [category].
  Future<Either<Failure, List<String>>> getCustomExercises(String category);

  /// Saves [name] under [category] if it's not already stored.
  Future<Either<Failure, void>> saveCustomExercise(
    String category,
    String name,
  );
  Future<Either<Failure, void>> deleteCustomExercise(String name);
}
