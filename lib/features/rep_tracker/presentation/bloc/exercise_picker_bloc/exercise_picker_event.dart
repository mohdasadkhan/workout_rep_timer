// exercise_picker_event.dart
part of 'exercise_picker_bloc.dart';

abstract class ExercisePickerEvent {}

class CategorySelected extends ExercisePickerEvent {
  final String category;
  CategorySelected(this.category);
}

class SearchQueryChanged extends ExercisePickerEvent {
  final String query;
  SearchQueryChanged(this.query);
}

class CustomExerciseSubmitted extends ExercisePickerEvent {
  final String name;
  CustomExerciseSubmitted(this.name);
}

class ChipLongPressed extends ExercisePickerEvent {
  final String name;
  ChipLongPressed(this.name);
}

class ChipSelectionToggled extends ExercisePickerEvent {
  final String name;
  ChipSelectionToggled(this.name);
}

class SelectionCancelled extends ExercisePickerEvent {}

class DeleteSelectedConfirmed extends ExercisePickerEvent {}


// exercise_picker_event.dart — add
class ArsenalEditModeToggled extends ExercisePickerEvent {}
