import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/exercise.dart';
import '../../domain/entities/workout_session.dart';
import '../../domain/usecases/get_personal_records.dart';
import '../../domain/usecases/get_workout_history.dart';
import '../../domain/usecases/save_workout_session.dart';
import 'workout_event.dart';
import 'workout_state.dart';

class WorkoutBloc extends Bloc<WorkoutEvent, WorkoutState> {
  final SaveWorkoutSession saveWorkoutSession;
  final GetWorkoutHistory getWorkoutHistory;
  final GetPersonalRecords getPersonalRecords;
  final Uuid uuid;

  WorkoutBloc({
    required this.saveWorkoutSession,
    required this.getWorkoutHistory,
    required this.getPersonalRecords,
    Uuid? uuid,
  }) : uuid = uuid ?? const Uuid(),
       super(const WorkoutInitial()) {
    on<StartWorkoutSession>(_onStartSession);
    on<AddExercise>(_onAddExercise);
    on<LogSet>(_onLogSet);
    on<UpdateSet>(_onUpdateSet);
    on<RemoveSet>(_onRemoveSet);
    on<RemoveExercise>(_onRemoveExercise);
    on<FinishWorkoutSession>(_onFinishSession);
    on<LoadWorkoutHistory>(_onLoadHistory);
    on<LoadPersonalRecords>(_onLoadPersonalRecords);
  }

  void _onStartSession(StartWorkoutSession event, Emitter<WorkoutState> emit) {
    emit(
      WorkoutSessionActive(
        sessionId: uuid.v4(),
        sessionDate: DateTime.now(),
        exercises: const [],
      ),
    );
  }

  void _onAddExercise(AddExercise event, Emitter<WorkoutState> emit) {
    final current = state;
    if (current is! WorkoutSessionActive) return;

    final updated = current.copyWith(
      exercises: [
        ...current.exercises,
        Exercise(id: uuid.v4(), name: event.exerciseName, sets: const []),
      ],
    );
    emit(updated);
  }

  void _onLogSet(LogSet event, Emitter<WorkoutState> emit) {
    final current = state;
    if (current is! WorkoutSessionActive) return;

    final exercises = current.exercises.map((ex) {
      if (ex.id != event.exerciseId) return ex;
      return ex.copyWith(sets: [...ex.sets, event.set]);
    }).toList();

    emit(current.copyWith(exercises: exercises));
  }

  void _onUpdateSet(UpdateSet event, Emitter<WorkoutState> emit) {
    final current = state;
    if (current is! WorkoutSessionActive) return;

    final exercises = current.exercises.map((ex) {
      if (ex.id != event.exerciseId) return ex;
      final updatedSets = ex.sets.map((set) {
        if (set.id != event.setId) return set;
        return set.copyWith(weightKg: event.weightKg, reps: event.reps);
      }).toList();
      return ex.copyWith(sets: updatedSets);
    }).toList();

    emit(current.copyWith(exercises: exercises));
  }

  void _onRemoveSet(RemoveSet event, Emitter<WorkoutState> emit) {
    final current = state;
    if (current is! WorkoutSessionActive) return;

    final exercises = current.exercises.map((ex) {
      if (ex.id != event.exerciseId) return ex;
      final updatedSets = ex.sets.where((s) => s.id != event.setId).toList();
      return ex.copyWith(sets: updatedSets);
    }).toList();

    emit(current.copyWith(exercises: exercises));
  }

  void _onRemoveExercise(RemoveExercise event, Emitter<WorkoutState> emit) {
    final current = state;
    if (current is! WorkoutSessionActive) return;

    final exercises = current.exercises
        .where((e) => e.id != event.exerciseId)
        .toList();
    emit(current.copyWith(exercises: exercises));
  }

  Future<void> _onFinishSession(
    FinishWorkoutSession event,
    Emitter<WorkoutState> emit,
  ) async {
    final current = state;
    if (current is! WorkoutSessionActive) return;

    emit(const WorkoutLoading());

    final session = WorkoutSession(
      id: current.sessionId,
      date: current.sessionDate,
      exercises: current.exercises,
    );

    final result = await saveWorkoutSession(
      SaveWorkoutParams(session: session),
    );

    result.fold(
      (failure) => emit(WorkoutError(message: failure.message)),
      (_) => emit(const WorkoutSessionSaved()),
    );
  }

  Future<void> _onLoadHistory(
    LoadWorkoutHistory event,
    Emitter<WorkoutState> emit,
  ) async {
    emit(const WorkoutLoading());
    final result = await getWorkoutHistory(NoParams());
    result.fold(
      (failure) => emit(WorkoutError(message: failure.message)),
      (sessions) => emit(WorkoutHistoryLoaded(sessions: sessions)),
    );
  }

  Future<void> _onLoadPersonalRecords(
    LoadPersonalRecords event,
    Emitter<WorkoutState> emit,
  ) async {
    emit(const WorkoutLoading());
    final result = await getPersonalRecords(NoParams());
    result.fold(
      (failure) => emit(WorkoutError(message: failure.message)),
      (records) => emit(PersonalRecordsLoaded(records: records)),
    );
  }
}
