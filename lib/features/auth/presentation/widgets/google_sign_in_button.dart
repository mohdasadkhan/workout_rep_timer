import 'package:fitflow/core/theme/app_colors.dart';
import 'package:fitflow/core/theme/app_text_styles.dart';
import 'package:fitflow/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:fitflow/features/auth/presentation/cubit/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GoogleSignInButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const GoogleSignInButton({
    super.key,
    this.label = 'Sign in with Google',
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final isLoading = state is AuthLoading;

        return SizedBox(
          width: double.infinity,
          height: 54,
          child: FilledButton.icon(
            onPressed: isLoading
                ? null
                : (onPressed ?? () => context.read<AuthCubit>().signInWithGoogle()),
            icon: isLoading
                ? SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: colorScheme.onPrimary,
                    ),
                  )
                : const Icon(
                    Icons.login_rounded,
                    size: 20,
                    color: Colors.white,
                  ),
            label: Text(
              isLoading ? 'Signing in...' : label,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onPrimary,
              ),
            ),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        );
      },
    );
  }
}

class AnonymousSignInButton extends StatelessWidget {
  const AnonymousSignInButton({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final isLoading = state is AuthLoading;

        return SizedBox(
          width: double.infinity,
          height: 54,
          child: OutlinedButton.icon(
            onPressed: isLoading
                ? null
                : () => context.read<AuthCubit>().signInAnonymously(),
            icon: Icon(
              Icons.person_outline_rounded,
              size: 20,
              color: colorScheme.onSurface,
            ),
            label: Text(
              isLoading ? 'Please wait...' : 'Continue without email',
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                color: colorScheme.onSurface.withValues(alpha: 0.16),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        );
      },
    );
  }
}

class LinkGoogleAccountButton extends StatelessWidget {
  const LinkGoogleAccountButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GoogleSignInButton(
      label: 'Continue with Google',
      onPressed: () => context.read<AuthCubit>().linkGoogleAccount(),
    );
  }
}
