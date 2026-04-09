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

// ─── Finish AppBar Button ─────────────────────────────────────────────────────

class FinishButton extends StatelessWidget {
  final VoidCallback onTap;
  const FinishButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 14,
            letterSpacing: 0.5,
          ),
        ),
        child: const Text('FINISH'),
      ),
    );
  }
}

// ─── Shared styled dialog ─────────────────────────────────────────────────────

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
                    color: AppColors.primary.withOpacity(0.18),
                    blurRadius: 40,
                    spreadRadius: 10,
                  ),
                ],
              ),
              child: const Icon(
                Icons.fitness_center,
                size: 48,
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
              'Start a session to log your sets and track your progress.',
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: onStart,
              icon: const Icon(Icons.play_arrow_rounded, size: 26),
              label: Text(
                'START SESSION',
                style: AppTextStyles.titleMedium.copyWith(letterSpacing: 1.1),
              ),
              style: FilledButton.styleFrom(
                minimumSize: const Size(double.infinity, 58),
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
class ActiveSession extends StatefulWidget {
  final WorkoutSessionActive state;
  const ActiveSession({super.key, required this.state});

  @override
  State<ActiveSession> createState() => _ActiveSessionState();
}

class _ActiveSessionState extends State<ActiveSession> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  @override
  void didUpdateWidget(covariant ActiveSession oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.state.exercises.length > oldWidget.state.exercises.length) {
      // New exercise added
      final newIndex = widget.state.exercises.length - 1;
      _listKey.currentState?.insertItem(
        newIndex,
        duration: const Duration(milliseconds: 400),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.state.exercises.isEmpty) {
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
            const Text(
              'Tap "+ Add Exercise" to begin.',
              style: AppTextStyles.bodyMedium,
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        SessionStatsBar(state: widget.state),
        const SizedBox(height: 8),
        Expanded(
          child: AnimatedList(
            key: _listKey,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
            initialItemCount: widget.state.exercises.length,
            itemBuilder: (context, index, animation) {
              return _buildExerciseCardWithAnimation(
                widget.state.exercises[index],
                animation,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildExerciseCardWithAnimation(
    Exercise exercise,
    Animation<double> animation,
  ) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 0.3),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
      child: FadeTransition(
        opacity: animation,
        child: ExerciseCard(exercise: exercise),
      ),
    );
  }
}
// class ActiveSession extends StatelessWidget {
//   final WorkoutSessionActive state;
//   const ActiveSession({super.key, required this.state});

//   @override
//   Widget build(BuildContext context) {
//     if (state.exercises.isEmpty) {
//       return Center(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Icon(
//               Icons.add_box_outlined,
//               size: 52,
//               color: AppColors.textTertiary,
//             ),
//             const SizedBox(height: 16),
//             Text(
//               'No exercises yet',
//               style: AppTextStyles.titleMedium.copyWith(
//                 color: AppColors.textTertiary,
//               ),
//             ),
//             const SizedBox(height: 6),
//             Text(
//               'Tap "+ Add Exercise" to begin.',
//               style: AppTextStyles.bodyMedium,
//             ),
//           ],
//         ),
//       );
//     }

//     return Column(
//       children: [
//         SessionStatsBar(state: state),
//         const SizedBox(height: 8),
//         Expanded(
//           child: ListView.builder(
//             padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
//             itemCount: state.exercises.length,
//             itemBuilder: (_, i) => ExerciseCard(exercise: state.exercises[i]),
//           ),
//         ),
//       ],
//     );
//   }
// }

// ─── Stats Bar ────────────────────────────────────────────────────────────────

class SessionStatsBar extends StatelessWidget {
  final WorkoutSessionActive state;
  const SessionStatsBar({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          StatChip(
            label: 'Exercises',
            value: '${state.exercises.length}',
            color: AppColors.primary,
          ),
          const _VerticalDivider(),
          StatChip(
            label: 'Total Sets',
            value: '${state.totalSets}',
            color: Colors.blueAccent,
          ),
          const _VerticalDivider(),
          StatChip(
            label: 'Volume',
            value: '${state.totalVolume.toStringAsFixed(0)} kg',
            color: Colors.orangeAccent,
          ),
        ],
      ),
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  const _VerticalDivider();

  @override
  Widget build(BuildContext context) =>
      Container(width: 1, height: 32, color: Colors.white10);
}

class StatChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const StatChip({
    super.key,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: AppTextStyles.headlineMedium.copyWith(
            fontSize: 22,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(label.toUpperCase(), style: AppTextStyles.labelSmall),
      ],
    );
  }
}

// ─── Exercise Card ────────────────────────────────────────────────────────────

class ExerciseCard extends StatelessWidget {
  final Exercise exercise;
  const ExerciseCard({super.key, required this.exercise});

  @override
  Widget build(BuildContext context) {
    final totalReps = exercise.sets.fold(0, (sum, s) => sum + s.reps);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(width: 4, color: AppColors.primary),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header row
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              exercise.name,
                              style: AppTextStyles.titleLarge,
                            ),
                          ),
                          if (totalReps > 0)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '$totalReps reps',
                                style: AppTextStyles.labelLarge.copyWith(
                                  color: AppColors.primary,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          const SizedBox(width: 4),
                          GestureDetector(
                            onTap: () =>
                                _confirmDeleteExercise(context, exercise.id),
                            child: const Icon(
                              Icons.delete_outline,
                              color: AppColors.error,
                              size: 20,
                            ),
                          ),
                        ],
                      ),

                      if (exercise.sets.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        // Column headers
                        const SetTableHeader(),
                        const SizedBox(height: 4),
                        const Divider(color: Colors.white10, height: 1),
                        const SizedBox(height: 2),
                        // Set rows — each row is tappable
                        ...exercise.sets.asMap().entries.map((entry) {
                          return SetRow(
                            index: entry.key,
                            set: entry.value,
                            exerciseId: exercise.id,
                            exerciseName: exercise.name,
                          );
                        }),
                      ],

                      const SizedBox(height: 12),

                      // Add new set
                      OutlinedButton.icon(
                        onPressed: () => _addNewSet(context, exercise.id),
                        icon: const Icon(Icons.add, size: 16),
                        label: Text(
                          'Add New Set',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          side: const BorderSide(
                            color: AppColors.primary,
                            width: 1,
                          ),
                          minimumSize: const Size(double.infinity, 44),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
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
        icon: Icons.delete_outline,
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

// ─── Set Table Header ─────────────────────────────────────────────────────────

class SetTableHeader extends StatelessWidget {
  const SetTableHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: [
          SizedBox(
            width: 30,
            child: Text('SET', style: AppTextStyles.labelSmall),
          ),
          Expanded(child: Text('WEIGHT', style: AppTextStyles.labelSmall)),
          Expanded(child: Text('REPS', style: AppTextStyles.labelSmall)),
          const SizedBox(width: 28), // delete button space
        ],
      ),
    );
  }
}

// ─── Set Row (fully tappable) ─────────────────────────────────────────────────

class SetRow extends StatelessWidget {
  final int index;
  final ExerciseSet set;
  final String exerciseId;
  final String exerciseName;

  const SetRow({
    super.key,
    required this.index,
    required this.set,
    required this.exerciseId,
    required this.exerciseName,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        // Tapping anywhere on the row opens the edit sheet
        onTap: () => showEditSetSheet(
          context: context,
          set: set,
          exerciseId: exerciseId,
          exerciseName: exerciseName,
        ),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
          child: Row(
            children: [
              // Set number badge
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: Colors.white70,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textTertiary,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _formatWeight(set.weightKg),
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  '${set.reps} reps',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              // Delete only — edit is the whole row tap
              GestureDetector(
                onTap: () => context.read<WorkoutSessionBloc>().add(
                  RemoveSet(exerciseId: exerciseId, setId: set.id),
                ),
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: AppColors.error.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.close,
                    size: 14,
                    color: AppColors.error,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Formats weight: shows whole number if no decimal needed (e.g. 80 not 80.0)
  String _formatWeight(double weight) {
    if (weight == 0) return '0 kg';
    return weight % 1 == 0
        ? '${weight.toInt()} kg'
        : '${weight.toStringAsFixed(1)} kg';
  }
}

// ─── Edit Set Bottom Sheet ────────────────────────────────────────────────────
// Sheet instead of dialog: faster to reach on mobile, keyboard-native

void showEditSetSheet({
  required BuildContext context,
  required ExerciseSet set,
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
    // useSafeArea keeps it above home bar
    useSafeArea: true,
    builder: (sheetCtx) => _EditSetSheetContent(
      set: set,
      exerciseId: exerciseId,
      exerciseName: exerciseName,
    ),
  );
}

class _EditSetSheetContent extends StatefulWidget {
  final ExerciseSet set;
  final String exerciseId;
  final String exerciseName;

  const _EditSetSheetContent({
    required this.set,
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
    context.read<WorkoutSessionBloc>().add(
      UpdateSet(
        exerciseId: widget.exerciseId,
        setId: widget.set.id,
        weightKg: double.parse(_weightCtrl.text),
        reps: int.parse(_repsCtrl.text),
      ),
    );
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
                    onFieldSubmitted: (_) =>
                        _repsFocus.requestFocus(), // ← Key Fix
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
                    onFieldSubmitted: (_) => _save(), // ← Done key saves
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
      // Select-all on tap so user replaces value in one go
      onTap: () => controller.selection = TextSelection(
        baseOffset: 0,
        extentOffset: controller.text.length,
      ),
      style: AppTextStyles.headlineMedium.copyWith(fontSize: 24),
      textAlign: TextAlign.center,
      inputFormatters: [
        // Prevents letters being typed
        FilteringTextInputFormatter.allow(RegExp(r'[\d.]')),
      ],
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

// ─── Add Exercise Bottom Sheet ────────────────────────────────────────────────

void showAddExerciseSheet(BuildContext context) {
  final controller = TextEditingController();
  const presets = [
    'Bench Press',
    'Squat',
    'Deadlift',
    'Overhead Press',
    'Pull-up',
    'Barbell Row',
    'Lat Pulldown',
    'Bicep Curl',
    'Tricep Pushdown',
    'Leg Press',
    'Cable Fly',
    'Leg Curl',
  ];

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (sheetContext) => Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        8,
        20,
        MediaQuery.of(sheetContext).viewInsets.bottom + 24,
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
          const SizedBox(height: 16),
          TextField(
            controller: controller,
            autofocus: true,
            style: const TextStyle(color: AppColors.textPrimary),
            decoration: InputDecoration(
              hintText: 'Exercise name',
              hintStyle: const TextStyle(color: AppColors.textTertiary),
              filled: true,
              fillColor: AppColors.card,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 1.5,
                ),
              ),
              prefixIcon: const Icon(
                Icons.fitness_center,
                color: AppColors.textTertiary,
              ),
            ),
            onSubmitted: (value) {
              if (value.trim().isEmpty) return;
              context.read<WorkoutSessionBloc>().add(
                AddExercise(exerciseName: value.trim()),
              );
              Navigator.pop(sheetContext);
            },
          ),
          const SizedBox(height: 20),
          Text('QUICK PICK', style: AppTextStyles.labelSmall),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: presets.map((name) {
              return GestureDetector(
                onTap: () {
                  context.read<WorkoutSessionBloc>().add(
                    AddExercise(exerciseName: name),
                  );
                  Navigator.pop(sheetContext);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white12),
                  ),
                  child: Text(
                    name,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    ),
  );
}
