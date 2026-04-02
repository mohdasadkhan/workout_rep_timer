import 'package:equatable/equatable.dart';

class WorkoutConfig extends Equatable {
  final int prepareSeconds;
  final int workSeconds;
  final int restSeconds;
  final int cyclesPerSet;
  final int numberOfSets;
  final int restBetweenSetsSeconds;
  final int coolDownSeconds;

  const WorkoutConfig({
    this.prepareSeconds = 30,
    this.workSeconds = 60,
    this.restSeconds = 0,
    this.cyclesPerSet = 1,
    this.numberOfSets = 3,
    this.restBetweenSetsSeconds = 90,
    this.coolDownSeconds = 0,
  });

  WorkoutConfig copyWith({
    int? prepareSeconds,
    int? workSeconds,
    int? restSeconds,
    int? cyclesPerSet,
    int? numberOfSets,
    int? restBetweenSetsSeconds,
    int? coolDownSeconds,
  }) {
    return WorkoutConfig(
      prepareSeconds: prepareSeconds ?? this.prepareSeconds,
      workSeconds: workSeconds ?? this.workSeconds,
      restSeconds: restSeconds ?? this.restSeconds,
      cyclesPerSet: cyclesPerSet ?? this.cyclesPerSet,
      numberOfSets: numberOfSets ?? this.numberOfSets,
      restBetweenSetsSeconds:
          restBetweenSetsSeconds ?? this.restBetweenSetsSeconds,
      coolDownSeconds: coolDownSeconds ?? this.coolDownSeconds,
    );
  }

  @override
  List<Object?> get props => [
    prepareSeconds,
    workSeconds,
    restSeconds,
    cyclesPerSet,
    numberOfSets,
    restBetweenSetsSeconds,
    coolDownSeconds,
  ];
}
