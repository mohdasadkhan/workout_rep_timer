import 'package:dartz/dartz.dart';
import 'package:fitflow/core/failure/failure.dart';
import 'package:fitflow/features/settings/domain/entities/sound_settings.dart';

/// Abstract contract — TimerBloc and SoundSettingsBloc depend on this,
/// never on the concrete impl. Follows the same pattern as [ThemeRepository].
abstract class SoundRepository {
  Future<Either<Failure, SoundSettings>> getSoundSettings();
  Future<Either<Failure, Unit>> saveSoundSettings(SoundSettings settings);
}