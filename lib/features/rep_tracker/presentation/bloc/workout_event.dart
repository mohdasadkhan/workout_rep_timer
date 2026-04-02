import 'package:equatable/equatable.dart';
import '../../domain/entities/exercise_set.dart';

abstract class WorkoutEvent extends Equatable {
  const WorkoutEvent();

  @override
  List<Object?> get props => [];
}

class StartWorkoutSession extends WorkoutEvent {
  const StartWorkoutSession();
}

class AddExercise extends WorkoutEvent {
  final String exerciseName;

  const AddExercise({required this.exerciseName});

  @override
  List<Object> get props => [exerciseName];
}

class LogSet extends WorkoutEvent {
  final String exerciseId;
  final ExerciseSet set;

  const LogSet({required this.exerciseId, required this.set});

  @override
  List<Object> get props => [exerciseId, set];
}

class RemoveSet extends WorkoutEvent {
  final String exerciseId;
  final String setId;

  const RemoveSet({required this.exerciseId, required this.setId});

  @override
  List<Object> get props => [exerciseId, setId];
}

class FinishWorkoutSession extends WorkoutEvent {
  const FinishWorkoutSession();
}

class LoadWorkoutHistory extends WorkoutEvent {
  const LoadWorkoutHistory();
}

class LoadPersonalRecords extends WorkoutEvent {
  const LoadPersonalRecords();
}
