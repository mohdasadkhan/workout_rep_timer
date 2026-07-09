// exercise_picker_bloc.dart
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fitflow/core/constants/pref_keys.dart';
import 'package:fitflow/features/rep_tracker/domain/usecases/get_exercises_for_category_usecase.dart';
import 'package:fitflow/features/rep_tracker/domain/usecases/save_custom_exercise_usecase.dart';
import 'package:fitflow/features/rep_tracker/domain/usecases/delete_custom_exercise_usecase.dart';

part 'exercise_picker_event.dart';
part 'exercise_picker_state.dart';

const _presets = {
  'Push': [
    'Bench Press',
    'Incline Bench Press',
    'Overhead Press',
    'Dumbbell Shoulder Press',
    'Tricep Pushdown',
    'Chest Fly',
    'Cable Fly',
    'Lateral Raise',
  ],
  'Pull': [
    'Pull-up',
    'Barbell Row',
    'Lat Pulldown',
    'Seated Row',
    'Face Pull',
    'Bicep Curl',
    'Hammer Curl',
    'Deadlift',
  ],
  'Legs': [
    'Squat',
    'Leg Press',
    'Romanian Deadlift',
    'Leg Curl',
    'Leg Extension',
    'Calf Raise',
    'Lunges',
  ],
  'Core': [
    'Plank',
    'Russian Twist',
    'Hanging Leg Raise',
    'Ab Wheel',
    'Hip Thrust',
  ],
};

class ExercisePickerBloc
    extends Bloc<ExercisePickerEvent, ExercisePickerState> {
  final GetExercisesForCategoryUseCase getExercises;
  final SaveCustomExerciseUseCase saveExercise;
  final DeleteCustomExerciseUseCase deleteExercise;
  final SharedPreferences prefs;

  ExercisePickerBloc({
    required this.getExercises,
    required this.saveExercise,
    required this.deleteExercise,
    required this.prefs,
  }) : super(const ExercisePickerState.initial()) {
    on<CategorySelected>(_onCategorySelected);
    on<SearchQueryChanged>(_onSearchChanged);
    on<CustomExerciseSubmitted>(_onCustomSubmitted);
    on<ChipLongPressed>(_onChipLongPressed);
    on<ChipSelectionToggled>(_onChipToggled);
    on<SelectionCancelled>(_onSelectionCancelled);
    on<DeleteSelectedConfirmed>(_onDeleteConfirmed);
    on<ArsenalEditModeToggled>(_onEditModeToggled);
  }

  List<String> _presetsFor(String category) => category == 'All'
      ? _presets.values.expand((e) => e).toSet().toList()
      : List<String>.from(_presets[category] ?? []);

  ({List<String> presets, List<String> custom}) _filtered(
    String category,
    List<String> custom,
    String query,
  ) {
    final presets = _presetsFor(category);
    if (query.isEmpty) return (presets: presets, custom: custom);
    final q = query.toLowerCase();
    return (
      presets: presets.where((n) => n.toLowerCase().contains(q)).toList(),
      custom: custom.where((n) => n.toLowerCase().contains(q)).toList(),
    );
  }

  Future<void> _onCategorySelected(
    CategorySelected event,
    Emitter<ExercisePickerState> emit,
  ) async {
    emit(state.copyWith(selectedCategory: event.category, query: ''));
    prefs
        .setString(PrefKeys.lastExerciseCategory, event.category)
        .catchError((_) {});

    final result = await getExercises(GetExercisesParams(event.category));
    result.fold(
      (failure) {
        final f = _filtered(event.category, const [], '');
        emit(
          state.copyWith(
            customForCategory: const [],
            visiblePresets: f.presets,
            visibleCustom: f.custom,
          ),
        );
      },
      (custom) {
        final f = _filtered(event.category, custom, '');
        emit(
          state.copyWith(
            customForCategory: custom,
            visiblePresets: f.presets,
            visibleCustom: f.custom,
          ),
        );
      },
    );
  }

  void _onSearchChanged(
    SearchQueryChanged event,
    Emitter<ExercisePickerState> emit,
  ) {
    final f = _filtered(
      state.selectedCategory,
      state.customForCategory,
      event.query,
    );
    emit(
      state.copyWith(
        query: event.query,
        visiblePresets: f.presets,
        visibleCustom: f.custom,
      ),
    );
  }

  Future<void> _onCustomSubmitted(
    CustomExerciseSubmitted event,
    Emitter<ExercisePickerState> emit,
  ) async {
    await saveExercise(SaveExerciseParams(state.selectedCategory, event.name));

    // Reflect immediately so the badge/section shows without waiting on a refetch
    final updatedCustom = [...state.customForCategory, event.name];
    final f = _filtered(state.selectedCategory, updatedCustom, state.query);
    emit(
      state.copyWith(
        customForCategory: updatedCustom,
        visiblePresets: f.presets,
        visibleCustom: f.custom,
      ),
    );
  }

  void _onChipLongPressed(
    ChipLongPressed event,
    Emitter<ExercisePickerState> emit,
  ) {
    if (!state.isCustom(event.name)) return; // presets are not editable
    HapticFeedback.mediumImpact();
    emit(
      state.copyWith(isSelectionMode: true, selectedForDeletion: {event.name}),
    );
  }

  void _onChipToggled(
    ChipSelectionToggled event,
    Emitter<ExercisePickerState> emit,
  ) {
    if (!state.isCustom(event.name)) return;
    final updated = Set<String>.from(state.selectedForDeletion);
    updated.contains(event.name)
        ? updated.remove(event.name)
        : updated.add(event.name);
    HapticFeedback.selectionClick();
    emit(
      state.copyWith(
        selectedForDeletion: updated,
        isSelectionMode: updated.isNotEmpty,
      ),
    );
  }

  void _onSelectionCancelled(
    SelectionCancelled event,
    Emitter<ExercisePickerState> emit,
  ) {
    emit(state.copyWith(isSelectionMode: false, selectedForDeletion: {}));
  }

  Future<void> _onDeleteConfirmed(
    DeleteSelectedConfirmed event,
    Emitter<ExercisePickerState> emit,
  ) async {
    final toDelete = state.selectedForDeletion.toList();
    final remainingCustom = state.customForCategory
        .where((e) => !toDelete.contains(e))
        .toList();
    final f = _filtered(state.selectedCategory, remainingCustom, state.query);

    // Optimistic: UI updates instantly, disk catches up after
    emit(
      state.copyWith(
        customForCategory: remainingCustom,
        visiblePresets: f.presets,
        visibleCustom: f.custom,
        isSelectionMode: false,
        selectedForDeletion: {},
      ),
    );

    for (final name in toDelete) {
      await deleteExercise(name);
    }
  }


  void _onEditModeToggled(
    ArsenalEditModeToggled event,
    Emitter<ExercisePickerState> emit,
  ) {
    HapticFeedback.lightImpact();
    final turningOn = !state.isSelectionMode;
    emit(
      state.copyWith(
        isSelectionMode: turningOn,
        selectedForDeletion: turningOn ? state.selectedForDeletion : {},
      ),
    );
  }
}
