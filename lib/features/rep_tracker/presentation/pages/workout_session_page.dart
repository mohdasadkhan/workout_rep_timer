import 'package:app_lifecycle/core/constants/pref_keys.dart';
import 'package:app_lifecycle/core/di/injection.dart';
import 'package:app_lifecycle/core/theme/app_colors.dart';
import 'package:app_lifecycle/core/widgets/dialogs/exit_dialog.dart';
import 'package:app_lifecycle/core/widgets/feature_dropdown/extension_on_appfeature.dart';
import 'package:app_lifecycle/core/widgets/feature_dropdown/feature_dropdown.dart';
import 'package:app_lifecycle/features/rep_tracker/presentation/widgets/session_widgets/add_exercise_bottom_sheet.dart';
import 'package:app_lifecycle/features/rep_tracker/presentation/widgets/session_widgets/workout_session_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../bloc/workout_session_bloc/workout_session_bloc.dart';
import '../bloc/workout_session_bloc/workout_session_event.dart';
import '../bloc/workout_session_bloc/workout_session_state.dart';

class WorkoutSessionPage extends StatelessWidget {
  const WorkoutSessionPage({super.key});

  Future<void> _handleExitAttempt(BuildContext context) async {
    final shouldDiscard = await showExitDialog(context);
    if (shouldDiscard == true && context.mounted) {
      context.read<WorkoutSessionBloc>().add(const DiscardSession());
    }
  }

  void _confirmFinish(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AppDialog(
        title: 'Finish Workout?',
        icon: Icons.check_circle_outline,
        iconColor: AppColors.primary,
        content: const Text(
          'This will save your session to history.',
          textAlign: TextAlign.center,
        ),
        actions: [
          DialogButton.outlined(
            label: 'Cancel',
            onTap: () => Navigator.pop(context),
          ),
          DialogButton.filled(
            label: 'Save',
            onTap: () {
              Navigator.pop(context);
              context.read<WorkoutSessionBloc>().add(
                const FinishWorkoutSession(),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WorkoutSessionBloc, WorkoutSessionState>(
      listener: (context, state) {
        if (state is WorkoutSessionSaved) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(Icons.check_circle_outline, color: AppColors.primary),
                  SizedBox(width: 12),
                  Text(
                    'Workout saved! Great session 💪',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              backgroundColor: AppColors.card,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
          context.read<WorkoutSessionBloc>().add(const StartWorkoutSession());
        }
        if (state is WorkoutSessionError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        return PopScope(
          canPop: state is! WorkoutSessionActive,
          onPopInvokedWithResult: (didPop, _) async {
            if (didPop) return;
            await _handleExitAttempt(context);
          },
          child: Scaffold(
            appBar: AppBar(
              title: FeatureDropdownTitle(current: AppFeature.repTracker),
              centerTitle: false,
              automaticallyImplyLeading: false,
              actions: [
                Container(
                  width: 36,
                  height: 36,
                  margin: const EdgeInsets.only(right: 6),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white.withOpacity(0.07)),
                  ),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: const Icon(
                      Icons.history_rounded,
                      size: 18,
                      color: AppColors.textSecondary,
                    ),
                    tooltip: 'History',
                    onPressed: () => context.push('/rep-tracker/history'),
                  ),
                ),

                if (state is WorkoutSessionActive && state.exercises.isNotEmpty)
                  FinishButton(onTap: () => _confirmFinish(context)),
              ],
            ),

            body: switch (state) {
              WorkoutInitial() => StartPrompt(
                onStart: () => context.read<WorkoutSessionBloc>().add(
                  const StartWorkoutSession(),
                ),
              ),
              WorkoutLoading() => const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
              WorkoutSessionActive() => ActiveSession(state: state),
              _ => StartPrompt(
                onStart: () => context.read<WorkoutSessionBloc>().add(
                  const StartWorkoutSession(),
                ),
              ),
            },
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            floatingActionButton: state is WorkoutSessionActive
                ? FloatingActionButton.extended(
                    onPressed: () async {
                      final prefs = getIt<SharedPreferences>();
                      final lastCategory =
                          prefs.getString(PrefKeys.lastExerciseCategory) ??
                          'All';
                      await AddExerciseBottomSheet.show(
                        context,
                        initialCategory: lastCategory,
                      );
                    },
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 4,
                    icon: const Icon(Icons.add_rounded, size: 20),
                    label: const Text(
                      'Add Exercise',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.2,
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  )
                : null,
          ),
        );
      },
    );
  }
}
