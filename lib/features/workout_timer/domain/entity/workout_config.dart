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

  factory WorkoutConfig.fromQuery(Map<String, String> query) {
    int parse(String key, int defaultValue) {
      final value = int.tryParse(query[key] ?? '');
      if (value == null || value < 0) return defaultValue;
      return value;
    }

    return WorkoutConfig(
      prepareSeconds: parse('prepare', 30),
      workSeconds: parse('work', 60),
      restSeconds: parse('rest', 0),
      cyclesPerSet: parse('cycles', 1),
      numberOfSets: parse('sets', 3),
      restBetweenSetsSeconds: parse('setRest', 90),
      coolDownSeconds: parse('cooldown', 0),
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
