import 'package:equatable/equatable.dart';
import '../../../domain/entities/exercise_set.dart';

abstract class WorkoutSessionEvent extends Equatable {
  const WorkoutSessionEvent();

  @override
  List<Object?> get props => [];
}

class StartWorkoutSession extends WorkoutSessionEvent {
  const StartWorkoutSession();
}

class AddExercise extends WorkoutSessionEvent {
  final String exerciseName;
  const AddExercise({required this.exerciseName});

  @override
  List<Object?> get props => [exerciseName];
}

class LogSet extends WorkoutSessionEvent {
  final String exerciseId;
  final ExerciseSet set;
  const LogSet({required this.exerciseId, required this.set});

  @override
  List<Object?> get props => [exerciseId, set];
}

class UpdateSet extends WorkoutSessionEvent {
  final String exerciseId;
  final String setId;
  final double weightKg;
  final int reps;
  const UpdateSet({
    required this.exerciseId,
    required this.setId,
    required this.weightKg,
    required this.reps,
  });

  @override
  List<Object?> get props => [exerciseId, setId, weightKg, reps];
}

class RemoveSet extends WorkoutSessionEvent {
  final String exerciseId;
  final String setId;
  const RemoveSet({required this.exerciseId, required this.setId});

  @override
  List<Object?> get props => [exerciseId, setId];
}

class RemoveExercise extends WorkoutSessionEvent {
  final String exerciseId;
  const RemoveExercise(this.exerciseId);

  @override
  List<Object?> get props => [exerciseId];
}

class FinishWorkoutSession extends WorkoutSessionEvent {
  const FinishWorkoutSession();
}
