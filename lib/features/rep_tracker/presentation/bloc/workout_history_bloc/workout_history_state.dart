import 'package:app_lifecycle/features/rep_tracker/domain/entities/workout_session.dart';
import 'package:equatable/equatable.dart';

abstract class WorkoutHistoryState extends Equatable {
  const WorkoutHistoryState();

  @override
  List<Object?> get props => [];
}

final class WorkoutHistoryInitial extends WorkoutHistoryState {
  const WorkoutHistoryInitial();
}

class WorkoutHistoryLoaded extends WorkoutHistoryState {
  final List<WorkoutSession> sessions;
  const WorkoutHistoryLoaded({required this.sessions});

  @override
  List<Object?> get props => [sessions];
}

class WorkoutHistoryLoading extends WorkoutHistoryState {
  const WorkoutHistoryLoading();
}

class WorkoutHistoryError extends WorkoutHistoryState {
  final String message;
  const WorkoutHistoryError({required this.message});

  @override
  List<Object?> get props => [message];
}
