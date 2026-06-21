import 'package:flutter/material.dart';
import 'package:fitflow/core/theme/app_colors.dart';

/// NEXT and STOP action buttons shown at the bottom of the timer screen.
class TimerBottomButtons extends StatelessWidget {
  const TimerBottomButtons({
    super.key,
    required this.onNext,
    required this.onStop,
  });

  final VoidCallback onNext;
  final VoidCallback onStop;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            icon: const Icon(Icons.skip_next_rounded),
            label: const Text('NEXT'),
            onPressed: onNext,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: FilledButton.icon(
            icon: const Icon(Icons.stop_rounded),
            label: const Text('STOP'),
            onPressed: onStop,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
          ),
        ),
      ],
    );
  }
}