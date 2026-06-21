import 'package:dartz/dartz.dart';
import 'package:fitflow/core/failure/failure.dart';
import 'package:fitflow/features/settings/domain/entities/sound_settings.dart';
import 'package:fitflow/features/settings/domain/repositories/sound_repository.dart';

class GetSoundSettings {
  final SoundRepository _repository;
  const GetSoundSettings(this._repository);

  Future<Either<Failure, SoundSettings>> call() =>
      _repository.getSoundSettings();
}