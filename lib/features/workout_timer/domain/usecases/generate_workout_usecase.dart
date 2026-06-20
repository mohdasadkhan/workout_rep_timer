import 'package:fitflow/features/workout_timer/domain/entity/workout_config.dart';
import 'package:fitflow/features/workout_timer/domain/entity/workout_phase.dart';

List<WorkoutPhase> generateWorkoutSequence(WorkoutConfig config) {
  final List<WorkoutPhase> sequence = [];

  if (config.prepareSeconds > 0) {
    sequence.add(
      WorkoutPhase(
        name: 'Prepare',
        type: PhaseType.prepare,
        durationSeconds: config.prepareSeconds,
        currentSet: 1,
        totalSets: config.numberOfSets,
      ),
    );
  }

  for (int set = 1; set <= config.numberOfSets; set++) {
    for (int cycle = 1; cycle <= config.cyclesPerSet; cycle++) {
      sequence.add(
        WorkoutPhase(
          name: 'Work',
          type: PhaseType.work,
          durationSeconds: config.workSeconds,
          currentSet: set,
          totalSets: config.numberOfSets,
          currentCycle: cycle,
          totalCycles: config.cyclesPerSet,
        ),
      );

      final bool isLastCycleOfSet = cycle == config.cyclesPerSet;
      final bool isLastSet = set == config.numberOfSets;

      // Intra-cycle rest: between cycles within a set
      final bool addIntraCycleRest = config.restSeconds > 0 &&
          (
            // Multiple cycles: add rest between them (not after the last one)
            !isLastCycleOfSet ||
            // Single cycle per set: treat intra-cycle rest as the gap between sets
            // but only when restBetweenSets is 0, and it's not the last set
            (config.cyclesPerSet == 1 &&
                config.restBetweenSetsSeconds == 0 &&
                !isLastSet)
          );

      if (addIntraCycleRest) {
        sequence.add(
          WorkoutPhase(
            name: 'Rest',
            type: PhaseType.rest,
            durationSeconds: config.restSeconds,
            currentSet: set,
            totalSets: config.numberOfSets,
            currentCycle: cycle,
            totalCycles: config.cyclesPerSet,
          ),
        );
      }
    }

    // Rest between sets (only if restBetweenSets is configured and not the last set)
    if (set < config.numberOfSets && config.restBetweenSetsSeconds > 0) {
      sequence.add(
        WorkoutPhase(
          name: 'Rest between sets',
          type: PhaseType.restBetweenSets,
          durationSeconds: config.restBetweenSetsSeconds,
          currentSet: set,
          totalSets: config.numberOfSets,
        ),
      );
    }
  }

  if (config.coolDownSeconds > 0) {
    sequence.add(
      WorkoutPhase(
        name: 'Cool down',
        type: PhaseType.coolDown,
        durationSeconds: config.coolDownSeconds,
        currentSet: config.numberOfSets,
        totalSets: config.numberOfSets,
      ),
    );
  }

  return sequence;
}