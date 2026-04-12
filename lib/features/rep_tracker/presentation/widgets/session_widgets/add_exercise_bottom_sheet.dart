import 'package:app_lifecycle/core/constants/pref_keys.dart';
import 'package:app_lifecycle/core/theme/app_colors.dart';
import 'package:app_lifecycle/core/theme/app_text_styles.dart';
import 'package:app_lifecycle/features/rep_tracker/presentation/bloc/workout_session_bloc/workout_session_bloc.dart';
import 'package:app_lifecycle/features/rep_tracker/presentation/bloc/workout_session_bloc/workout_session_event.dart';
import 'package:app_lifecycle/features/rep_tracker/presentation/bloc/workout_session_bloc/workout_session_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddExerciseBottomSheet extends StatefulWidget {
  const AddExerciseBottomSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) => const AddExerciseBottomSheet(),
    );
  }

  @override
  State<AddExerciseBottomSheet> createState() => _AddExerciseBottomSheetState();
}

class _AddExerciseBottomSheetState extends State<AddExerciseBottomSheet> {
  final TextEditingController _controller = TextEditingController();
  String _searchQuery = '';
  String _selectedCategory = 'All';

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

  final ScrollController _categoryScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadLastCategory();
  }

  Future<void> _loadLastCategory() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(PrefKeys.lastExerciseCategory);
    if (saved != null && _categories.contains(saved)) {
      setState(() => _selectedCategory = saved);

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToSelectedCategory();
      });
    }
  }

  Future<void> _saveLastCategory(String category) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(PrefKeys.lastExerciseCategory, category);
  }

  void _scrollToSelectedCategory() {
    if (!_categoryScrollController.hasClients) return;

    final index = _categories.indexOf(_selectedCategory);
    if (index == -1) return;

    const double itemWidth = 108;
    final double targetOffset =
        (index * itemWidth) -
        (MediaQuery.of(context).size.width / 2) +
        (itemWidth / 2);

    _categoryScrollController.animateTo(
      targetOffset.clamp(
        0.0,
        _categoryScrollController.position.maxScrollExtent,
      ),
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _categoryScrollController.dispose();
    super.dispose();
  }

  void _addExercise(String name) {
    if (name.trim().isEmpty) return;
    HapticFeedback.mediumImpact();
    context.read<WorkoutSessionBloc>().add(
      AddExercise(exerciseName: name.trim()),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final filteredPresets = _exercisePresets.entries
        .where((e) => _selectedCategory == 'All' || e.key == _selectedCategory)
        .expand((e) => e.value)
        .where(
          (name) => name.toLowerCase().contains(_searchQuery.toLowerCase()),
        )
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
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          Text('Add Exercise', style: AppTextStyles.titleLarge),
          const SizedBox(height: 20),

          TextField(
            controller: _controller,
            autofocus: true,
            textInputAction: TextInputAction.done,
            style: const TextStyle(color: AppColors.textPrimary, fontSize: 16),
            decoration: InputDecoration(
              hintText: 'Search or type new exercise',
              hintStyle: const TextStyle(
                color: AppColors.textTertiary,
                fontSize: 16,
              ),
              filled: true,
              fillColor: AppColors.card,
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
              prefixIcon: const Icon(
                Icons.search,
                color: AppColors.textTertiary,
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
            onChanged: (value) => setState(() => _searchQuery = value.trim()),
            onSubmitted: _addExercise,
          ),

          const SizedBox(height: 24),

          SingleChildScrollView(
            controller: _categoryScrollController,
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _categories.map((cat) {
                final isSelected = _selectedCategory == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    checkmarkColor: AppColors.primary,
                    label: Text(
                      cat,
                      style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w500,
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.textPrimary,
                      ),
                    ),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        HapticFeedback.lightImpact();
                        setState(() => _selectedCategory = cat);
                        _saveLastCategory(cat);
                      }
                    },
                    backgroundColor: AppColors.card,
                    selectedColor: AppColors.primary.withOpacity(0.15),
                    side: BorderSide(
                      color: isSelected
                          ? AppColors.primary.withOpacity(0.6)
                          : Colors.white.withOpacity(0.1),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    elevation: isSelected ? 1 : 0,
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 28),

          Text('QUICK PICK', style: AppTextStyles.labelSmall),
          const SizedBox(height: 12),

          filteredPresets.isEmpty && _searchQuery.isNotEmpty
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: Text(
                      'No matching exercises\nType and tap Done to add custom',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.textTertiary,
                        fontSize: 14,
                      ),
                    ),
                  ),
                )
              : AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) => FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position:
                          Tween<Offset>(
                            begin: const Offset(0, 0.08),
                            end: Offset.zero,
                          ).animate(
                            CurvedAnimation(
                              parent: animation,
                              curve: Curves.easeOutCubic,
                            ),
                          ),
                      child: child,
                    ),
                  ),
                  child: Wrap(
                    key: ValueKey(_selectedCategory + _searchQuery),
                    spacing: 10,
                    runSpacing: 10,
                    children: List.generate(filteredPresets.length, (index) {
                      return _buildExerciseChip(
                        filteredPresets[index],
                        staggerDelay: index * 35,
                      );
                    }),
                  ),
                ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildExerciseChip(String name, {int staggerDelay = 0}) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 200 + staggerDelay),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) =>
          Transform.scale(scale: value, child: child),
      child: Material(
        color: AppColors.card,
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
              border: Border.all(color: Colors.white.withOpacity(0.08)),
            ),
            child: Text(
              name,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
