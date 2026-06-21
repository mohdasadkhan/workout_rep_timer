import 'package:flutter/material.dart';
import 'package:fitflow/features/workout_timer/presentation/bloc/timer_bloc.dart';
import 'package:fitflow/features/workout_timer/presentation/view_models/timer_view_models.dart';
import 'package:fitflow/features/workout_timer/presentation/widgets/glass_icon_button.dart';

/// Top bar showing close button, animated set-progress dots, and pause toggle.
class TimerTopBar extends StatelessWidget {
  const TimerTopBar({super.key, required this.data, required this.bloc});

  final TopBarViewModel data;
  final TimerBloc bloc;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
      child: Row(
        children: [
          GlassIconButton(
            icon: Icons.close_rounded,
            onPressed: () => bloc.add(TimerStopRequestedEvent()),
          ),
          const Spacer(),
          _SetProgressDots(
            currentSet: data.currentSet,
            totalSets: data.totalSets,
            color: data.color,
          ),
          const Spacer(),
          GlassIconButton(
            icon: data.isPaused
                ? Icons.play_arrow_rounded
                : Icons.pause_rounded,
            onPressed: () => bloc.add(
              data.isPaused ? TimerResumed() : TimerPaused(),
            ),
            color: data.color,
          ),
        ],
      ),
    );
  }
}

class _SetProgressDots extends StatelessWidget {
  const _SetProgressDots({
    required this.currentSet,
    required this.totalSets,
    required this.color,
  });

  final int currentSet;
  final int totalSets;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(totalSets, (i) {
        final isCurrent = i + 1 == currentSet;
        final isPast = i + 1 < currentSet;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: isCurrent ? 28 : 10,
          height: 10,
          decoration: BoxDecoration(
            color: isPast
                ? color.withOpacity(0.5)
                : isCurrent
                    ? color
                    : Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.12),
            borderRadius: BorderRadius.circular(5),
          ),
        );
      }),
    );
  }
}