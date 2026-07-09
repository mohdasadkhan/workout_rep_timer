import 'package:fitflow/core/constants/pref_keys.dart';
import 'package:fitflow/core/di/injection.dart';
import 'package:fitflow/core/theme/app_colors.dart';
import 'package:fitflow/core/theme/app_text_styles.dart';
import 'package:fitflow/core/theme/theme_extensions.dart';
import 'package:fitflow/features/rep_tracker/presentation/bloc/exercise_picker_bloc/exercise_picker_bloc.dart';
import 'package:fitflow/features/rep_tracker/presentation/bloc/workout_session_bloc/workout_session_bloc.dart';
import 'package:fitflow/features/rep_tracker/presentation/bloc/workout_session_bloc/workout_session_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AddExerciseBottomSheet extends StatelessWidget {
  final String initialCategory;
  const AddExerciseBottomSheet({super.key, this.initialCategory = 'All'});

  static Future<void> show(
    BuildContext context, {
    String initialCategory = 'All',
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) => BlocProvider(
        create: (_) =>
            getIt<ExercisePickerBloc>()..add(CategorySelected(initialCategory)),
        child: AddExerciseBottomSheet(initialCategory: initialCategory),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => const _AddExerciseContent();
}

class _AddExerciseContent extends StatefulWidget {
  const _AddExerciseContent();

  @override
  State<_AddExerciseContent> createState() => _AddExerciseContentState();
}

class _AddExerciseContentState extends State<_AddExerciseContent> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  final ScrollController _categoryScrollCtrl = ScrollController();
  final List<String> _categories = ['All', 'Push', 'Pull', 'Legs', 'Core'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final route = ModalRoute.of(context);
      route?.animation?.addStatusListener((status) {
        if (status == AnimationStatus.completed && mounted) {
          _searchFocusNode.requestFocus();
          _scrollToSelected();
        }
      });
    });
  }

  void _scrollToSelected() {
    if (!_categoryScrollCtrl.hasClients) return;
    final selected = context.read<ExercisePickerBloc>().state.selectedCategory;
    final index = _categories.indexOf(selected);
    if (index == -1) return;
    const itemWidth = 108.0;
    final target =
        (index * itemWidth) -
        (MediaQuery.of(context).size.width / 2) +
        (itemWidth / 2);
    _categoryScrollCtrl.animateTo(
      target.clamp(0.0, _categoryScrollCtrl.position.maxScrollExtent),
      duration: const Duration(milliseconds: 160),
      curve: Curves.easeOutCubic,
    );
  }

  void _addExercise(String name) {
    if (name.trim().isEmpty) return;
    final trimmed = name.trim();
    final picker = context.read<ExercisePickerBloc>();

    HapticFeedback.mediumImpact();
    context.read<WorkoutSessionBloc>().add(AddExercise(exerciseName: trimmed));

    final isKnown =
        picker.state.visiblePresets.contains(trimmed) ||
        picker.state.isCustom(trimmed);
    if (!isKnown) {
      picker.add(CustomExerciseSubmitted(trimmed));
    }
    context.pop();
  }

  @override
  void dispose() {
    _controller.dispose();
    _categoryScrollCtrl.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        20,
        12,
        20,
        MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: colorScheme.onSurface.withOpacity(0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Text('Add Exercise', style: textTheme.titleLarge),
          const SizedBox(height: 20),

          BlocBuilder<ExercisePickerBloc, ExercisePickerState>(
            buildWhen: (p, c) => p.query != c.query,
            builder: (context, state) {
              return TextField(
                controller: _controller,
                focusNode: _searchFocusNode,
                textInputAction: TextInputAction.done,
                style: textTheme.bodyLarge,
                decoration: InputDecoration(
                  hintText: 'Search or type new exercise',
                  hintStyle: TextStyle(
                    color: colorScheme.onSurface.withOpacity(0.4),
                    fontSize: 16,
                  ),
                  filled: true,
                  fillColor: colorScheme.surfaceContainerHighest,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(
                      color: AppColors.primary,
                      width: 1.8,
                    ),
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: colorScheme.onSurface.withOpacity(0.4),
                  ),
                  suffixIcon: _controller.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 20),
                          onPressed: () {
                            _controller.clear();
                            context.read<ExercisePickerBloc>().add(
                              SearchQueryChanged(''),
                            );
                          },
                        )
                      : null,
                ),
                onChanged: (v) => context.read<ExercisePickerBloc>().add(
                  SearchQueryChanged(v.trim()),
                ),
                onSubmitted: _addExercise,
              );
            },
          ),

          const SizedBox(height: 24),

          BlocBuilder<ExercisePickerBloc, ExercisePickerState>(
            buildWhen: (p, c) => p.selectedCategory != c.selectedCategory,
            builder: (context, state) {
              return SingleChildScrollView(
                controller: _categoryScrollCtrl,
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _categories.map((cat) {
                    final selected = state.selectedCategory == cat;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        checkmarkColor: AppColors.primary,
                        label: Text(
                          cat,
                          style: TextStyle(
                            fontSize: 14.5,
                            fontWeight: selected
                                ? FontWeight.w600
                                : FontWeight.w500,
                            color: selected
                                ? AppColors.primary
                                : colorScheme.onSurface,
                          ),
                        ),
                        selected: selected,
                        onSelected: (v) {
                          if (v) {
                            HapticFeedback.lightImpact();
                            context.read<ExercisePickerBloc>().add(
                              CategorySelected(cat),
                            );
                            _scrollToSelected();
                          }
                        },
                        backgroundColor: colorScheme.surfaceContainerHighest,
                        selectedColor: AppColors.primary.withOpacity(0.15),
                        side: BorderSide(
                          color: selected
                              ? AppColors.primary.withOpacity(0.6)
                              : colorScheme.outline.withOpacity(0.25),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        elevation: selected ? 1 : 0,
                      ),
                    );
                  }).toList(),
                ),
              );
            },
          ),

          const SizedBox(height: 28),

          BlocBuilder<ExercisePickerBloc, ExercisePickerState>(
            buildWhen: (p, c) =>
                p.visibleCustom != c.visibleCustom ||
                p.isSelectionMode != c.isSelectionMode ||
                p.selectedForDeletion != c.selectedForDeletion,
            builder: (context, state) {
              return AnimatedSize(
                duration: const Duration(milliseconds: 240),
                curve: Curves.easeOutCubic,
                alignment: Alignment.topCenter,
                child: state.visibleCustom.isEmpty
                    ? const SizedBox.shrink()
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _SectionHeader(
                            title: 'YOUR ARSENAL',
                            isSelectionMode: state.isSelectionMode,
                            selectedCount: state.selectedForDeletion.length,
                            onToggleEdit: () => context
                                .read<ExercisePickerBloc>()
                                .add(ArsenalEditModeToggled()),
                            onDelete: () => _confirmDelete(context, state),
                          ),
                          const SizedBox(height: 12),

                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 200),
                            transitionBuilder: (child, animation) =>
                                FadeTransition(
                                  opacity: animation,
                                  child: ScaleTransition(
                                    scale: Tween(
                                      begin: 0.94,
                                      end: 1.0,
                                    ).animate(animation),
                                    child: child,
                                  ),
                                ),
                            child: Wrap(
                              key: ValueKey(
                                'custom-${state.visibleCustom.join('|')}',
                              ),
                              spacing: 10,
                              runSpacing: 10,
                              children: state.visibleCustom
                                  .map(
                                    (name) => _buildChip(
                                      context,
                                      name,
                                      state,
                                      isCustomSection: true,
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
              );
            },
          ),

          Text(
            'QUICK PICK',
            style: AppTextStyles.labelSmall.copyWith(
              color: colorScheme.onSurface.withOpacity(0.45),
            ),
          ),
          const SizedBox(height: 12),

          BlocBuilder<ExercisePickerBloc, ExercisePickerState>(
            buildWhen: (p, c) =>
                p.visiblePresets != c.visiblePresets || p.query != c.query,
            builder: (context, state) {
              return AnimatedSize(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
                alignment: Alignment.topCenter,
                child:
                    state.visiblePresets.isEmpty &&
                        state.visibleCustom.isEmpty &&
                        state.query.isNotEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 40),
                          child: Text(
                            'No matching exercises\nType and tap Done to add custom',
                            textAlign: TextAlign.center,
                            style: textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurface.withOpacity(0.4),
                            ),
                          ),
                        ),
                      )
                    : AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        transitionBuilder: (child, animation) => FadeTransition(
                          opacity: animation,
                          child: ScaleTransition(
                            scale: Tween(
                              begin: 0.96,
                              end: 1.0,
                            ).animate(animation),
                            child: child,
                          ),
                        ),
                        child: Wrap(
                          key: ValueKey(
                            'preset-${state.visiblePresets.join('|')}',
                          ),
                          spacing: 10,
                          runSpacing: 10,
                          children: state.visiblePresets
                              .map(
                                (name) => _buildChip(
                                  context,
                                  name,
                                  state,
                                  isCustomSection: false,
                                ),
                              )
                              .toList(),
                        ),
                      ),
              );
            },
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, ExercisePickerState state) {
    HapticFeedback.mediumImpact();
    context.read<ExercisePickerBloc>().add(DeleteSelectedConfirmed());
  }

  Widget _buildChip(
    BuildContext context,
    String name,
    ExercisePickerState state, {
    required bool isCustomSection,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final appColors = Theme.of(context).extension<AppColorsExtension>()!;
    final isSelected = state.selectedForDeletion.contains(name);
    final canSelect = isCustomSection && state.isSelectionMode;

    return Material(
      type: MaterialType.transparency,
      borderRadius: BorderRadius.circular(22),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          if (canSelect) {
            context.read<ExercisePickerBloc>().add(ChipSelectionToggled(name));
          } else if (!state.isSelectionMode) {
            _addExercise(name);
          }
        },
        onLongPress: isCustomSection
            ? () =>
                  context.read<ExercisePickerBloc>().add(ChipLongPressed(name))
            : null,
        splashColor: canSelect
            ? AppColors.error.withOpacity(0.18)
            : colorScheme.primary.withOpacity(0.22),
        highlightColor: canSelect
            ? AppColors.error.withOpacity(0.08)
            : colorScheme.primary.withOpacity(0.1),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.error.withOpacity(0.12)
                : appColors.chipBackground,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: isSelected
                  ? AppColors.error.withOpacity(0.7)
                  : colorScheme.outline.withOpacity(0.15),
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 140),
                transitionBuilder: (child, anim) =>
                    ScaleTransition(scale: anim, child: child),
                child: isSelected
                    ? const Padding(
                        key: ValueKey('check'),
                        padding: EdgeInsets.only(right: 6),
                        child: Icon(
                          Icons.check_circle,
                          size: 16,
                          color: AppColors.error,
                        ),
                      )
                    : const SizedBox.shrink(key: ValueKey('nocheck')),
              ),
              Text(
                name,
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: isSelected ? AppColors.error : appColors.chipText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final bool isSelectionMode;
  final int selectedCount;
  final VoidCallback onToggleEdit;
  final VoidCallback onDelete;

  const _SectionHeader({
    required this.title,
    required this.isSelectionMode,
    required this.selectedCount,
    required this.onToggleEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 180),
      child: isSelectionMode
          ? Row(
              key: const ValueKey('selection'),
              children: [
                Text(
                  selectedCount == 0
                      ? 'Tap to select'
                      : '$selectedCount selected',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
                const Spacer(),
                TextButton(onPressed: onToggleEdit, child: const Text('Done')),
                if (selectedCount > 0)
                  IconButton(
                    icon: const Icon(
                      Icons.delete_outline,
                      color: AppColors.error,
                    ),
                    onPressed: onDelete,
                  ),
              ],
            )
          : Row(
              key: const ValueKey('title'),
              children: [
                Text(
                  title,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.45),
                  ),
                ),
                const SizedBox(width: 6),
                InkWell(
                  borderRadius: BorderRadius.circular(22),
                  onTap: onToggleEdit,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Icon(
                      Icons.edit_outlined,
                      size: 15,
                      color: colorScheme.onSurface.withOpacity(0.45),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
