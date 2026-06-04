import 'package:app_lifecycle/features/rep_tracker/domain/repositories/workout_repository.dart';
import 'package:app_lifecycle/features/rep_tracker/domain/usecases/save_workout_session.dart';
import 'package:app_lifecycle/features/rep_tracker/presentation/bloc/workout_session_bloc/workout_session_bloc.dart';
import 'package:app_lifecycle/features/rep_tracker/presentation/bloc/workout_session_bloc/workout_session_event.dart';
import 'package:app_lifecycle/features/rep_tracker/presentation/pages/workout_session_page.dart';
import 'package:app_lifecycle/core/failure/failure.dart';
import 'package:app_lifecycle/features/rep_tracker/domain/entities/personal_record.dart';
import 'package:app_lifecycle/features/rep_tracker/domain/entities/workout_session.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeWorkoutRepository implements WorkoutRepository {
  WorkoutSession? active;
  @override
  Future<Either<Failure, Unit>> clearActiveSession() async => const Right(unit);
  @override
  Future<Either<Failure, Unit>> deleteWorkoutSession(String sessionId) async =>
      const Right(unit);
  @override
  Future<Either<Failure, List<PersonalRecord>>> getPersonalRecords() async =>
      const Right([]);
  @override
  Future<Either<Failure, List<WorkoutSession>>> getWorkoutHistory() async =>
      const Right([]);
  @override
  Future<Option<WorkoutSession>> loadActiveSession() async => optionOf(active);
  @override
  Future<Either<Failure, Unit>> saveActiveSession(WorkoutSession session) async {
    active = session;
    return const Right(unit);
  }
  @override
  Future<Either<Failure, Unit>> saveWorkoutSession(WorkoutSession session) async =>
      const Right(unit);
}

void main() {
  late WorkoutSessionBloc bloc;
  late FakeWorkoutRepository repo;

  setUp(() {
    repo = FakeWorkoutRepository();
    bloc = WorkoutSessionBloc(
      saveWorkoutSession: SaveWorkoutSession(repo),
      workoutRepository: repo,
    );
  });

  testWidgets('shows start prompt for initial state', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<WorkoutSessionBloc>.value(
          value: bloc,
          child: const WorkoutSessionPage(),
        ),
      ),
    );
    expect(find.textContaining('Start'), findsWidgets);
  });

  testWidgets('shows Add Exercise button after starting session', (tester) async {
    bloc.add(const StartWorkoutSession());
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<WorkoutSessionBloc>.value(
          value: bloc,
          child: const WorkoutSessionPage(),
        ),
      ),
    );
    await tester.pump();
    expect(find.text('Add Exercise'), findsOneWidget);
  });
}
