import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fitflow/features/workout_timer/presentation/bloc/timer_bloc.dart';

/// Decorative ambient glow blobs that change color with the active phase.
/// Wrapped in [RepaintBoundary] so they never trigger parent repaints.
class TimerAmbientBackground extends StatelessWidget {
  const TimerAmbientBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<TimerBloc, TimerState, Color>(
      selector: (state) {
        if (state is! TimerRunning) return Colors.transparent;
        return state.sequence[state.currentIndex].color;
      },
      builder: (_, color) {
        return Stack(
          children: [
            Positioned(
              top: -80,
              left: -60,
              child: RepaintBoundary(
                child: _GlowBlob(color: color.withOpacity(0.12), size: 240),
              ),
            ),
            Positioned(
              bottom: -60,
              right: -40,
              child: RepaintBoundary(
                child: _GlowBlob(color: color.withOpacity(0.08), size: 180),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _GlowBlob extends StatelessWidget {
  const _GlowBlob({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(colors: [color, Colors.transparent]),
        ),
      ),
    );
  }
}