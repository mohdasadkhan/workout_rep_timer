import 'package:hive/hive.dart';
import '../../domain/entities/workout_session.dart';
import 'exercise_model.dart';


@HiveType(typeId: 2)
class WorkoutSessionModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final DateTime date;

  @HiveField(2)
  final List<ExerciseModel> exercises;

  @HiveField(3)
  final String? notes;

  WorkoutSessionModel({
    required this.id,
    required this.date,
    required this.exercises,
    this.notes,
  });

  factory WorkoutSessionModel.fromEntity(WorkoutSession entity) =>
      WorkoutSessionModel(
        id: entity.id,
        date: entity.date,
        exercises: entity.exercises.map(ExerciseModel.fromEntity).toList(),
        notes: entity.notes,
      );

  factory WorkoutSessionModel.fromJson(Map<String, dynamic> json) =>
      WorkoutSessionModel(
        id: json['id'] as String,
        date: DateTime.parse(json['date'] as String),
        exercises: (json['exercises'] as List)
            .map((e) => ExerciseModel.fromJson(e as Map<String, dynamic>))
            .toList(),
        notes: json['notes'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date.toIso8601String(),
        'exercises': exercises.map((e) => e.toJson()).toList(),
        'notes': notes,
      };

  WorkoutSession toEntity() => WorkoutSession(
        id: id,
        date: date,
        exercises: exercises.map((e) => e.toEntity()).toList(),
        notes: notes,
      );
}
