import 'package:fitflow/core/theme/app_colors.dart';
import 'package:fitflow/core/theme/app_text_styles.dart';
import 'package:fitflow/features/auth/domain/entities/user_profile.dart';
import 'package:fitflow/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:fitflow/features/auth/presentation/cubit/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: true,
        title: Text('User Profile', style: AppTextStyles.titleLarge),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.5),
          child: Container(
            height: 0.5,
            color: colorScheme.onSurface.withValues(alpha: 0.08),
          ),
        ),
      ),
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          if (state is AuthAuthenticated) {
            return _ProfileDetails(profile: state.profile);
          }

          if (state is AuthLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                'You are not signed in.',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ProfileDetails extends StatelessWidget {
  final UserProfile profile;

  const _ProfileDetails({required this.profile});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final dateFormat = DateFormat('MMM d, yyyy • h:mm a');

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Center(
          child: Column(
            children: [
              CircleAvatar(
                radius: 42,
                backgroundColor: AppColors.primary.withValues(alpha: 0.12),
                backgroundImage: profile.photoUrl != null &&
                        profile.photoUrl!.isNotEmpty
                    ? NetworkImage(profile.photoUrl!)
                    : null,
                child: profile.photoUrl == null || profile.photoUrl!.isEmpty
                    ? Icon(Icons.person, size: 42, color: AppColors.primary)
                    : null,
              ),
              const SizedBox(height: 12),
              Text(
                profile.displayName ?? 'Google user',
                style: AppTextStyles.titleMedium,
              ),
              Text(
                profile.email ?? 'No email',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        _SectionTitle('Account'),
        _ProfileField(label: 'Firebase UID', value: profile.uid),
        _ProfileField(label: 'Google ID', value: profile.googleId ?? '—'),
        _ProfileField(label: 'Email', value: profile.email ?? '—'),
        _ProfileField(
          label: 'Email verified',
          value: profile.emailVerified ? 'Yes' : 'No',
        ),
        _ProfileField(label: 'Phone', value: profile.phoneNumber ?? '—'),
        _ProfileField(label: 'Provider', value: profile.providerId),
        _ProfileField(
          label: 'Anonymous account',
          value: profile.isAnonymous ? 'Yes' : 'No',
        ),
        const SizedBox(height: 16),
        _SectionTitle('Session'),
        _ProfileField(
          label: 'Created',
          value: profile.createdAt != null
              ? dateFormat.format(profile.createdAt!.toLocal())
              : '—',
        ),
        _ProfileField(
          label: 'Last sign-in',
          value: profile.lastSignInAt != null
              ? dateFormat.format(profile.lastSignInAt!.toLocal())
              : '—',
        ),
        _ProfileField(
          label: 'Server auth code',
          value: _maskValue(profile.serverAuthCode),
        ),
        _ProfileField(
          label: 'Access token',
          value: _maskValue(profile.accessToken),
        ),
        _ProfileField(
          label: 'ID token',
          value: _maskValue(profile.idToken),
        ),
        if (profile.linkedProviders.isNotEmpty) ...[
          const SizedBox(height: 16),
          _SectionTitle('Linked providers'),
          ...profile.linkedProviders.map(
            (provider) => _ProviderCard(provider: provider),
          ),
        ],
      ],
    );
  }

  String _maskValue(String? value) {
    if (value == null || value.isEmpty) {
      return '—';
    }
    if (value.length <= 12) {
      return value;
    }
    return '${value.substring(0, 8)}…${value.substring(value.length - 4)}';
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;

  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        text.toUpperCase(),
        style: AppTextStyles.labelSmall.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _ProfileField extends StatelessWidget {
  final String label;
  final String value;

  const _ProfileField({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: theme.cardTheme.color ?? colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: colorScheme.onSurface.withValues(alpha: 0.08),
          width: 1.5,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontSize: 12,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: AppTextStyles.bodyMedium.copyWith(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProviderCard extends StatelessWidget {
  final LinkedProviderInfo provider;

  const _ProviderCard({required this.provider});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardTheme.color ?? colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: colorScheme.onSurface.withValues(alpha: 0.08),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            provider.providerId,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          _ProviderLine('UID', provider.providerUid),
          _ProviderLine('Email', provider.email),
          _ProviderLine('Name', provider.displayName),
          _ProviderLine('Photo', provider.photoUrl),
          _ProviderLine('Phone', provider.phoneNumber),
        ],
      ),
    );
  }
}

class _ProviderLine extends StatelessWidget {
  final String label;
  final String? value;

  const _ProviderLine(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        '$label: ${value ?? '—'}',
        style: AppTextStyles.bodyMedium.copyWith(fontSize: 12),
      ),
    );
  }
}
