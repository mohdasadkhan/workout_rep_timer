import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum PhaseType { prepare, work, rest, restBetweenSets, coolDown }

class WorkoutPhase extends Equatable {
  final String name;
  final PhaseType type;
  final int durationSeconds;
  final int currentSet;
  final int totalSets;
  final int? currentCycle;
  final int? totalCycles;

  const WorkoutPhase({
    required this.name,
    required this.type,
    required this.durationSeconds,
    required this.currentSet,
    required this.totalSets,
    this.currentCycle,
    this.totalCycles,
  });

  Color get color {
    switch (type) {
      case PhaseType.prepare:
        return Colors.blue;
      case PhaseType.work:
        return Colors.redAccent;
      case PhaseType.rest:
      case PhaseType.restBetweenSets:
        return Colors.orange;
      case PhaseType.coolDown:
        return Colors.purple;
    }
  }

  @override
  List<Object?> get props => [
    name,
    type,
    durationSeconds,
    currentSet,
    totalSets,
    currentCycle,
    totalCycles,
  ];
}
