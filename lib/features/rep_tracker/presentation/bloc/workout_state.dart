import 'package:equatable/equatable.dart';
import '../../domain/entities/exercise.dart';
import '../../domain/entities/personal_record.dart';
import '../../domain/entities/workout_session.dart';

abstract class WorkoutState extends Equatable {
  const WorkoutState();

  @override
  List<Object?> get props => [];
}

class WorkoutInitial extends WorkoutState {
  const WorkoutInitial();
}

class WorkoutLoading extends WorkoutState {
  const WorkoutLoading();
}

/// Active session in progress
class WorkoutSessionActive extends WorkoutState {
  final String sessionId;
  final DateTime sessionDate;
  final List<Exercise> exercises;

  const WorkoutSessionActive({
    required this.sessionId,
    required this.sessionDate,
    required this.exercises,
  });

  int get totalSets => exercises.fold(0, (s, e) => s + e.sets.length);
  double get totalVolume => exercises.fold(0.0, (s, e) => s + e.totalVolume);

  WorkoutSessionActive copyWith({List<Exercise>? exercises}) {
    return WorkoutSessionActive(
      sessionId: sessionId,
      sessionDate: sessionDate,
      exercises: exercises ?? this.exercises,
    );
  }

  @override
  List<Object> get props => [sessionId, sessionDate, exercises];
}

class WorkoutSessionSaved extends WorkoutState {
  const WorkoutSessionSaved();
}

class WorkoutHistoryLoaded extends WorkoutState {
  final List<WorkoutSession> sessions;

  const WorkoutHistoryLoaded({required this.sessions});

  @override
  List<Object> get props => [sessions];
}

class PersonalRecordsLoaded extends WorkoutState {
  final List<PersonalRecord> records;

  const PersonalRecordsLoaded({required this.records});

  @override
  List<Object> get props => [records];
}

class WorkoutError extends WorkoutState {
  final String message;

  const WorkoutError({required this.message});

  @override
  List<Object> get props => [message];
}
