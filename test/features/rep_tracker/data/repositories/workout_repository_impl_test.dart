import 'package:app_lifecycle/core/failure/cache_exceptions.dart';
import 'package:app_lifecycle/features/rep_tracker/data/datasources/workout_local_datasource.dart';
import 'package:app_lifecycle/features/rep_tracker/data/models/workout_session_model.dart';
import 'package:app_lifecycle/features/rep_tracker/data/repositories/workout_repository_impl.dart';
import 'package:app_lifecycle/features/rep_tracker/domain/entities/workout_session.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeWorkoutLocalDatasource implements WorkoutLocalDatasource {
  bool throwOnSave = false;
  WorkoutSessionModel? active;

  @override
  Future<void> saveWorkoutSession(WorkoutSessionModel session) async {
    if (throwOnSave) throw const CacheException(message: 'cache error');
  }

  @override
  Future<void> clearActiveSession() async {}

  @override
  Future<void> deleteWorkoutSession(String sessionId) async {}

  @override
  Future<List<WorkoutSessionModel>> getWorkoutHistory() async => [];

  @override
  Future<WorkoutSessionModel?> loadActiveSession() async => active;

  @override
  Future<void> saveActiveSession(WorkoutSessionModel session) async {
    active = session;
  }
}

void main() {
  late FakeWorkoutLocalDatasource datasource;
  late WorkoutRepositoryImpl repository;
  final session = WorkoutSession(id: 'id-1', date: DateTime(2026), exercises: const []);

  setUp(() {
    datasource = FakeWorkoutLocalDatasource();
    repository = WorkoutRepositoryImpl(localDatasource: datasource);
  });

  test('saveWorkoutSession returns Right on success', () async {
    final result = await repository.saveWorkoutSession(session);
    expect(result, const Right(unit));
  });

  test('saveWorkoutSession returns Left on cache exception', () async {
    datasource.throwOnSave = true;
    final result = await repository.saveWorkoutSession(session);
    expect(result.isLeft(), isTrue);
  });

  test('loadActiveSession returns none when no active session', () async {
    final result = await repository.loadActiveSession();
    expect(result.isNone(), isTrue);
  });
}
