import 'package:app_lifecycle/features/rep_tracker/domain/entities/workout_session.dart';
import 'package:equatable/equatable.dart';

sealed class WorkoutHistoryEvent extends Equatable {
  const WorkoutHistoryEvent();

  @override
  List<Object?> get props => [];
}

class LoadWorkoutHistory extends WorkoutHistoryEvent {
  const LoadWorkoutHistory();
}

class DeleteWorkoutSessionEvent extends WorkoutHistoryEvent {
  final WorkoutSession session;
  final String sessionId;

  const DeleteWorkoutSessionEvent({
    required this.session,
    required this.sessionId,
  });

  @override
  List<Object?> get props => [sessionId];
}

class RestoreWorkoutSessionEvent extends WorkoutHistoryEvent {
  final WorkoutSession session;

  const RestoreWorkoutSessionEvent(this.session);

  @override
  List<Object?> get props => [session];
}
