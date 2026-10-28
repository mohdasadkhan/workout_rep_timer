// data/repository/hive_exercise_catalog_repository.dart
import 'package:dartz/dartz.dart';
import 'package:fitflow/core/failure/failure.dart';
import 'package:fitflow/features/rep_tracker/domain/repositories/exercise_catalog_repository.dart';
import 'package:hive/hive.dart';

class HiveExerciseCatalogRepository implements ExerciseCatalogRepository {
  static const boxName = 'custom_exercises_box';
  final Box _box;

  HiveExerciseCatalogRepository(this._box);

  @override
  Future<Either<Failure, List<String>>> getCustomExercises(
    String category,
  ) async {
    try {
      if (category == 'All') {
        // Merge custom exercises saved under every real category
        final allCustom = <String>{};
        for (final key in _box.keys) {
          final list = _box.get(key, defaultValue: <String>[]);
          allCustom.addAll(List<String>.from(list as List));
        }
        return Right(allCustom.toList());
      }
      final raw = _box.get(category, defaultValue: <String>[]);
      final list = List<String>.from(raw as List);
      return Right(list);
    } catch (e) {
      // Crash-safety: never let a corrupted box entry break the UI
      return const Right(<String>[]);
    }
  }

  @override
  Future<Either<Failure, void>> saveCustomExercise(
    String category,
    String name,
  ) async {
    try {
      final existing = List<String>.from(
        _box.get(category, defaultValue: <String>[]) as List,
      );
      if (existing.any((e) => e.toLowerCase() == name.toLowerCase())) {
        return const Right(null); // already saved, no-op
      }
      existing.add(name);
      await _box.put(category, existing);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteCustomExercise(String name) async {
    try {
      for (final key in _box.keys) {
        final list = List<String>.from(
          _box.get(key, defaultValue: <String>[]) as List,
        );
        if (list.any((e) => e.toLowerCase() == name.toLowerCase())) {
          list.removeWhere((e) => e.toLowerCase() == name.toLowerCase());
          await _box.put(key, list);
        }
      }
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }
}
