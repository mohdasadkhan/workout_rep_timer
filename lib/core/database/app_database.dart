import 'package:drift/drift.dart';

import 'database_connection.dart';
import 'tables/workout_tables.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [WorkoutSessions, WorkoutExercises, WorkoutSetRows])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
    : super(executor ?? openDatabaseConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      beforeOpen: (details) async {
        await customStatement('PRAGMA foreign_keys = ON');
      },
    );
  }

  Future<void> clearAllWorkoutData() async {
    await transaction(() async {
      await delete(workoutSetRows).go();
      await delete(workoutExercises).go();
      await delete(workoutSessions).go();
    });
  }
}
