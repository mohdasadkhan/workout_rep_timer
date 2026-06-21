import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:fitflow/core/theme/app_text_styles.dart';
import 'package:fitflow/features/workout_timer/presentation/view_models/timer_view_models.dart';

/// Circular countdown display with an animated arc progress ring.
class TimerCircle extends StatelessWidget {
  const TimerCircle({super.key, required this.data});

  final TimerCircleViewModel data;

  @override
  Widget build(BuildContext context) {
    final minutes =
        (data.remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds =
        (data.remainingSeconds % 60).toString().padLeft(2, '0');
    final progress = data.totalDuration <= 0
        ? 0.0
        : data.remainingSeconds / data.totalDuration;

    return RepaintBoundary(
      child: SizedBox(
        width: 260,
        height: 260,
        child: Stack(
          alignment: Alignment.center,
          children: [
            RepaintBoundary(
              child: CustomPaint(
                size: const Size(260, 260),
                painter: _ArcPainter(
                  progress: progress,
                  color: data.phaseColor,
                  trackColor: data.phaseColor.withOpacity(0.10),
                  strokeWidth: 12,
                ),
              ),
            ),
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.98, end: 1.0),
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              builder: (_, scale, child) =>
                  Transform.scale(scale: scale, child: child),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$minutes:$seconds',
                    style: AppTextStyles.timerDisplay.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                      shadows: [
                        Shadow(
                          color: data.phaseColor.withOpacity(0.25),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  AnimatedOpacity(
                    opacity: data.isPaused ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    child: Text(
                      'PAUSED',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: data.phaseColor,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ArcPainter extends CustomPainter {
  const _ArcPainter({
    required this.progress,
    required this.color,
    required this.trackColor,
    required this.strokeWidth,
  });

  final double progress;
  final Color color;
  final Color trackColor;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    canvas.drawArc(
      rect,
      -math.pi / 2,
      math.pi * 2,
      false,
      Paint()
        ..color = trackColor
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = strokeWidth,
    );

    canvas.drawArc(
      rect,
      -math.pi / 2,
      math.pi * 2 * progress,
      false,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = strokeWidth,
    );
  }

  @override
  bool shouldRepaint(covariant _ArcPainter old) =>
      old.progress != progress || old.color != color;
}