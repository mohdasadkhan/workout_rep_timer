import 'package:fitflow/core/failure/failure.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/app_theme_mode.dart';
import '../repositories/theme_repository.dart';

class SaveThemeMode extends UseCase<Unit, AppThemeMode> {
  final ThemeRepository repository;
  SaveThemeMode(this.repository);

  @override
  Future<Either<Failure, Unit>> call(AppThemeMode mode) async {
    return repository.saveThemeMode(mode);
  }
}