import 'package:app_lifecycle/core/failure/failure.dart';
import 'package:app_lifecycle/features/rep_tracker/domain/entities/personal_record.dart';
import 'package:app_lifecycle/features/rep_tracker/domain/entities/workout_session.dart';
import 'package:app_lifecycle/features/rep_tracker/domain/repositories/workout_repository.dart';
import 'package:app_lifecycle/features/rep_tracker/domain/usecases/get_personal_records.dart';
import 'package:app_lifecycle/features/rep_tracker/presentation/bloc/personal_records_bloc/personal_records_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeWorkoutRepository implements WorkoutRepository {
  Either<Failure, List<PersonalRecord>> prsResult = const Right([]);
  @override
  Future<Either<Failure, List<PersonalRecord>>> getPersonalRecords() async => prsResult;
  @override
  Future<Either<Failure, Unit>> clearActiveSession() async => const Right(unit);
  @override
  Future<Either<Failure, Unit>> deleteWorkoutSession(String sessionId) async => const Right(unit);
  @override
  Future<Either<Failure, List<WorkoutSession>>> getWorkoutHistory() async => const Right([]);
  @override
  Future<Option<WorkoutSession>> loadActiveSession() async => none();
  @override
  Future<Either<Failure, Unit>> saveActiveSession(WorkoutSession session) async => const Right(unit);
  @override
  Future<Either<Failure, Unit>> saveWorkoutSession(WorkoutSession session) async => const Right(unit);
}

void main() {
  blocTest<PersonalRecordsBloc, PersonalRecordsState>(
    'LoadPersonalRecords emits loaded',
    build: () {
      final repo = FakeWorkoutRepository()
        ..prsResult = Right([
          PersonalRecord(
            exerciseName: 'Deadlift',
            bestWeightKg: 140,
            repsAtBestWeight: 3,
            achievedAt: DateTime(2026),
          ),
        ]);
      return PersonalRecordsBloc(getPersonalRecords: GetPersonalRecords(repo));
    },
    act: (bloc) => bloc.add(const LoadPersonalRecords()),
    expect: () => [const PersonalRecordLoading(), isA<PersonalRecordsLoaded>()],
  );

  blocTest<PersonalRecordsBloc, PersonalRecordsState>(
    'LoadPersonalRecords emits error',
    build: () {
      final repo = FakeWorkoutRepository()
        ..prsResult = const Left(Failure(message: 'pr error'));
      return PersonalRecordsBloc(getPersonalRecords: GetPersonalRecords(repo));
    },
    act: (bloc) => bloc.add(const LoadPersonalRecords()),
    expect: () => [
      const PersonalRecordLoading(),
      const PersonalRecordLoadingError(message: 'pr error'),
    ],
  );
}
// import 'package:app_lifecycle/core/failure/failure.dart';
// import 'package:app_lifecycle/features/rep_tracker/domain/entities/personal_record.dart';
// import 'package:app_lifecycle/features/rep_tracker/domain/usecases/get_personal_records.dart';
// import 'package:app_lifecycle/features/rep_tracker/presentation/bloc/personal_records_bloc/personal_records_bloc.dart';
// import 'package:bloc_test/bloc_test.dart';
// import 'package:dartz/dartz.dart';
// import 'package:flutter_test/flutter_test.dart';
// class FakeGetPersonalRecords extends GetPersonalRecords {
//   final Either<Failure, List<PersonalRecord>> result;
//   FakeGetPersonalRecords(this.result) : super(_FakeRepository());
//   @override
//   Future<Either<Failure, List<PersonalRecord>>> call(params) async => result;
// }

// class _FakeRepository implements dynamic {}

// void main() {
//   blocTest<PersonalRecordsBloc, PersonalRecordsState>(
//     'LoadPersonalRecords emits loaded',
//     build: () => PersonalRecordsBloc(
//       getPersonalRecords: FakeGetPersonalRecords(
//         Right([
//           PersonalRecord(
//             exerciseName: 'Deadlift',
//             bestWeightKg: 140,
//             repsAtBestWeight: 3,
//             achievedAt: DateTime(2026),
//           ),
//         ]),
//       ),
//     ),
//     act: (bloc) => bloc.add(const LoadPersonalRecords()),
//     expect: () => [const PersonalRecordLoading(), isA<PersonalRecordsLoaded>()],
//   );

//   blocTest<PersonalRecordsBloc, PersonalRecordsState>(
//     'LoadPersonalRecords emits error',
//     build: () => PersonalRecordsBloc(
//       getPersonalRecords: FakeGetPersonalRecords(
//         const Left(Failure(message: 'pr error')),
//       ),
//     ),
//     act: (bloc) => bloc.add(const LoadPersonalRecords()),
//     expect: () => [
//       const PersonalRecordLoading(),
//       const PersonalRecordLoadingError(message: 'pr error'),
//     ],
//   );
// }
