import 'package:fitflow/core/constants/pref_keys.dart';
import 'package:fitflow/core/di/injection.dart';
import 'package:fitflow/core/theme/app_colors.dart';
import 'package:fitflow/core/theme/app_text_styles.dart';
import 'package:fitflow/features/rep_tracker/presentation/bloc/workout_session_bloc/workout_session_bloc.dart';
import 'package:fitflow/features/rep_tracker/presentation/bloc/workout_session_bloc/workout_session_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddExerciseBottomSheet extends StatelessWidget {
  final String initialCategory;
  const AddExerciseBottomSheet({super.key, this.initialCategory = 'All'});

  static Future<void> show(
    BuildContext context, {
    String initialCategory = 'All',
  }) {
    final controller = AnimationController(
      vsync: Navigator.of(context),
      duration: const Duration(milliseconds: 420),
    );

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      // No explicit backgroundColor — sheet inherits from BottomSheetTheme → colorScheme.surface
      transitionAnimationController: controller,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) => _SpringWrapper(
        controller: controller,
        child: AddExerciseBottomSheet(initialCategory: initialCategory),
      ),
    ).whenComplete(() {
      if (!controller.isAnimating) controller.dispose();
    });
  }

  @override
  Widget build(BuildContext context) =>
      _AddExerciseContent(initialCategory: initialCategory);
}

// ─── Spring animation wrapper ─────────────────────────────────────────────────

class _SpringWrapper extends StatelessWidget {
  final AnimationController controller;
  final Widget child;
  const _SpringWrapper({required this.controller, required this.child});

  @override
  Widget build(BuildContext context) {
    final slide = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.elasticOut));

    final fade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.0, 0.35, curve: Curves.easeOut),
      ),
    );

    return SlideTransition(
      position: slide,
      child: FadeTransition(opacity: fade, child: child),
    );
  }
}

// ─── Sheet content ────────────────────────────────────────────────────────────

class _AddExerciseContent extends StatefulWidget {
  final String initialCategory;
  const _AddExerciseContent({required this.initialCategory});

  @override
  State<_AddExerciseContent> createState() => _AddExerciseContentState();
}

class _AddExerciseContentState extends State<_AddExerciseContent> {
  final TextEditingController _controller = TextEditingController();
  String _searchQuery = '';
  late String _selectedCategory;

  final List<String> _categories = ['All', 'Push', 'Pull', 'Legs', 'Core'];

  final Map<String, List<String>> _exercisePresets = {
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

  final ScrollController _categoryScrollCtrl = ScrollController();

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory;
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToSelected());
  }

  void _scrollToSelected() {
    if (!_categoryScrollCtrl.hasClients) return;
    final index = _categories.indexOf(_selectedCategory);
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

  @override
  void dispose() {
    _controller.dispose();
    _categoryScrollCtrl.dispose();
    super.dispose();
  }

  Future<void> _saveLastCategory(String category) async {
    final prefs = getIt<SharedPreferences>();
    await prefs.setString(PrefKeys.lastExerciseCategory, category);
  }

  void _addExercise(String name) {
    if (name.trim().isEmpty) return;
    HapticFeedback.mediumImpact();
    context.read<WorkoutSessionBloc>().add(
      AddExercise(exerciseName: name.trim()),
    );
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final filtered = _exercisePresets.entries
        .where((e) => _selectedCategory == 'All' || e.key == _selectedCategory)
        .expand((e) => e.value)
        .where((n) => n.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

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
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                // theme-aware handle: dark in light mode, light in dark mode
                color: colorScheme.onSurface.withOpacity(0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          Text('Add Exercise', style: textTheme.titleLarge),
          const SizedBox(height: 20),

          // Search field
          TextField(
            controller: _controller,
            autofocus: true,
            textInputAction: TextInputAction.done,
            // text color from theme — no hardcode
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
                        setState(() => _searchQuery = '');
                      },
                    )
                  : null,
            ),
            onChanged: (v) => setState(() => _searchQuery = v.trim()),
            onSubmitted: _addExercise,
          ),

          const SizedBox(height: 24),

          // Category chips
          SingleChildScrollView(
            controller: _categoryScrollCtrl,
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _categories.map((cat) {
                final selected = _selectedCategory == cat;
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
                        setState(() => _selectedCategory = cat);
                        _saveLastCategory(cat);
                        _scrollToSelected();
                      }
                    },
                    // chip background: elevated surface for unselected, tinted for selected
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
          ),

          const SizedBox(height: 28),
          Text(
            'QUICK PICK',
            style: AppTextStyles.labelSmall.copyWith(
              color: colorScheme.onSurface.withOpacity(0.45),
            ),
          ),
          const SizedBox(height: 12),

          filtered.isEmpty && _searchQuery.isNotEmpty
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
              : Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: filtered
                      .map((name) => _buildChip(context, name))
                      .toList(),
                ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildChip(BuildContext context, String name) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Material(
      // Material color must match the container so InkWell ripple renders correctly
      color: colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: () => _addExercise(name),
        splashColor: AppColors.primary.withOpacity(0.22),
        highlightColor: AppColors.primary.withOpacity(0.1),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: colorScheme.outline.withOpacity(0.15)),
          ),
          child: Text(
            name,
            style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}
