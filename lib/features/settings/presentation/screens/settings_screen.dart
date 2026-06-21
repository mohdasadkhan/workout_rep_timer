import 'package:fitflow/core/di/injection.dart';
import 'package:fitflow/core/services/app_info_service.dart';
import 'package:fitflow/core/theme/app_colors.dart';
import 'package:fitflow/core/theme/app_text_styles.dart';
import 'package:fitflow/core/usecases/usecase.dart';
import 'package:fitflow/core/widgets/snackbars/app_snackbar.dart';
import 'package:fitflow/core/widgets/snackbars/app_snackbar_type.dart';
import 'package:fitflow/features/settings/domain/entities/sound_settings.dart';
import 'package:fitflow/features/settings/domain/usecases/clear_all_data_usecase.dart';
import 'package:fitflow/features/settings/presentation/bloc/sound_settings/sound_settings_bloc.dart';
import 'package:fitflow/features/settings/presentation/widgets/theme_selector_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final appInfo = getIt<AppInfoService>();
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: true,
        title: Text('Settings', style: AppTextStyles.titleLarge),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.5),
          child: Container(
            height: 0.5,
            color: colorScheme.onSurface.withOpacity(0.08),
          ),
        ),
      ),
      body: BlocListener<SoundSettingsBloc, SoundSettingsState>(
        // Surface persistence errors as a non-intrusive snackbar.
        listenWhen: (_, current) => current is SoundSettingsError,
        listener: (context, state) {
          if (state is SoundSettingsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Could not save setting: ${state.message}'),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
          children: [
            _SectionLabel('Preferences'),
            _SettingsTile(
              icon: Icons.brightness_6_outlined,
              title: 'Theme',
              subtitle: 'Light, Dark, or System',
              showChevron: true,
              activeBorder: true,
              onTap: () => ThemeSelectorBottomSheet.show(context),
            ),

            _SectionLabel('Notifications'),
            _SettingsTile(
              icon: Icons.notifications_active_outlined,
              title: 'Workout Reminders',
              subtitle: 'Schedule daily workout reminders',
              showChevron: true,
              activeBorder: true,
              onTap: () => context.push('/reminder-settings'),
            ),

            // ── Sound & Haptics ─────────────────────────────────────────────
            // BlocBuilder scoped only to these two tiles so the rest of the
            // list never rebuilds when toggles change.
            BlocBuilder<SoundSettingsBloc, SoundSettingsState>(
              builder: (context, state) {
                final settings = state is SoundSettingsLoaded
                    ? state.settings
                    : const SoundSettings(
                        soundEnabled: true,
                        hapticEnabled: true,
                      ); // defaults while loading

                return Column(
                  children: [
                    _SettingsTile(
                      icon: Icons.volume_up_outlined,
                      title: 'Timer Sounds',
                      subtitle: 'Beep on last 3 seconds of each phase',
                      trailing: Switch(
                        value: settings.soundEnabled,
                        onChanged: (value) => context
                            .read<SoundSettingsBloc>()
                            .add(ToggleSoundEnabled(value)),
                        activeThumbColor: AppColors.primary,
                        inactiveThumbColor: colorScheme.onSurfaceVariant,
                        inactiveTrackColor: colorScheme.onSurface.withOpacity(
                          0.08,
                        ),
                      ),
                    ),
                    _SettingsTile(
                      icon: Icons.vibration_outlined,
                      title: 'Haptic Feedback',
                      subtitle: 'Vibrate on timer ticks',
                      trailing: Switch(
                        value: settings.hapticEnabled,
                        onChanged: (value) => context
                            .read<SoundSettingsBloc>()
                            .add(ToggleHapticEnabled(value)),
                        activeThumbColor: AppColors.primary,
                        inactiveThumbColor: colorScheme.onSurfaceVariant,
                        inactiveTrackColor: colorScheme.onSurface.withOpacity(
                          0.08,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),

            _SectionLabel('Data'),
            _SettingsTile(
              icon: Icons.backup_outlined,
              title: 'Backup & Sync',
              subtitle: 'Requires Firebase auth',
              badge: const _SoonBadge(),
              disabled: true,
            ),
            _SettingsTile(
              icon: Icons.file_download_outlined,
              title: 'Export Data',
              subtitle: 'Export as CSV',
              badge: const _SoonBadge(),
              disabled: true,
            ),
            _SettingsTile(
              icon: Icons.delete_outline,
              title: 'Clear All Data',
              subtitle: 'Permanently deletes everything',
              warning: true,
              onTap: () => _showClearDataDialog(context),
            ),

            _SectionLabel('Support'),
            _SettingsTile(
              icon: Icons.star_outline,
              title: 'Rate FitFlow',
              subtitle: 'Available after Play Store launch',
              badge: const _SoonBadge(),
              disabled: true,
            ),
            _SettingsTile(
              icon: Icons.feedback_outlined,
              title: 'Send Feedback',
              subtitle: 'Help us improve',
              badge: const _SoonBadge(),
              disabled: true,
            ),
            _SettingsTile(
              icon: Icons.info_outline,
              title: 'About',
              subtitle: appInfo.settingsDisplay,
              showChevron: true,
              onTap: () => _showAboutDialog(context, appInfo),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Future<void> _showClearDataDialog(BuildContext context) async {
    final colorScheme = Theme.of(context).colorScheme;
    final confirmed = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor:
            Theme.of(context).cardTheme.color ?? colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Clear All Data',
          style: AppTextStyles.titleMedium.copyWith(color: AppColors.error),
        ),
        content: Text(
          'This action cannot be undone.\n\nAll workout history, personal records, settings, and active sessions will be permanently deleted.',
          style: AppTextStyles.bodyMedium.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel', style: AppTextStyles.bodyMedium),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              'Clear',
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;

    // Show loading indicator
    final loadingDialog = showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
    );

    try {
      final clearUseCase = getIt<ClearAllDataUseCase>();
      final result = await clearUseCase(NoParams());

      if (context.mounted) {
        Navigator.pop(context); // close loading

        result.fold(
          (failure) {
            AppSnackbar.show(
              context: context,
              title: 'Failed to delete data',
              message: failure.message,
              type: AppSnackbarType.error,
            );
          },
          (_) {
            AppSnackbar.show(
              context: context,
              title: 'Data cleared',
              message: 'All data has been cleared successfully',
              type: AppSnackbarType.success,
            );
          },
        );
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context); // close loading
        AppSnackbar.show(
          context: context,
          title: 'Failed to delete data',
          message: 'Something went wrong',
          type: AppSnackbarType.error,
        );
      }
    }
  }

  // Optional: Add an about dialog
  void _showAboutDialog(BuildContext context, AppInfoService appInfo) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About FitFlow'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'FitFlow helps you crush fitness goals with an intuitive Tabata timer, rep tracker, and smart reminders.',
            ),
            const SizedBox(height: 16),
            Text('Version: ${appInfo.version}'),
            Text('Build: ${appInfo.buildNumber}'),
            Text('Full: ${appInfo.fullVersion}'),
            const SizedBox(height: 16),
            const Text('© 2026 FitFlow'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

// ── Private widgets ──────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, top: 20, bottom: 8),
      child: Text(
        text.toUpperCase(),
        style: AppTextStyles.labelSmall.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _SoonBadge extends StatelessWidget {
  const _SoonBadge();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.warning.withOpacity(0.10),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.warning.withOpacity(0.22)),
      ),
      child: Text(
        'SOON',
        style: AppTextStyles.labelSmall.copyWith(
          fontSize: 9,
          letterSpacing: 1.2,
          color: AppColors.warning,
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final Widget? trailing;
  final Widget? badge;
  final bool showChevron;
  final bool activeBorder;
  final bool warning;
  final bool disabled;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
    this.trailing,
    this.badge,
    this.showChevron = false,
    this.activeBorder = false,
    this.warning = false,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Opacity(
        opacity: disabled ? 0.38 : 1.0,
        child: Material(
          color: theme.cardTheme.color ?? colorScheme.surface,
          borderRadius: BorderRadius.circular(14),
          child: InkWell(
            onTap: disabled ? null : onTap,
            borderRadius: BorderRadius.circular(14),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: activeBorder
                      ? AppColors.primary
                      : colorScheme.onSurface.withOpacity(0.08),
                  width: activeBorder ? 1.5 : 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    icon,
                    size: 20,
                    color: warning
                        ? AppColors.error
                        : activeBorder
                        ? AppColors.primary
                        : colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: warning
                                ? AppColors.error
                                : colorScheme.onSurface,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                        if (subtitle != null)
                          Text(
                            subtitle!,
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontSize: 12,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (badge != null) ...[const SizedBox(width: 8), badge!],
                  if (trailing != null) ...[
                    const SizedBox(width: 6),
                    trailing!,
                  ],
                  if (showChevron)
                    Icon(
                      Icons.chevron_right,
                      color: colorScheme.onSurfaceVariant.withOpacity(0.7),
                      size: 18,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
