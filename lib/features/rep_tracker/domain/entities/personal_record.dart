import 'package:equatable/equatable.dart';

class PersonalRecord extends Equatable {
  final String exerciseName;
  final double bestWeightKg;
  final int repsAtBestWeight;
  final DateTime achievedAt;

  const PersonalRecord({
    required this.exerciseName,
    required this.bestWeightKg,
    required this.repsAtBestWeight,
    required this.achievedAt,
  });

  @override
  List<Object> get props => [exerciseName, bestWeightKg, repsAtBestWeight, achievedAt];
}
