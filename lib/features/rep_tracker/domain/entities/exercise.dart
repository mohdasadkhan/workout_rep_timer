import 'package:equatable/equatable.dart';
import 'exercise_set.dart';

class Exercise extends Equatable {
  final String id;
  final String name;
  final List<ExerciseSet> sets;

  const Exercise({required this.id, required this.name, required this.sets});

  double get totalVolume => sets.fold(0, (sum, s) => sum + s.volume);

  ExerciseSet? get bestSet => sets.isEmpty
      ? null
      : sets.reduce((a, b) => a.weightKg > b.weightKg ? a : b);

  Exercise copyWith({String? id, String? name, List<ExerciseSet>? sets}) {
    return Exercise(
      id: id ?? this.id,
      name: name ?? this.name,
      sets: sets ?? this.sets,
    );
  }

  @override
  List<Object> get props => [id, name, sets];
}
