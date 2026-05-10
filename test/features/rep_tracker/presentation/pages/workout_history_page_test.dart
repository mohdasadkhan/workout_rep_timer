import 'package:app_lifecycle/features/rep_tracker/domain/entities/personal_record.dart';
import 'package:app_lifecycle/features/rep_tracker/domain/entities/workout_session.dart';
import 'package:app_lifecycle/features/rep_tracker/domain/repositories/workout_repository.dart';
import 'package:app_lifecycle/features/rep_tracker/domain/usecases/delete_workout_session.dart';
import 'package:app_lifecycle/features/rep_tracker/domain/usecases/get_personal_records.dart';
import 'package:app_lifecycle/features/rep_tracker/domain/usecases/get_workout_history.dart';
import 'package:app_lifecycle/features/rep_tracker/domain/usecases/save_workout_session.dart';
import 'package:app_lifecycle/features/rep_tracker/presentation/bloc/personal_records_bloc/personal_records_bloc.dart';
import 'package:app_lifecycle/features/rep_tracker/presentation/bloc/workout_history_bloc/workout_history_bloc.dart';
import 'package:app_lifecycle/features/rep_tracker/presentation/pages/workout_history_page.dart';
import 'package:app_lifecycle/core/failure/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeWorkoutRepository implements WorkoutRepository {
  List<WorkoutSession> history = [];
  List<PersonalRecord> prs = [];
  @override
  Future<Either<Failure, Unit>> clearActiveSession() async => const Right(unit);
  @override
  Future<Either<Failure, Unit>> deleteWorkoutSession(String sessionId) async =>
      const Right(unit);
  @override
  Future<Either<Failure, List<PersonalRecord>>> getPersonalRecords() async =>
      Right(prs);
  @override
  Future<Either<Failure, List<WorkoutSession>>> getWorkoutHistory() async =>
      Right(history);
  @override
  Future<Option<WorkoutSession>> loadActiveSession() async => none();
  @override
  Future<Either<Failure, Unit>> saveActiveSession(
    WorkoutSession session,
  ) async => const Right(unit);
  @override
  Future<Either<Failure, Unit>> saveWorkoutSession(
    WorkoutSession session,
  ) async => const Right(unit);
}

void main() {
  late WorkoutHistoryBloc historyBloc;
  late PersonalRecordsBloc recordsBloc;
  late FakeWorkoutRepository repo;

  setUp(() {
    repo = FakeWorkoutRepository();

    historyBloc = WorkoutHistoryBloc(
      getWorkoutHistory: GetWorkoutHistory(repo),
      deleteWorkoutSession: DeleteWorkoutSessionUsecase(repo),
      saveWorkoutSession: SaveWorkoutSession(repo),
    );
    recordsBloc = PersonalRecordsBloc(
      getPersonalRecords: GetPersonalRecords(repo),
    );
  });

  testWidgets('renders history tab scaffold', (tester) async {
    final session = WorkoutSession(
      id: 's1',
      date: DateTime(2026),
      exercises: const [],
    );
    repo.history = [session];

    await tester.pumpWidget(
      MaterialApp(
        home: MultiBlocProvider(
          providers: [
            BlocProvider<WorkoutHistoryBloc>.value(value: historyBloc),
            BlocProvider<PersonalRecordsBloc>.value(value: recordsBloc),
          ],
          child: const WorkoutHistoryPage(),
        ),
      ),
    );
    await tester.pump();
    expect(find.text('History & PRs'), findsOneWidget);
  });

}
