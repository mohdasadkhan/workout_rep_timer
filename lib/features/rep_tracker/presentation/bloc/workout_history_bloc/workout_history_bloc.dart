import 'package:app_lifecycle/core/usecases/usecase.dart';
import 'package:app_lifecycle/features/rep_tracker/domain/usecases/delete_workout_session.dart';
import 'package:app_lifecycle/features/rep_tracker/domain/usecases/get_workout_history.dart';
import 'package:app_lifecycle/features/rep_tracker/domain/usecases/save_workout_session.dart';
import 'package:app_lifecycle/features/rep_tracker/presentation/bloc/personal_records_bloc/personal_records_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'workout_history_event.dart';
import 'workout_history_state.dart';

class WorkoutHistoryBloc
    extends Bloc<WorkoutHistoryEvent, WorkoutHistoryState> {
  final GetWorkoutHistory getWorkoutHistory;
  final DeleteWorkoutSessionUsecase deleteWorkoutSession;
  final SaveWorkoutSession saveWorkoutSession;

  WorkoutHistoryBloc({
    required this.getWorkoutHistory,
    required this.deleteWorkoutSession,
    required this.saveWorkoutSession,
  }) : super(const WorkoutHistoryInitial()) {
    on<LoadWorkoutHistory>(_onLoadHistory);
    on<DeleteWorkoutSessionEvent>(_onDeleteWorkoutSession);
    on<RestoreWorkoutSessionEvent>(_restoreWorkoutSession);
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

  Future<void> _onDeleteWorkoutSession(
    DeleteWorkoutSessionEvent event,
    Emitter<WorkoutHistoryState> emit,
  ) async {
    final result = await deleteWorkoutSession(event.sessionId);

    result.fold(
      (failure) => emit(WorkoutHistoryError(message: failure.message)),
      (_) {
        add(const LoadWorkoutHistory());
      },
    );
  }

  Future<void> _restoreWorkoutSession(
    RestoreWorkoutSessionEvent event,
    Emitter<WorkoutHistoryState> emit,
  ) async {
    final result = await saveWorkoutSession(
      SaveWorkoutParams(session: event.session),
    );

    result.fold(
      (failure) => emit(WorkoutHistoryError(message: failure.message)),
      (_) {
        add(const LoadWorkoutHistory());
      },
    );
  }
}
