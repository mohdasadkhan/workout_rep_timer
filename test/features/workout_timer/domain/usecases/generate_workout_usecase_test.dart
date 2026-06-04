import 'package:app_lifecycle/features/workout_timer/domain/entity/workout_config.dart';
import 'package:app_lifecycle/features/workout_timer/domain/entity/workout_phase.dart';
import 'package:app_lifecycle/features/workout_timer/domain/usecases/generate_workout_usecase.dart';
import 'package:test/test.dart';

void main() {
  test('generates phases from workout config', () {
    const config = WorkoutConfig(
      prepareSeconds: 5,
      workSeconds: 20,
      restSeconds: 10,
      cyclesPerSet: 2,
      numberOfSets: 2,
      restBetweenSetsSeconds: 30,
      coolDownSeconds: 15,
    );

    final sequence = generateWorkoutSequence(config);

    expect(sequence.first.type, PhaseType.prepare);
    expect(sequence.last.type, PhaseType.coolDown);
    expect(sequence.where((p) => p.type == PhaseType.work).length, 4);
  });

  test('skips zero-duration phases', () {
    const config = WorkoutConfig(
      prepareSeconds: 0,
      workSeconds: 30,
      restSeconds: 0,
      cyclesPerSet: 1,
      numberOfSets: 1,
      restBetweenSetsSeconds: 0,
      coolDownSeconds: 0,
    );

    final sequence = generateWorkoutSequence(config);
    expect(sequence.length, 1);
    expect(sequence.single.type, PhaseType.work);
  });
}
