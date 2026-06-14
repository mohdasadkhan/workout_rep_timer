import 'package:dartz/dartz.dart';
import '../../../../core/failure/failure.dart';
import '../../domain/entities/app_theme_mode.dart';
import '../../domain/repositories/theme_repository.dart';
import '../datasources/theme_local_datasource.dart';

class ThemeRepositoryImpl implements ThemeRepository {
  final ThemeLocalDatasource localDatasource;

  const ThemeRepositoryImpl({required this.localDatasource});

  @override
  Future<Either<Failure, AppThemeMode>> getThemeMode() async {
    try {
      final mode = await localDatasource.getThemeMode();
      return Right(mode);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> saveThemeMode(AppThemeMode mode) async {
    try {
      await localDatasource.saveThemeMode(mode);
      return const Right(unit);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }
}