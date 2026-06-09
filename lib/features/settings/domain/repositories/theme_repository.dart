import 'package:dartz/dartz.dart';
import '../../../../core/failure/failure.dart';
import '../entities/app_theme_mode.dart';

abstract class ThemeRepository {
  Future<Either<Failure, AppThemeMode>> getThemeMode();
  Future<Either<Failure, Unit>> saveThemeMode(AppThemeMode mode);
}