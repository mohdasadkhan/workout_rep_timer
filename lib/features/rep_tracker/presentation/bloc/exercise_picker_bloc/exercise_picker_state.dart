// exercise_picker_state.dart
part of 'exercise_picker_bloc.dart';

class ExercisePickerState {
  final String selectedCategory;
  final String query;
  final List<String> customForCategory;   // all custom names for current category view
  final List<String> visiblePresets;      // filtered preset-only results
  final List<String> visibleCustom;       // filtered custom-only results
  final bool isSelectionMode;
  final Set<String> selectedForDeletion;

  const ExercisePickerState({
    required this.selectedCategory,
    required this.query,
    required this.customForCategory,
    required this.visiblePresets,
    required this.visibleCustom,
    required this.isSelectionMode,
    required this.selectedForDeletion,
  });

  const ExercisePickerState.initial()
      : selectedCategory = 'All',
        query = '',
        customForCategory = const [],
        visiblePresets = const [],
        visibleCustom = const [],
        isSelectionMode = false,
        selectedForDeletion = const {};

  bool isCustom(String name) =>
      customForCategory.any((e) => e.toLowerCase() == name.toLowerCase());

  ExercisePickerState copyWith({
    String? selectedCategory,
    String? query,
    List<String>? customForCategory,
    List<String>? visiblePresets,
    List<String>? visibleCustom,
    bool? isSelectionMode,
    Set<String>? selectedForDeletion,
  }) {
    return ExercisePickerState(
      selectedCategory: selectedCategory ?? this.selectedCategory,
      query: query ?? this.query,
      customForCategory: customForCategory ?? this.customForCategory,
      visiblePresets: visiblePresets ?? this.visiblePresets,
      visibleCustom: visibleCustom ?? this.visibleCustom,
      isSelectionMode: isSelectionMode ?? this.isSelectionMode,
      selectedForDeletion: selectedForDeletion ?? this.selectedForDeletion,
    );
  }
}