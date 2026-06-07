// lib/core/widgets/settings_menu_button.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsMenuButton extends StatelessWidget {
  const SettingsMenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert),
      color: Theme.of(context).cardColor,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onSelected: (value) {
        if (value == 'settings') {
          context.push('/settings');
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'settings',
          child: Row(
            children: [
              Icon(Icons.settings_outlined, size: 20),
              SizedBox(width: 12),
              Text('Settings'),
            ],
          ),
        ),
      ],
    );
  }
}
