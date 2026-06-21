import 'package:dartz/dartz.dart';
import 'package:fitflow/core/failure/failure.dart';
import 'package:fitflow/features/settings/data/datasources/sound_local_datasource.dart';
import 'package:fitflow/features/settings/domain/entities/sound_settings.dart';
import 'package:fitflow/features/settings/domain/repositories/sound_repository.dart';

class SoundRepositoryImpl implements SoundRepository {
  final SoundLocalDatasource _datasource;

  const SoundRepositoryImpl({required SoundLocalDatasource datasource})
      : _datasource = datasource;

  @override
  Future<Either<Failure, SoundSettings>> getSoundSettings() async {
    try {
      final settings = await _datasource.getSoundSettings();
      return Right(settings);
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to load sound settings: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> saveSoundSettings(
      SoundSettings settings) async {
    try {
      await _datasource.saveSoundSettings(settings);
      return const Right(unit);
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to save sound settings: $e'));
    }
  }
}