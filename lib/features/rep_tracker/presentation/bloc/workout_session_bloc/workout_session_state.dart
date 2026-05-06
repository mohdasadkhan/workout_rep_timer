import 'package:equatable/equatable.dart';
import '../../../domain/entities/exercise.dart';

abstract class WorkoutSessionState extends Equatable {
  const WorkoutSessionState();

  @override
  List<Object?> get props => [];
}

class WorkoutInitial extends WorkoutSessionState {
  const WorkoutInitial();
}

class WorkoutLoading extends WorkoutSessionState {
  const WorkoutLoading();
}

class WorkoutSessionActive extends WorkoutSessionState {
  final String sessionId;
  final DateTime sessionDate;
  final List<Exercise> exercises;

  const WorkoutSessionActive({
    required this.sessionId,
    required this.sessionDate,
    required this.exercises,
  });

  int get totalSets => exercises.fold(0, (sum, e) => sum + e.sets.length);

  double get totalVolume => exercises.fold(
    0.0,
    (sum, e) => sum + e.sets.fold(0.0, (s, set) => s + set.weightKg * set.reps),
  );

  WorkoutSessionActive copyWith({List<Exercise>? exercises}) {
    return WorkoutSessionActive(
      sessionId: sessionId,
      sessionDate: sessionDate,
      exercises: exercises ?? this.exercises,
    );
  }

  @override
  List<Object?> get props => [sessionId, sessionDate, exercises];
}

class WorkoutSessionSaved extends WorkoutSessionState {
  const WorkoutSessionSaved();
}

class WorkoutSessionError extends WorkoutSessionState {
  final String message;
  const WorkoutSessionError({required this.message});

  @override
  List<Object?> get props => [message];
}
