import 'package:app_lifecycle/core/usecases/usecase.dart';
import 'package:app_lifecycle/features/rep_tracker/domain/usecases/get_workout_history.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'workout_history_event.dart';
import 'workout_history_state.dart';

class WorkoutHistoryBloc
    extends Bloc<WorkoutHistoryEvent, WorkoutHistoryState> {
  final GetWorkoutHistory getWorkoutHistory;

  WorkoutHistoryBloc({required this.getWorkoutHistory})
    : super(const WorkoutHistoryInitial()) {
    on<LoadWorkoutHistory>(_onLoadHistory);
  }

  Future<void> _onLoadHistory(
    LoadWorkoutHistory event,
    Emitter<WorkoutHistoryState> emit,
  ) async {
    emit(const WorkoutHistoryLoading());
    final result = await getWorkoutHistory(NoParams());
    result.fold(
      (failure) => emit(WorkoutHistoryError(message: failure.message)),
      (sessions) =>
          emit(WorkoutHistoryLoaded(sessions: List.unmodifiable(sessions))),
    );
  }
}
