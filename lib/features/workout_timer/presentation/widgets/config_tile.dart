// =====================================================
// lib/features/workout_timer/presentation/widgets/config_tile.dart
// =====================================================
import 'package:flutter/material.dart';

class ConfigTile extends StatelessWidget {
  final String title;
  final int seconds;
  final int? value; // for non-time fields like cycles/sets
  final bool isNumber;
  final ValueChanged<int> onChanged;

  const ConfigTile({
    super.key,
    required this.title,
    this.seconds = 0,
    this.value,
    this.isNumber = false,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final displayValue = isNumber ? (value ?? 0) : seconds;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.remove_circle_outline),
              onPressed: () => onChanged((displayValue - (isNumber ? 1 : 15)).clamp(0, 999)),
            ),
            SizedBox(
              width: 64,
              child: Text(
                isNumber ? displayValue.toString() : '${displayValue}s',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add_circle_outline),
              onPressed: () => onChanged((displayValue + (isNumber ? 1 : 15)).clamp(0, 999)),
            ),
          ],
        ),
      ),
    );
  }
}