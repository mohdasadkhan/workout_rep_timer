import 'package:flutter/material.dart';

/// Pill-shaped badge showing the current phase name (e.g. "WORK", "REST").
class TimerPhaseBadge extends StatelessWidget {
  const TimerPhaseBadge({
    super.key,
    required this.label,
    required this.color,
  });

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 7),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w800,
          color: color,
          letterSpacing: 2.5,
        ),
      ),
    );
  }
}