import 'package:fitflow/core/theme/app_colors.dart';
import 'package:fitflow/core/theme/app_text_styles.dart';
import 'package:fitflow/core/widgets/snackbars/app_snackbar.dart';
import 'package:fitflow/core/widgets/snackbars/app_snackbar_type.dart';
import 'package:fitflow/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:fitflow/features/auth/presentation/cubit/auth_state.dart';
import 'package:fitflow/features/auth/presentation/widgets/google_sign_in_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return BlocListener<AuthCubit, AuthState>(
      listenWhen: (previous, current) => current is AuthError,
      listener: (context, state) {
        if (state is AuthError) {
          AppSnackbar.show(
            context: context,
            title: 'Sign-in failed',
            message: state.message,
            type: AppSnackbarType.error,
          );
        }
      },
      child: Scaffold(
        body: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? [
                      AppColors.background,
                      AppColors.surface,
                      AppColors.primaryDark.withValues(alpha: 0.35),
                    ]
                  : [
                      Colors.white,
                      AppColors.primaryLight.withValues(alpha: 0.35),
                      AppColors.primary.withValues(alpha: 0.12),
                    ],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
              child: Column(
                children: [
                  const Spacer(flex: 2),
                  _BrandHeader(colorScheme: colorScheme),
                  const SizedBox(height: 28),
                  Text(
                    'Train smarter with Tabata timing, rep tracking, and your personal AI coach — all in one place.',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 32),
                  const _FeatureHighlights(),
                  const Spacer(flex: 3),
                  BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, state) {
                      if (state is AuthInitial) {
                        return const _SigningInPlaceholder();
                      }

                      return Column(
                        children: [
                          const GoogleSignInButton(
                            label: 'Sign in with Google',
                          ),
                          const SizedBox(height: 12),
                          const AnonymousSignInButton(),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Use Google to sync across devices, or continue privately without sharing your email.',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontSize: 12,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BrandHeader extends StatelessWidget {
  final ColorScheme colorScheme;

  const _BrandHeader({required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 88,
          height: 88,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                AppColors.primary,
                AppColors.primary.withValues(alpha: 0.72),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.28),
                blurRadius: 28,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: const Icon(
            Icons.fitness_center_rounded,
            size: 42,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 22),
        Text(
          'FitFlow',
          style: AppTextStyles.headlineLarge.copyWith(
            color: colorScheme.onSurface,
            letterSpacing: -1.2,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'YOUR FITNESS COMPANION',
          style: AppTextStyles.labelLarge.copyWith(
            color: AppColors.primary,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}

class _FeatureHighlights extends StatelessWidget {
  const _FeatureHighlights();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        _FeatureRow(
          icon: Icons.timer_outlined,
          title: 'Tabata timer',
          subtitle: 'Survives background and screen-off',
          colorScheme: colorScheme,
        ),
        const SizedBox(height: 10),
        _FeatureRow(
          icon: Icons.fitness_center_outlined,
          title: 'Rep tracker',
          subtitle: 'Log sets and auto-detect PRs',
          colorScheme: colorScheme,
        ),
        const SizedBox(height: 10),
        _FeatureRow(
          icon: Icons.auto_awesome_outlined,
          title: 'AI coach',
          subtitle: 'Briefings built from your history',
          colorScheme: colorScheme,
        ),
      ],
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final ColorScheme colorScheme;

  const _FeatureRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: colorScheme.surface.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.onSurface.withValues(alpha: 0.08),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primary, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  subtitle,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontSize: 12,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SigningInPlaceholder extends StatelessWidget {
  const _SigningInPlaceholder();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: colorScheme.surface.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: colorScheme.onSurface.withValues(alpha: 0.08),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'Checking your account...',
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
