import 'package:fitflow/core/theme/app_colors.dart';
import 'package:fitflow/core/theme/app_text_styles.dart';
import 'package:fitflow/core/widgets/snackbars/app_snackbar.dart';
import 'package:fitflow/core/widgets/snackbars/app_snackbar_type.dart';
import 'package:fitflow/features/auth/domain/entities/user_profile.dart';
import 'package:fitflow/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:fitflow/features/auth/presentation/cubit/auth_state.dart';
import 'package:fitflow/features/auth/presentation/widgets/google_sign_in_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SettingsProfileSection extends StatelessWidget {
  const SettingsProfileSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listenWhen: (previous, current) =>
          current is AuthError ||
          (previous is AuthAuthenticated &&
              current is AuthAuthenticated &&
              previous.profile.isAnonymous &&
              !current.profile.isAnonymous),
      listener: (context, state) {
        if (state is AuthError) {
          AppSnackbar.show(
            context: context,
            title: 'Account update failed',
            message: state.message,
            type: AppSnackbarType.error,
          );
          return;
        }

        if (state is AuthAuthenticated && !state.profile.isAnonymous) {
          AppSnackbar.show(
            context: context,
            title: 'Google linked',
            message: 'Your account is now connected to Google.',
            type: AppSnackbarType.success,
          );
        }
      },
      builder: (context, state) {
        return switch (state) {
          AuthAuthenticated(:final profile) => profile.isAnonymous
              ? _GuestProfileCard(
                  profile: profile,
                  onSignOut: () => context.read<AuthCubit>().signOut(),
                )
              : _SignedInProfileCard(
                  displayName: profile.displayName ?? 'Google user',
                  email: profile.email ?? 'No email',
                  photoUrl: profile.photoUrl,
                  onTap: () => context.push('/settings/profile'),
                  onSignOut: () => context.read<AuthCubit>().signOut(),
                ),
          AuthLoading() => const _ProfileLoadingCard(),
          _ => const _ProfileLoadingCard(),
        };
      },
    );
  }
}

class _GuestProfileCard extends StatelessWidget {
  final UserProfile profile;
  final VoidCallback onSignOut;

  const _GuestProfileCard({
    required this.profile,
    required this.onSignOut,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Material(
          color: theme.cardTheme.color ?? colorScheme.surface,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: colorScheme.onSurface.withValues(alpha: 0.08),
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.12),
                  child: Icon(
                    Icons.person_outline_rounded,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        profile.displayName ?? 'Guest',
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'No email shared',
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontSize: 12,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'Sign out',
                  onPressed: onSignOut,
                  icon: Icon(
                    Icons.logout,
                    size: 20,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Link Google anytime to back up your profile and sync across devices.',
          style: AppTextStyles.bodyMedium.copyWith(
            fontSize: 12,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 12),
        const LinkGoogleAccountButton(),
      ],
    );
  }
}

class _SignedInProfileCard extends StatelessWidget {
  final String displayName;
  final String email;
  final String? photoUrl;
  final VoidCallback onTap;
  final VoidCallback onSignOut;

  const _SignedInProfileCard({
    required this.displayName,
    required this.email,
    required this.photoUrl,
    required this.onTap,
    required this.onSignOut,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Material(
      color: theme.cardTheme.color ?? colorScheme.surface,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: colorScheme.onSurface.withValues(alpha: 0.08),
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.primary.withValues(alpha: 0.12),
                backgroundImage: photoUrl != null && photoUrl!.isNotEmpty
                    ? NetworkImage(photoUrl!)
                    : null,
                child: photoUrl == null || photoUrl!.isEmpty
                    ? Icon(Icons.person, color: AppColors.primary)
                    : null,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayName,
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      email,
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontSize: 12,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Sign out',
                onPressed: onSignOut,
                icon: Icon(
                  Icons.logout,
                  size: 20,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileLoadingCard extends StatelessWidget {
  const _ProfileLoadingCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardTheme.color ?? colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: colorScheme.onSurface.withValues(alpha: 0.08),
          width: 1.5,
        ),
      ),
      child: const Row(
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          SizedBox(width: 14),
          Text('Loading profile...'),
        ],
      ),
    );
  }
}
