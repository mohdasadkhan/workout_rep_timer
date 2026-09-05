import 'package:fitflow/core/theme/app_colors.dart';
import 'package:fitflow/core/theme/app_text_styles.dart';
import 'package:fitflow/core/widgets/feature_dropdown/extension_on_appfeature.dart';
import 'package:fitflow/core/widgets/feature_dropdown/feature_dropdown.dart';
import 'package:fitflow/core/widgets/settings_menu_button.dart';
import 'package:fitflow/core/widgets/snackbars/app_snackbar.dart';
import 'package:fitflow/core/widgets/snackbars/app_snackbar_type.dart';
import 'package:fitflow/features/ai_coach/presentation/bloc/coach_home_bloc/coach_home_bloc.dart';
import 'package:fitflow/features/ai_coach/presentation/bloc/coach_home_bloc/coach_home_event.dart';
import 'package:fitflow/features/ai_coach/presentation/bloc/coach_home_bloc/coach_home_state.dart';
import 'package:fitflow/features/ai_coach/presentation/widgets/coach_briefing_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CoachHomeScreen extends StatelessWidget {
  const CoachHomeScreen({super.key});

  void _showComingSoon(BuildContext context) {
    AppSnackbar.show(
      context: context,
      title: 'Coming soon',
      message: 'AI chat arrives in the next sprint.',
      type: AppSnackbarType.info,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const FeatureDropdownTitle(current: AppFeature.coach),
        centerTitle: false,
        automaticallyImplyLeading: false,
        actions: const [SettingsMenuButton()],
      ),
      body: BlocBuilder<CoachHomeBloc, CoachHomeState>(
        builder: (context, state) {
          if (state is CoachHomeLoading || state is CoachHomeInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CoachHomeError) {
            return _ErrorBody(
              message: state.message,
              onRetry: () => context.read<CoachHomeBloc>().add(
                const CoachHomeLoadRequested(),
              ),
            );
          }

          if (state is! CoachHomeLoaded) {
            return const SizedBox.shrink();
          }

          final fitnessContext = state.context;

          return RefreshIndicator(
            onRefresh: () async {
              context.read<CoachHomeBloc>().add(
                const CoachHomeRefreshRequested(),
              );
              await context.read<CoachHomeBloc>().stream.firstWhere(
                (next) => next is CoachHomeLoaded || next is CoachHomeError,
              );
            },
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
              children: [
                Text(
                  'Your AI coach',
                  style: AppTextStyles.headlineMedium.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Built on your real workout history — smarter coaching starts here.',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 24),
                CoachBriefingCard(context: fitnessContext),
                const SizedBox(height: 24),
                if (fitnessContext.hasActiveSession) ...[
                  FilledButton.icon(
                    onPressed: () => context.go('/rep-tracker'),
                    icon: const Icon(Icons.play_arrow_rounded),
                    label: const Text('Resume workout'),
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(52),
                      backgroundColor: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 12),
                ] else ...[
                  FilledButton.icon(
                    onPressed: () => context.go('/rep-tracker'),
                    icon: const Icon(Icons.fitness_center_outlined),
                    label: const Text('Start workout'),
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(52),
                      backgroundColor: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                OutlinedButton.icon(
                  onPressed: () => context.go('/tabata'),
                  icon: const Icon(Icons.timer_outlined),
                  label: const Text('Open Tabata timer'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                  ),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () => _showComingSoon(context),
                  icon: const Icon(Icons.chat_bubble_outline),
                  label: const Text('Ask coach'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ErrorBody extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorBody({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: colorScheme.error),
            const SizedBox(height: 16),
            Text(
              'Could not load your briefing',
              style: AppTextStyles.titleMedium.copyWith(
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: AppTextStyles.bodyMedium.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            FilledButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}
