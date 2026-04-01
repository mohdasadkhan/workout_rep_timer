import 'package:equatable/equatable.dart';

class ExerciseSet extends Equatable {
  final String id;
  final double weightKg;
  final int reps;
  final DateTime performedAt;

  const ExerciseSet({
    required this.id,
    required this.weightKg,
    required this.reps,
    required this.performedAt,
  });

  double get volume => weightKg * reps;

  @override
  List<Object> get props => [id, weightKg, reps, performedAt];
}
