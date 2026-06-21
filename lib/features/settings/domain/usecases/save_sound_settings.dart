import 'package:dartz/dartz.dart';
import 'package:fitflow/core/failure/failure.dart';
import 'package:fitflow/features/settings/domain/entities/sound_settings.dart';
import 'package:fitflow/features/settings/domain/repositories/sound_repository.dart';

class SaveSoundSettings {
  final SoundRepository _repository;
  const SaveSoundSettings(this._repository);

  Future<Either<Failure, Unit>> call(SoundSettings settings) =>
      _repository.saveSoundSettings(settings);
}