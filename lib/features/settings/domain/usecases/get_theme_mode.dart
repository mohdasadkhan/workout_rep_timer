import 'package:fitflow/core/failure/failure.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/app_theme_mode.dart';
import '../repositories/theme_repository.dart';

class GetThemeMode extends UseCase<AppThemeMode, NoParams> {
  final ThemeRepository repository;
  GetThemeMode(this.repository);

  @override
  Future<Either<Failure, AppThemeMode>> call(NoParams params) async {
    return repository.getThemeMode();
  }
}