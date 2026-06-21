import 'package:fitflow/features/settings/domain/entities/app_theme_mode.dart';
import 'package:fitflow/features/settings/presentation/bloc/theme_bloc/theme_bloc.dart';
import 'package:fitflow/features/settings/presentation/bloc/theme_bloc/theme_event.dart';
import 'package:fitflow/features/settings/presentation/bloc/theme_bloc/theme_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';

class ThemeSelectorBottomSheet extends StatelessWidget {
  const ThemeSelectorBottomSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => BlocProvider.value(
        value: context.read<ThemeBloc>(),
        child: const ThemeSelectorBottomSheet(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        final currentMode = state is ThemeLoaded
            ? state.mode
            : AppThemeMode.system;

        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Appearance',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 24),
              _ThemeOption(
                title: 'System',
                subtitle: 'Follow device settings',
                icon: Icons.brightness_auto,
                mode: AppThemeMode.system,
                isSelected: currentMode == AppThemeMode.system,
              ),
              _ThemeOption(
                title: 'Light',
                subtitle: 'Clean and bright',
                icon: Icons.light_mode,
                mode: AppThemeMode.light,
                isSelected: currentMode == AppThemeMode.light,
              ),
              _ThemeOption(
                title: 'Dark',
                subtitle: 'Easy on the eyes',
                icon: Icons.dark_mode,
                mode: AppThemeMode.dark,
                isSelected: currentMode == AppThemeMode.dark,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ThemeOption extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final AppThemeMode mode;
  final bool isSelected;

  const _ThemeOption({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.mode,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: isSelected ? AppColors.primary : null),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: isSelected
          ? const Icon(Icons.check_circle, color: AppColors.primary)
          : null,
      onTap: () {
        context.read<ThemeBloc>().add(ChangeTheme(mode));
        Navigator.pop(context); // Close sheet
      },
    );
  }
}
