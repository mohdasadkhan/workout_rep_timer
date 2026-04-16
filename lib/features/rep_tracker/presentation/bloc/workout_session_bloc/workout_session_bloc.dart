import 'dart:developer';

import 'package:app_lifecycle/features/rep_tracker/domain/repositories/workout_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../../domain/entities/exercise.dart';
import '../../../domain/entities/workout_session.dart';
import '../../../domain/usecases/save_workout_session.dart';
import 'workout_session_event.dart';
import 'workout_session_state.dart';

class WorkoutSessionBloc
    extends Bloc<WorkoutSessionEvent, WorkoutSessionState> {
  final SaveWorkoutSession saveWorkoutSession;
  final WorkoutRepository workoutRepository;
  final Uuid uuid;

  WorkoutSessionBloc({
    required this.saveWorkoutSession,
    required this.workoutRepository,
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
    on<LoadActiveSession>(_onLoadActiveSession); // ← new
    on<DiscardSession>(_onDiscardSession); // ← new
  }

  Future<void> _onStartSession(
    StartWorkoutSession event,
    Emitter<WorkoutSessionState> emit,
  ) async {
    emit(
      WorkoutSessionActive(
        sessionId: uuid.v4(),
        sessionDate: DateTime.now(),
        exercises: const [],
      ),
    );
    await _persistActiveSession();
  }

  Future<void> _onAddExercise(
    AddExercise event,
    Emitter<WorkoutSessionState> emit,
  ) async {
    final current = state;
    if (current is! WorkoutSessionActive) return;

    final updated = current.copyWith(
      exercises: [
        ...current.exercises,
        Exercise(id: uuid.v4(), name: event.exerciseName, sets: const []),
      ],
    );
    emit(updated);
    await _persistActiveSession();
  }

  Future<void> _onLogSet(
    LogSet event,
    Emitter<WorkoutSessionState> emit,
  ) async {
    final current = state;
    if (current is! WorkoutSessionActive) return;

    final exercises = current.exercises.map((ex) {
      if (ex.id != event.exerciseId) return ex;
      return ex.copyWith(sets: [...ex.sets, event.set]);
    }).toList();

    emit(current.copyWith(exercises: exercises));
    await _persistActiveSession();
  }

  Future<void> _onUpdateSet(
    UpdateSet event,
    Emitter<WorkoutSessionState> emit,
  ) async {
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
    await _persistActiveSession();
  }

  Future<void> _onRemoveSet(
    RemoveSet event,
    Emitter<WorkoutSessionState> emit,
  ) async {
    final current = state;
    if (current is! WorkoutSessionActive) return;

    final exercises = current.exercises.map((ex) {
      if (ex.id != event.exerciseId) return ex;
      final updatedSets = ex.sets.where((s) => s.id != event.setId).toList();
      return ex.copyWith(sets: updatedSets);
    }).toList();

    emit(current.copyWith(exercises: exercises));
    await _persistActiveSession();
  }

  Future<void> _onRemoveExercise(
    RemoveExercise event,
    Emitter<WorkoutSessionState> emit,
  ) async {
    final current = state;
    if (current is! WorkoutSessionActive) return;

    final exercises = current.exercises
        .where((e) => e.id != event.exerciseId)
        .toList();
    emit(current.copyWith(exercises: exercises));
    await _persistActiveSession();
  }

  Future<void> _onFinishSession(
    FinishWorkoutSession event,
    Emitter<WorkoutSessionState> emit,
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
      (failure) => emit(WorkoutSessionError(message: failure.message)),
      (_) => emit(const WorkoutSessionSaved()),
    );
    await _persistActiveSession();
  }

  // NEW: Hydration on app start / navigation return
  Future<void> _onLoadActiveSession(
    LoadActiveSession event,
    Emitter<WorkoutSessionState> emit,
  ) async {
    final active = await workoutRepository.loadActiveSession();
    log('inside load Active session active data >> $active');
    active.fold(
      () => emit(WorkoutInitial()),
      (session) => emit(
        WorkoutSessionActive(
          sessionId: session.id,
          sessionDate: session.date,
          exercises: session.exercises,
        ),
      ),
    );
  }

  Future<void> _onDiscardSession(
    DiscardSession event,
    Emitter<WorkoutSessionState> emit,
  ) async {
    await workoutRepository.clearActiveSession();
    emit(const WorkoutInitial());
  }

  // Helper — called after every mutation
  Future<void> _persistActiveSession() async {
    final current = state;
    if (current is! WorkoutSessionActive) return;

    final session = WorkoutSession(
      id: current.sessionId,
      date: current.sessionDate,
      exercises: current.exercises,
    );
    await workoutRepository.saveActiveSession(session);
  }
}
