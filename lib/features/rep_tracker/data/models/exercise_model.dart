import 'package:hive/hive.dart';
import '../../domain/entities/exercise.dart';
import 'set_model.dart';

@HiveType(typeId: 1)
class ExerciseModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final List<SetModel> sets;

  ExerciseModel({required this.id, required this.name, required this.sets});

  factory ExerciseModel.fromEntity(Exercise entity) => ExerciseModel(
    id: entity.id,
    name: entity.name,
    sets: entity.sets.map(SetModel.fromEntity).toList(),
  );

  factory ExerciseModel.fromJson(Map<String, dynamic> json) => ExerciseModel(
    id: json['id'] as String,
    name: json['name'] as String,
    sets: (json['sets'] as List)
        .map((s) => SetModel.fromJson(s as Map<String, dynamic>))
        .toList(),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'sets': sets.map((s) => s.toJson()).toList(),
  };

  Exercise toEntity() => Exercise(
    id: id,
    name: name,
    sets: sets.map((s) => s.toEntity()).toList(),
  );
}
