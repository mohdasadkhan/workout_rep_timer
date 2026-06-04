import 'package:app_lifecycle/core/failure/failure.dart';
import 'package:app_lifecycle/features/rep_tracker/domain/entities/personal_record.dart';
import 'package:app_lifecycle/features/rep_tracker/domain/entities/workout_session.dart';
import 'package:app_lifecycle/features/rep_tracker/domain/repositories/workout_repository.dart';
import 'package:app_lifecycle/features/rep_tracker/domain/usecases/save_workout_session.dart';
import 'package:app_lifecycle/features/rep_tracker/presentation/bloc/workout_session_bloc/workout_session_bloc.dart';
import 'package:app_lifecycle/features/rep_tracker/presentation/bloc/workout_session_bloc/workout_session_event.dart';
import 'package:app_lifecycle/features/rep_tracker/presentation/bloc/workout_session_bloc/workout_session_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
class FakeWorkoutRepository implements WorkoutRepository {
  bool saveShouldFail = false;
  WorkoutSession? active;
  final List<WorkoutSession> history = [];

  @override
  Future<Either<Failure, Unit>> clearActiveSession() async {
    active = null;
    return const Right(unit);
  }

  @override
  Future<Either<Failure, Unit>> deleteWorkoutSession(String sessionId) async {
    history.removeWhere((s) => s.id == sessionId);
    return const Right(unit);
  }

  @override
  Future<Either<Failure, List<PersonalRecord>>> getPersonalRecords() async =>
      const Right([]);

  @override
  Future<Either<Failure, List<WorkoutSession>>> getWorkoutHistory() async =>
      Right(history);

  @override
  Future<Option<WorkoutSession>> loadActiveSession() async => optionOf(active);

  @override
  Future<Either<Failure, Unit>> saveActiveSession(WorkoutSession session) async {
    active = session;
    return const Right(unit);
  }

  @override
  Future<Either<Failure, Unit>> saveWorkoutSession(WorkoutSession session) async {
    if (saveShouldFail) {
      return const Left(Failure(message: 'save failed'));
    }
    history.add(session);
    return const Right(unit);
  }
}

void main() {
  late FakeWorkoutRepository fakeRepository;
  late WorkoutSessionBloc bloc;

  setUp(() {
    fakeRepository = FakeWorkoutRepository();
    bloc = WorkoutSessionBloc(
      saveWorkoutSession: SaveWorkoutSession(fakeRepository),
      workoutRepository: fakeRepository,
    );
  });

  blocTest<WorkoutSessionBloc, WorkoutSessionState>(
    'StartWorkoutSession emits active session',
    build: () => bloc,
    act: (bloc) => bloc.add(const StartWorkoutSession()),
    expect: () => [isA<WorkoutSessionActive>()],
  );

  blocTest<WorkoutSessionBloc, WorkoutSessionState>(
    'AddExercise appends exercise to active session',
    build: () => bloc,
    act: (bloc) async {
      bloc.add(const StartWorkoutSession());
      await Future<void>.delayed(Duration.zero);
      bloc.add(const AddExercise(exerciseName: 'Squat'));
    },
    expect: () => [isA<WorkoutSessionActive>(), isA<WorkoutSessionActive>()],
  );

  blocTest<WorkoutSessionBloc, WorkoutSessionState>(
    'FinishWorkoutSession emits saved when usecase succeeds',
    build: () => bloc,
    act: (bloc) async {
      bloc.add(const StartWorkoutSession());
      await Future<void>.delayed(Duration.zero);
      bloc.add(const FinishWorkoutSession());
    },
    expect: () => [
      isA<WorkoutSessionActive>(),
      const WorkoutLoading(),
      const WorkoutSessionSaved(),
    ],
  );

  blocTest<WorkoutSessionBloc, WorkoutSessionState>(
    'FinishWorkoutSession emits error when usecase fails',
    build: () {
      fakeRepository.saveShouldFail = true;
      return bloc;
    },
    act: (bloc) async {
      bloc.add(const StartWorkoutSession());
      await Future<void>.delayed(Duration.zero);
      bloc.add(const FinishWorkoutSession());
    },
    expect: () => [
      isA<WorkoutSessionActive>(),
      const WorkoutLoading(),
      const WorkoutSessionError(message: 'save failed'),
    ],
  );
}
