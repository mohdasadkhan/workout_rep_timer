import 'package:app_lifecycle/core/theme/app_colors.dart';
import 'package:app_lifecycle/core/theme/app_text_styles.dart';
import 'package:app_lifecycle/features/rep_tracker/domain/entities/exercise.dart';
import 'package:app_lifecycle/features/rep_tracker/domain/entities/exercise_set.dart';
import 'package:app_lifecycle/features/rep_tracker/presentation/bloc/workout_session_bloc/workout_session_bloc.dart';
import 'package:app_lifecycle/features/rep_tracker/presentation/bloc/workout_session_bloc/workout_session_event.dart';
import 'package:app_lifecycle/features/rep_tracker/presentation/bloc/workout_session_bloc/workout_session_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

// ─── Muscle category helper ───────────────────────────────────────────────────

String _muscleCategory(String name) {
  final n = name.toLowerCase();
  const push = [
    'press',
    'push',
    'fly',
    'dip',
    'raise',
    'tricep',
    'chest',
    'shoulder',
  ];
  const pull = [
    'pull',
    'row',
    'curl',
    'lat',
    'deadlift',
    'bicep',
    'hammer',
    'face pull',
  ];
  const legs = [
    'squat',
    'leg',
    'lunge',
    'calf',
    'romanian',
    'hip thrust',
    'glute',
  ];
  const core = ['plank', 'crunch', 'twist', 'ab ', 'hanging'];
  if (push.any((k) => n.contains(k))) return 'Push';
  if (pull.any((k) => n.contains(k))) return 'Pull';
  if (legs.any((k) => n.contains(k))) return 'Legs';
  if (core.any((k) => n.contains(k))) return 'Core';
  return '';
}

// ─── Finish pill (AppBar action) ──────────────────────────────────────────────

class FinishButton extends StatelessWidget {
  final VoidCallback onTap;
  const FinishButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.12),
            border: Border.all(color: AppColors.primary.withOpacity(0.3)),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'FINISH',
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.primary,
              fontSize: 11,
              letterSpacing: 1.2,
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Shared dialog ────────────────────────────────────────────────────────────

class AppDialog extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final Widget content;
  final List<Widget> actions;

  const AppDialog({
    super.key,
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.content,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 28),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: AppTextStyles.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            DefaultTextStyle(
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
              child: content,
            ),
            const SizedBox(height: 24),
            Row(
              children:
                  actions
                      .expand(
                        (w) => [Expanded(child: w), const SizedBox(width: 10)],
                      )
                      .toList()
                    ..removeLast(),
            ),
          ],
        ),
      ),
    );
  }
}

class DialogButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool filled;

  const DialogButton.filled({
    super.key,
    required this.label,
    required this.onTap,
  }) : filled = true;
  const DialogButton.outlined({
    super.key,
    required this.label,
    required this.onTap,
  }) : filled = false;

  @override
  Widget build(BuildContext context) {
    if (filled) {
      return FilledButton(
        onPressed: onTap,
        style: FilledButton.styleFrom(
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(label),
      );
    }
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, 48),
        side: const BorderSide(color: Colors.white24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(label),
    );
  }
}

// ─── Start Prompt ─────────────────────────────────────────────────────────────

class StartPrompt extends StatelessWidget {
  final VoidCallback onStart;
  const StartPrompt({super.key, required this.onStart});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withOpacity(0.08),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.15),
                    blurRadius: 40,
                    spreadRadius: 8,
                  ),
                ],
              ),
              child: const Icon(
                Icons.fitness_center,
                size: 46,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Ready to train?',
              style: AppTextStyles.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Start a session to log your sets\nand track your progress.',
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: onStart,
              icon: const Icon(Icons.play_arrow_rounded, size: 24),
              label: Text(
                'START SESSION',
                style: AppTextStyles.titleMedium.copyWith(letterSpacing: 1.1),
              ),
              style: FilledButton.styleFrom(
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Active Session ───────────────────────────────────────────────────────────

class ActiveSession extends StatelessWidget {
  final WorkoutSessionActive state;
  const ActiveSession({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    if (state.exercises.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.add_box_outlined,
              size: 52,
              color: AppColors.textTertiary,
            ),
            const SizedBox(height: 16),
            Text(
              'No exercises yet',
              style: AppTextStyles.titleMedium.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Tap "+ Add Exercise" to begin.',
              style: AppTextStyles.bodyMedium,
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        SessionStatsBar(state: state),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 110),
            itemCount: state.exercises.length,
            itemBuilder: (_, i) => ExerciseCard(exercise: state.exercises[i]),
          ),
        ),
      ],
    );
  }
}

