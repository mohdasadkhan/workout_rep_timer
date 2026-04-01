import 'package:equatable/equatable.dart';
import 'exercise.dart';

class WorkoutSession extends Equatable {
  final String id;
  final DateTime date;
  final List<Exercise> exercises;
  final String? notes;

  const WorkoutSession({
    required this.id,
    required this.date,
    required this.exercises,
    this.notes,
  });

  int get totalSets => exercises.fold(0, (sum, e) => sum + e.sets.length);

  double get totalVolume => exercises.fold(0, (sum, e) => sum + e.totalVolume);

  WorkoutSession copyWith({
    String? id,
    DateTime? date,
    List<Exercise>? exercises,
    String? notes,
  }) {
    return WorkoutSession(
      id: id ?? this.id,
      date: date ?? this.date,
      exercises: exercises ?? this.exercises,
      notes: notes ?? this.notes,
    );
  }

  @override
  List<Object?> get props => [id, date, exercises, notes];
}
