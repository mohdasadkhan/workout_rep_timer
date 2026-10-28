import '../../domain/entities/exercise_set.dart';
import '../../domain/entities/exercise_set.dart';

class SetModel {
  final String id;
  final double weightKg;
  final int reps;
  final DateTime performedAt;

  SetModel({
    required this.id,
    required this.weightKg,
    required this.reps,
    required this.performedAt,
  });

  factory SetModel.fromEntity(ExerciseSet entity) => SetModel(
    id: entity.id,
    weightKg: entity.weightKg,
    reps: entity.reps,
    performedAt: entity.performedAt,
  );

  factory SetModel.fromJson(Map<String, dynamic> json) => SetModel(
    id: json['id'] as String,
    weightKg: (json['weightKg'] as num).toDouble(),
    reps: json['reps'] as int,
    performedAt: DateTime.parse(json['performedAt'] as String),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'weightKg': weightKg,
    'reps': reps,
    'performedAt': performedAt.toIso8601String(),
  };

  ExerciseSet toEntity() => ExerciseSet(
    id: id,
    weightKg: weightKg,
    reps: reps,
    performedAt: performedAt,
  );
}
