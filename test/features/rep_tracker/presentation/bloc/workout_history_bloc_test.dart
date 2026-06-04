import 'package:app_lifecycle/core/failure/failure.dart';
import 'package:app_lifecycle/features/rep_tracker/domain/entities/personal_record.dart';
import 'package:app_lifecycle/features/rep_tracker/domain/entities/workout_session.dart';
import 'package:app_lifecycle/features/rep_tracker/domain/repositories/workout_repository.dart';
import 'package:app_lifecycle/features/rep_tracker/domain/usecases/delete_workout_session.dart';
import 'package:app_lifecycle/features/rep_tracker/domain/usecases/get_workout_history.dart';
import 'package:app_lifecycle/features/rep_tracker/domain/usecases/save_workout_session.dart';
import 'package:app_lifecycle/features/rep_tracker/presentation/bloc/workout_history_bloc/workout_history_bloc.dart';
import 'package:app_lifecycle/features/rep_tracker/presentation/bloc/workout_history_bloc/workout_history_event.dart';
import 'package:app_lifecycle/features/rep_tracker/presentation/bloc/workout_history_bloc/workout_history_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeWorkoutRepository implements WorkoutRepository {
  Either<Failure, List<WorkoutSession>> historyResult = const Right([]);
  @override
  Future<Either<Failure, List<WorkoutSession>>> getWorkoutHistory() async => historyResult;
  @override
  Future<Either<Failure, Unit>> deleteWorkoutSession(String sessionId) async => const Right(unit);
  @override
  Future<Either<Failure, Unit>> saveWorkoutSession(WorkoutSession session) async => const Right(unit);
  @override
  Future<Either<Failure, Unit>> clearActiveSession() async => const Right(unit);
  @override
  Future<Either<Failure, List<PersonalRecord>>> getPersonalRecords() async => const Right([]);
  @override
  Future<Option<WorkoutSession>> loadActiveSession() async => none();
  @override
  Future<Either<Failure, Unit>> saveActiveSession(WorkoutSession session) async => const Right(unit);
}

void main() {
  blocTest<WorkoutHistoryBloc, WorkoutHistoryState>(
    'LoadWorkoutHistory emits loaded',
    build: () {
      final repo = FakeWorkoutRepository()
        ..historyResult = Right([
          WorkoutSession(id: 's1', date: DateTime(2026), exercises: const []),
        ]);
      return WorkoutHistoryBloc(
        getWorkoutHistory: GetWorkoutHistory(repo),
        deleteWorkoutSession: DeleteWorkoutSessionUsecase(repo),
        saveWorkoutSession: SaveWorkoutSession(repo),
      );
    },
    act: (bloc) => bloc.add(const LoadWorkoutHistory()),
    expect: () => [const WorkoutHistoryLoading(), isA<WorkoutHistoryLoaded>()],
  );

  blocTest<WorkoutHistoryBloc, WorkoutHistoryState>(
    'LoadWorkoutHistory emits error',
    build: () {
      final repo = FakeWorkoutRepository()
        ..historyResult = const Left(Failure(message: 'history error'));
      return WorkoutHistoryBloc(
        getWorkoutHistory: GetWorkoutHistory(repo),
        deleteWorkoutSession: DeleteWorkoutSessionUsecase(repo),
        saveWorkoutSession: SaveWorkoutSession(repo),
      );
    },
    act: (bloc) => bloc.add(const LoadWorkoutHistory()),
    expect: () => [
      const WorkoutHistoryLoading(),
      const WorkoutHistoryError(message: 'history error'),
    ],
  );
}
