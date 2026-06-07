import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:app_lifecycle/core/theme/app_colors.dart';
import 'package:app_lifecycle/core/theme/app_text_styles.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        title: Text('Settings', style: AppTextStyles.titleLarge),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.5),
          child: Container(height: 0.5, color: Colors.white.withOpacity(0.08)),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        children: [
          _SectionLabel('Preferences'),
          _SettingsTile(
            icon: Icons.brightness_6_outlined,
            title: 'Theme',
            subtitle: 'Light, Dark, or System',
            showChevron: true,
            badge: const _SoonBadge(),
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
          _SettingsTile(
            icon: Icons.volume_up_outlined,
            title: 'Timer Sounds',
            subtitle: 'Play sound on timer completion',
            badge: const _SoonBadge(),
            trailing: Switch(
              value: false,
              onChanged: null,
              activeThumbColor: AppColors.primary,
              inactiveThumbColor: AppColors.textTertiary,
              inactiveTrackColor: Colors.white.withOpacity(0.08),
            ),
          ),
          _SettingsTile(
            icon: Icons.vibration_outlined,
            title: 'Haptic Feedback',
            subtitle: 'Vibrate on timer ticks',
            badge: const _SoonBadge(),
            trailing: Switch(
              value: false,
              onChanged: null,
              activeThumbColor: AppColors.primary,
              inactiveThumbColor: AppColors.textTertiary,
              inactiveTrackColor: Colors.white.withOpacity(0.08),
            ),
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
            subtitle: 'Version 1.0.0',
            showChevron: true,
            onTap: () {},
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  void _showClearDataDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Clear All Data', style: AppTextStyles.titleMedium),
        content: Text(
          'This will permanently delete all your workouts, history, and personal records. This action cannot be undone.',
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'Clear',
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, top: 20, bottom: 8),
      child: Text(text.toUpperCase(), style: AppTextStyles.labelSmall),
    );
  }
}

class _SoonBadge extends StatelessWidget {
  const _SoonBadge();

  @override
  Widget build(BuildContext context) {
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Opacity(
        opacity: disabled ? 0.38 : 1.0,
        child: Material(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          child: InkWell(
            onTap: disabled ? null : onTap,
            borderRadius: BorderRadius.circular(14),
            splashColor: AppColors.primary.withOpacity(0.06),
            highlightColor: Colors.white.withOpacity(0.03),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: activeBorder
                      ? AppColors.primary
                      : Colors.white.withOpacity(0.06),
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
                        : AppColors.textTertiary,
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
                                : AppColors.textPrimary,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                        if (subtitle != null) ...[
                          const SizedBox(height: 3),
                          Text(
                            subtitle!,
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontSize: 12,
                              color: warning
                                  ? AppColors.error.withOpacity(0.55)
                                  : AppColors.textTertiary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (badge != null) ...[const SizedBox(width: 8), badge!],
                  if (trailing != null) ...[
                    const SizedBox(width: 6),
                    trailing!,
                  ] else if (showChevron) ...[
                    const SizedBox(width: 6),
                    Icon(
                      Icons.chevron_right,
                      color: AppColors.textTertiary.withOpacity(0.6),
                      size: 18,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
