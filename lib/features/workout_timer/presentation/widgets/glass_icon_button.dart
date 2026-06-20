import 'package:flutter/material.dart';

/// A frosted-glass style icon button used throughout the timer screen.
class GlassIconButton extends StatelessWidget {
  const GlassIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.color,
  });

  final IconData icon;
  final VoidCallback onPressed;

  /// Tint applied to the icon. Defaults to surface onSurface at 70% opacity.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.07),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.10),
              width: 0.5,
            ),
          ),
          child: Icon(
            icon,
            color: color ??
                Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            size: 22,
          ),
        ),
      ),
    );
  }
}