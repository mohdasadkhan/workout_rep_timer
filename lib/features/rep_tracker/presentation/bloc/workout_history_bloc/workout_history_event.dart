import 'package:equatable/equatable.dart';

sealed class WorkoutHistoryEvent extends Equatable {
  const WorkoutHistoryEvent();

  @override
  List<Object> get props => [];
}

class LoadWorkoutHistory extends WorkoutHistoryEvent {
  const LoadWorkoutHistory();
}