// ─── Stats Bar ────────────────────────────────────────────────────────────────

class SessionStatsBar extends StatelessWidget {
  final WorkoutSessionActive state;
  const SessionStatsBar({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          _StatItem(label: 'Exercises', value: '${state.exercises.length}'),
          _StatDivider(),
          _StatItem(label: 'Sets', value: '${state.totalSets}'),
          _StatDivider(),
          _StatItem(
            label: 'Volume',
            value: state.totalVolume.toStringAsFixed(0),
            unit: 'kg',
            accentValue: true,
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final String? unit;
  final bool accentValue;

  const _StatItem({
    required this.label,
    required this.value,
    this.unit,
    this.accentValue = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: value,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: accentValue
                        ? AppColors.primary
                        : AppColors.textPrimary,
                    letterSpacing: -0.5,
                  ),
                ),
                if (unit != null)
                  TextSpan(
                    text: ' $unit',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textTertiary,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label.toUpperCase(),
            style: AppTextStyles.labelSmall.copyWith(
              fontSize: 9,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Container(width: 1, height: 28, color: Colors.white.withOpacity(0.05));
}

// ─── Exercise Card ────────────────────────────────────────────────────────────

class ExerciseCard extends StatelessWidget {
  final Exercise exercise;
  const ExerciseCard({super.key, required this.exercise});

  @override
  Widget build(BuildContext context) {
    final category = _muscleCategory(exercise.name);
    final setCount = exercise.sets.length;
    final totalVolume = exercise.sets.fold(
      0.0,
      (sum, s) => sum + (s.weightKg * s.reps),
    );

    // ── Sub-label under exercise name: "PUSH  ·  3 sets"
    // Category and set count together — one quiet line, no repeated badges.
    final subParts = <String>[
      if (category.isNotEmpty) category.toUpperCase(),
      if (setCount > 0) '$setCount ${setCount == 1 ? 'set' : 'sets'}',
    ];
    final subLabel = subParts.join('  ·  ');

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──────────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 12, 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left: name + "PUSH  ·  3 sets"
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        exercise.name,
                        style: AppTextStyles.titleMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (subLabel.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          subLabel,
                          style: AppTextStyles.labelSmall.copyWith(
                            color: AppColors.primary,
                            fontSize: 10,
                            letterSpacing: 1.4,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 10),

                // Volume badge
                if (totalVolume > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    margin: const EdgeInsets.only(top: 1),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.08),
                      border: Border.all(
                        color: AppColors.primary.withOpacity(0.18),
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          totalVolume >= 1000
                              ? '${(totalVolume / 1000).toStringAsFixed(1)}k'
                              : totalVolume.toStringAsFixed(0),
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                            letterSpacing: -0.3,
                            height: 1.1,
                          ),
                        ),
                        Text(
                          'kg vol',
                          style: AppTextStyles.labelSmall.copyWith(
                            fontSize: 8,
                            letterSpacing: 0.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(width: 8),

                // Delete exercise
                GestureDetector(
                  onTap: () => _confirmDeleteExercise(context, exercise.id),
                  child: Container(
                    width: 30,
                    height: 30,
                    margin: const EdgeInsets.only(top: 1),
                    decoration: BoxDecoration(
                      color: AppColors.error.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: const Icon(
                      Icons.delete_outline_rounded,
                      color: AppColors.error,
                      size: 15,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Sets list ────────────────────────────────────────────────────────
          if (exercise.sets.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 0),
              child: Column(
                children: [
                  _SetColumnHeader(),
                  const SizedBox(height: 2),
                  ...exercise.sets.asMap().entries.map((entry) {
                    return SetRow(
                      index: entry.key,
                      set: entry.value,
                      allSets: exercise.sets,
                      exerciseId: exercise.id,
                      exerciseName: exercise.name,
                      isLatest: entry.key == exercise.sets.length - 1,
                    );
                  }),
                ],
              ),
            ),

          // ── Add Set ─────────────────────────────────────────────────────────
          _AddSetButton(onTap: () => _addNewSet(context, exercise.id)),
        ],
      ),
    );
  }

  void _addNewSet(BuildContext context, String exerciseId) {
    final bloc = context.read<WorkoutSessionBloc>();
    final current = bloc.state;
    if (current is! WorkoutSessionActive) return;

    final ex = current.exercises.firstWhere((e) => e.id == exerciseId);
    final lastWeight = ex.sets.isNotEmpty ? ex.sets.last.weightKg : 0.0;
    final lastRep = ex.sets.isNotEmpty ? ex.sets.last.reps : 0;

    bloc.add(
      LogSet(
        exerciseId: exerciseId,
        set: ExerciseSet(
          id: const Uuid().v4(),
          weightKg: lastWeight,
          reps: lastRep,
          performedAt: DateTime.now(),
        ),
      ),
    );
  }

  void _confirmDeleteExercise(BuildContext context, String exerciseId) {
    showDialog(
      context: context,
      builder: (_) => AppDialog(
        title: 'Delete Exercise?',
        icon: Icons.delete_outline_rounded,
        iconColor: AppColors.error,
        content: const Text('All sets for this exercise will be removed.'),
        actions: [
          DialogButton.outlined(
            label: 'Cancel',
            onTap: () => Navigator.pop(context),
          ),
          DialogButton.filled(
            label: 'Delete',
            onTap: () {
              Navigator.pop(context);
              context.read<WorkoutSessionBloc>().add(
                RemoveExercise(exerciseId),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ─── Set column header ────────────────────────────────────────────────────────

class _SetColumnHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final style = AppTextStyles.labelSmall.copyWith(
      fontSize: 9,
      letterSpacing: 0.8,
    );
    return Padding(
      padding: const EdgeInsets.only(bottom: 4, left: 2),
      child: Row(
        children: [
          SizedBox(width: 32, child: Text('SET', style: style)),
          Expanded(child: Text('WEIGHT', style: style)),
          Expanded(child: Text('REPS', style: style)),
          const SizedBox(width: 30),
        ],
      ),
    );
  }
}

// ─── Set Row ─────────────────────────────────────────────────────────────────

class SetRow extends StatelessWidget {
  final int index;
  final ExerciseSet set;
  final List<ExerciseSet> allSets; // needed for auto-fill downstream on edit
  final String exerciseId;
  final String exerciseName;
  final bool isLatest;

  const SetRow({
    super.key,
    required this.index,
    required this.set,
    required this.allSets,
    required this.exerciseId,
    required this.exerciseName,
    this.isLatest = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Material(
        color: isLatest
            ? AppColors.primary.withOpacity(0.07)
            : Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: () => showEditSetSheet(
            context: context,
            set: set,
            editedIndex: index,
            allSets: allSets,
            exerciseId: exerciseId,
            exerciseName: exerciseName,
          ),
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isLatest
                    ? AppColors.primary.withOpacity(0.15)
                    : Colors.transparent,
              ),
            ),
            child: Row(
              children: [
                // Set number badge
                Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    color: isLatest
                        ? AppColors.primary.withOpacity(0.2)
                        : Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: isLatest
                            ? AppColors.primary
                            : AppColors.textTertiary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 6),

                Expanded(
                  child: Text(
                    _formatWeight(set.weightKg),
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: isLatest
                          ? AppColors.textPrimary
                          : AppColors.textSecondary,
                      fontWeight: isLatest ? FontWeight.w600 : FontWeight.w400,
                      fontSize: 13,
                    ),
                  ),
                ),

                Expanded(
                  child: Text(
                    '${set.reps} reps',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: isLatest
                          ? AppColors.textPrimary
                          : AppColors.textSecondary,
                      fontWeight: isLatest ? FontWeight.w600 : FontWeight.w400,
                      fontSize: 13,
                    ),
                  ),
                ),

                // Per-set delete
                GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    context.read<WorkoutSessionBloc>().add(
                      RemoveSet(exerciseId: exerciseId, setId: set.id),
                    );
                  },
                  child: Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      color: AppColors.error.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: const Icon(
                      Icons.close_rounded,
                      size: 12,
                      color: AppColors.error,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatWeight(double weight) {
    if (weight == 0) return '0 kg';
    return weight % 1 == 0
        ? '${weight.toInt()} kg'
        : '${weight.toStringAsFixed(1)} kg';
  }
}

// ─── Add Set button ───────────────────────────────────────────────────────────

class _AddSetButton extends StatelessWidget {
  final VoidCallback onTap;
  const _AddSetButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Container(
        margin: const EdgeInsets.fromLTRB(12, 6, 12, 12),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white.withOpacity(0.08)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_rounded, size: 13, color: AppColors.textTertiary),
            const SizedBox(width: 5),
            Text(
              'Add set',
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.textTertiary,
                fontSize: 11,
                letterSpacing: 0.4,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Edit Set Bottom Sheet ────────────────────────────────────────────────────

void showEditSetSheet({
  required BuildContext context,
  required ExerciseSet set,
  required int editedIndex, // position of this set in allSets
  required List<ExerciseSet> allSets, // full list — used for auto-fill
  required String exerciseId,
  required String exerciseName,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    useSafeArea: true,
    builder: (sheetCtx) => _EditSetSheetContent(
      set: set,
      editedIndex: editedIndex,
      allSets: allSets,
      exerciseId: exerciseId,
      exerciseName: exerciseName,
    ),
  );
}

class _EditSetSheetContent extends StatefulWidget {
  final ExerciseSet set;
  final int editedIndex;
  final List<ExerciseSet> allSets;
  final String exerciseId;
  final String exerciseName;

  const _EditSetSheetContent({
    required this.set,
    required this.editedIndex,
    required this.allSets,
    required this.exerciseId,
    required this.exerciseName,
  });

  @override
  State<_EditSetSheetContent> createState() => _EditSetSheetContentState();
}

class _EditSetSheetContentState extends State<_EditSetSheetContent> {
  late final TextEditingController _weightCtrl;
  late final TextEditingController _repsCtrl;
  late final FocusNode _weightFocus;
  late final FocusNode _repsFocus;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _weightFocus = FocusNode();
    _repsFocus = FocusNode();

    final rawWeight = widget.set.weightKg;
    final weightText = rawWeight == 0
        ? ''
        : rawWeight % 1 == 0
        ? rawWeight.toInt().toString()
        : rawWeight.toStringAsFixed(1);

    _weightCtrl = TextEditingController(text: weightText);
    _repsCtrl = TextEditingController(
      text: widget.set.reps == 0 ? '' : widget.set.reps.toString(),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _weightFocus.requestFocus();
      _weightCtrl.selection = TextSelection(
        baseOffset: 0,
        extentOffset: _weightCtrl.text.length,
      );
    });
  }

  @override
  void dispose() {
    _weightCtrl.dispose();
    _repsCtrl.dispose();
    _weightFocus.dispose();
    _repsFocus.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final newWeight = double.parse(_weightCtrl.text);
    final newReps = int.parse(_repsCtrl.text);
    final bloc = context.read<WorkoutSessionBloc>();

    // Save the edited set
    bloc.add(
      UpdateSet(
        exerciseId: widget.exerciseId,
        setId: widget.set.id,
        weightKg: newWeight,
        reps: newReps,
      ),
    );

    // Auto-fill: walk sets BELOW the edited one.
    // For each consecutive set that is still 0 kg AND 0 reps, copy the new value.
    // Stop as soon as we hit a set that already has real data.
    for (var i = widget.editedIndex + 1; i < widget.allSets.length; i++) {
      final below = widget.allSets[i];
      if (below.weightKg == 0 && below.reps == 0) {
        bloc.add(
          UpdateSet(
            exerciseId: widget.exerciseId,
            setId: below.id,
            weightKg: newWeight,
            reps: newReps,
          ),
        );
      } else {
        // Hit a set with real data — stop propagating
        break;
      }
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        8,
        20,
        MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Form(
        key: _formKey,
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
            Row(
              children: [
                const Icon(
                  Icons.edit_outlined,
                  color: AppColors.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text('Edit Set', style: AppTextStyles.titleLarge),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '· ${widget.exerciseName}',
                    style: AppTextStyles.bodyMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _SheetField(
                    controller: _weightCtrl,
                    focusNode: _weightFocus,
                    label: 'Weight (kg)',
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) => _repsFocus.requestFocus(),
                    validator: (v) =>
                        (v?.trim().isEmpty ?? true) ? 'Required' : null,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _SheetField(
                    controller: _repsCtrl,
                    focusNode: _repsFocus,
                    label: 'Reps',
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _save(),
                    validator: (v) =>
                        (v?.trim().isEmpty ?? true) ? 'Required' : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _save,
              style: FilledButton.styleFrom(
                minimumSize: const Size(double.infinity, 52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Text(
                'SAVE SET',
                style: AppTextStyles.titleMedium.copyWith(letterSpacing: 0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Sheet field ──────────────────────────────────────────────────────────────

class _SheetField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final String label;
  final TextInputType keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onFieldSubmitted;
  final String? Function(String?)? validator;

  const _SheetField({
    required this.controller,
    this.focusNode,
    required this.label,
    required this.keyboardType,
    this.textInputAction,
    this.onFieldSubmitted,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      textInputAction: textInputAction ?? TextInputAction.next,
      onFieldSubmitted: onFieldSubmitted,
      onTap: () => controller.selection = TextSelection(
        baseOffset: 0,
        extentOffset: controller.text.length,
      ),
      style: AppTextStyles.headlineMedium.copyWith(fontSize: 24),
      textAlign: TextAlign.center,
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d.]'))],
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.textTertiary),
        filled: true,
        fillColor: AppColors.card,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error),
        ),
      ),
      validator: validator,
    );
  }
}
