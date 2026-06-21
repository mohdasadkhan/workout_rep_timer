import 'package:flutter/material.dart';
import 'package:fitflow/features/workout_timer/domain/entity/workout_phase.dart';

/// Drives [TimerTopBar] — set progress dots + pause/play button.
class TopBarViewModel {
  final int currentSet;
  final int totalSets;
  final bool isPaused;
  final Color color;

  const TopBarViewModel({
    required this.currentSet,
    required this.totalSets,
    required this.isPaused,
    required this.color,
  });

  const TopBarViewModel.empty()
      : currentSet = 0,
        totalSets = 0,
        isPaused = false,
        color = Colors.grey;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TopBarViewModel &&
          currentSet == other.currentSet &&
          totalSets == other.totalSets &&
          isPaused == other.isPaused &&
          color == other.color;

  @override
  int get hashCode =>
      Object.hash(currentSet, totalSets, isPaused, color);
}

/// Drives [TimerCircle] — countdown arc + time display.
class TimerCircleViewModel {
  final int remainingSeconds;
  final int totalDuration;
  final Color phaseColor;
  final bool isPaused;

  const TimerCircleViewModel({
    required this.remainingSeconds,
    required this.totalDuration,
    required this.phaseColor,
    required this.isPaused,
  });

  const TimerCircleViewModel.empty()
      : remainingSeconds = 0,
        totalDuration = 0,
        phaseColor = Colors.grey,
        isPaused = false;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimerCircleViewModel &&
          remainingSeconds == other.remainingSeconds &&
          totalDuration == other.totalDuration &&
          phaseColor == other.phaseColor &&
          isPaused == other.isPaused;

  @override
  int get hashCode =>
      Object.hash(remainingSeconds, totalDuration, phaseColor, isPaused);
}

/// Drives [TimerSequenceList] — scrollable phase list.
class SequenceViewModel {
  final List<WorkoutPhase> sequence;
  final int currentIndex;
  final int remainingSeconds;

  const SequenceViewModel({
    required this.sequence,
    required this.currentIndex,
    required this.remainingSeconds,
  });

  const SequenceViewModel.empty()
      : sequence = const [],
        currentIndex = 0,
        remainingSeconds = 0;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SequenceViewModel &&
          currentIndex == other.currentIndex &&
          remainingSeconds == other.remainingSeconds &&
          sequence == other.sequence;

  @override
  int get hashCode =>
      Object.hash(sequence, currentIndex, remainingSeconds);
}