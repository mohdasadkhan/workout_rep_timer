// =====================================================
// lib/features/workout_timer/domain/usecases/generate_workout_sequence.dart
// =====================================================

import 'package:app_lifecycle/features/workout_timer/domain/entity/workout_config.dart';
import 'package:app_lifecycle/features/workout_timer/domain/entity/workout_phase.dart';

List<WorkoutPhase> generateWorkoutSequence(WorkoutConfig config) {
  final List<WorkoutPhase> sequence = [];

  // 1. Prepare (once)
  if (config.prepareSeconds > 0) {
    sequence.add(WorkoutPhase(
      name: 'Prepare',
      type: PhaseType.prepare,
      durationSeconds: config.prepareSeconds,
      currentSet: 1,
      totalSets: config.numberOfSets,
    ));
  }

  // 2. Sets loop
  for (int set = 1; set <= config.numberOfSets; set++) {
    for (int cycle = 1; cycle <= config.cyclesPerSet; cycle++) {
      // Work
      sequence.add(WorkoutPhase(
        name: 'Work',
        type: PhaseType.work,
        durationSeconds: config.workSeconds,
        currentSet: set,
        totalSets: config.numberOfSets,
        currentCycle: cycle,
        totalCycles: config.cyclesPerSet,
      ));

      // Intra-cycle Rest (only if more cycles and not last cycle)
      if (cycle < config.cyclesPerSet && config.restSeconds > 0) {
        sequence.add(WorkoutPhase(
          name: 'Rest',
          type: PhaseType.rest,
          durationSeconds: config.restSeconds,
          currentSet: set,
          totalSets: config.numberOfSets,
        ));
      }
    }

    // Rest between sets (except after last set)
    if (set < config.numberOfSets && config.restBetweenSetsSeconds > 0) {
      sequence.add(WorkoutPhase(
        name: 'Rest between sets',
        type: PhaseType.restBetweenSets,
        durationSeconds: config.restBetweenSetsSeconds,
        currentSet: set,
        totalSets: config.numberOfSets,
      ));
    }
  }

  // 3. Cool down
  if (config.coolDownSeconds > 0) {
    sequence.add(WorkoutPhase(
      name: 'Cool down',
      type: PhaseType.coolDown,
      durationSeconds: config.coolDownSeconds,
      currentSet: config.numberOfSets,
      totalSets: config.numberOfSets,
    ));
  }

  return sequence;
}