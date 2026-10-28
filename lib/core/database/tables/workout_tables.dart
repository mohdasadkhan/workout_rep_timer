import 'package:drift/drift.dart';

class WorkoutSessions extends Table {
  TextColumn get id => text()();
  DateTimeColumn get date => dateTime()();
  TextColumn get notes => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class WorkoutExercises extends Table {
  TextColumn get id => text()();
  TextColumn get sessionId =>
      text().references(WorkoutSessions, #id, onDelete: KeyAction.cascade)();
  TextColumn get name => text()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class WorkoutSetRows extends Table {
  TextColumn get id => text()();
  TextColumn get exerciseId =>
      text().references(WorkoutExercises, #id, onDelete: KeyAction.cascade)();
  RealColumn get weightKg => real()();
  IntColumn get reps => integer()();
  DateTimeColumn get performedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
