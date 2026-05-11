import 'dart:async';
import 'dart:math' as math;

import 'package:app_lifecycle/core/theme/app_colors.dart';
import 'package:app_lifecycle/core/theme/app_text_styles.dart';
import 'package:app_lifecycle/core/widgets/dialogs/exit_dialog.dart';
import 'package:app_lifecycle/features/workout_timer/domain/entity/workout_phase.dart';
import 'package:app_lifecycle/features/workout_timer/presentation/bloc/timer_effect.dart';
import 'package:app_lifecycle/features/workout_timer/presentation/widgets/finish_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/timer_bloc.dart';

class RunningTimerScreen extends StatefulWidget {
  const RunningTimerScreen({super.key});

  @override
  State<RunningTimerScreen> createState() => _RunningTimerScreenState();
}

class _RunningTimerScreenState extends State<RunningTimerScreen>
    with TickerProviderStateMixin {
  late final StreamSubscription _effectSub;
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.97, end: 1.03).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    final bloc = context.read<TimerBloc>();
    _effectSub = bloc.effectStream.listen((effect) async {
      if (effect is ShowStopDialogEffect && mounted) {
        final shouldExit = await showExitDialog(context);
        if (mounted) {
          if (shouldExit == true) {
            bloc.add(TimerStopped());
          } else {
            bloc.add(TimerResumed());
          }
        }
      }
    });
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    _effectSub.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final shouldExit = await showExitDialog(context);
        if (shouldExit == true && context.mounted) {
          context.read<TimerBloc>().add(TimerStopped());
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: BlocListener<TimerBloc, TimerState>(
          listener: (context, state) {
            if (state is TimerFinished && context.mounted) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (context.mounted) showFinishOverlay(context);
              });
            }
            if (state is TimerInitial && context.mounted) {
              context.pop();
            }
          },
          child: BlocBuilder<TimerBloc, TimerState>(
            builder: (context, state) {
              if (state is! TimerRunning) {
                return const Center(child: CircularProgressIndicator());
              }
              final s = state;
              final currentPhase = s.sequence[s.currentIndex];
              final phaseColor = currentPhase.color;

              return Stack(
                children: [
                  Positioned(
                    top: -100,
                    left: -80,
                    child: RepaintBoundary(
                      child: _AmbientGlow(color: phaseColor, size: 400),
                    ),
                  ),
                  Positioned(
                    bottom: -80,
                    right: -60,
                    child: RepaintBoundary(
                      child: _AmbientGlow(
                        color: phaseColor.withOpacity(0.4),
                        size: 300,
                      ),
                    ),
                  ),

                  SafeArea(
                    child: Column(
                      children: [
                        _TopBar(
                          currentSet: s.currentSet,
                          totalSets: s.totalSets,
                          phaseColor: phaseColor,
                          isPaused: s.isPaused,
                        ),

                        const SizedBox(height: 12),

                        RepaintBoundary(
                          child: _PhaseBadge(
                            key: ValueKey(s.currentIndex),
                            label: currentPhase.name.toUpperCase(),
                            color: phaseColor,
                          ),
                        ),

                        Expanded(
                          flex: 5,
                          child: Center(
                            child: TimerCircle(
                              remainingSeconds: s.remainingSeconds,
                              totalDuration: currentPhase.durationSeconds,
                              phaseColor: phaseColor,
                              isPaused: s.isPaused,
                              pulseAnimation: _pulseAnimation,
                            ),
                          ),
                        ),

                        Expanded(
                          flex: 4,
                          child: _SequenceList(
                            sequence: s.sequence,
                            currentIndex: s.currentIndex,
                            remainingSeconds: s.remainingSeconds,
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                          child: _BottomButtons(
                            onNext: () =>
                                context.read<TimerBloc>().add(TimerNextPhase()),
                            onStop: () => context.read<TimerBloc>().add(
                              TimerStopRequestedEvent(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

// ====================== PERFORMANCE ISOLATED WIDGETS ======================

class TimerCircle extends StatelessWidget {
  final int remainingSeconds;
  final int totalDuration;
  final Color phaseColor;
  final bool isPaused;
  final Animation<double> pulseAnimation;

  const TimerCircle({
    super.key,
    required this.remainingSeconds,
    required this.totalDuration,
    required this.phaseColor,
    required this.isPaused,
    required this.pulseAnimation,
  });

  @override
  Widget build(BuildContext context) {
    final min = (remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final sec = (remainingSeconds % 60).toString().padLeft(2, '0');
    final progress = totalDuration > 0 ? remainingSeconds / totalDuration : 0.0;

    return ScaleTransition(
      scale: isPaused ? const AlwaysStoppedAnimation(1.0) : pulseAnimation,
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
                  color: phaseColor,
                  trackColor: phaseColor.withOpacity(0.12),
                  strokeWidth: 14,
                  glowColor: phaseColor,
                ),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 220),
                  transitionBuilder: (child, animation) {
                    final scale = TweenSequence([
                      TweenSequenceItem(
                        tween: Tween(begin: 0.9, end: 1.05),
                        weight: 60,
                      ),
                      TweenSequenceItem(
                        tween: Tween(begin: 1.05, end: 1.0),
                        weight: 40,
                      ),
                    ]).animate(animation);
                    return FadeTransition(
                      opacity: animation,
                      child: ScaleTransition(scale: scale, child: child),
                    );
                  },
                  child: Text(
                    '$min:$sec',
                    key: ValueKey(remainingSeconds),
                    style: AppTextStyles.timerDisplay.copyWith(
                      shadows: [
                        Shadow(
                          color: phaseColor.withOpacity(0.7),
                          blurRadius: 30,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${totalDuration}s total',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  final int currentSet;
  final int totalSets;
  final Color phaseColor;
  final bool isPaused;

  const _TopBar({
    super.key,
    required this.currentSet,
    required this.totalSets,
    required this.phaseColor,
    required this.isPaused,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
      child: Row(
        children: [
          _GlassIconButton(
            icon: Icons.close_rounded,
            onPressed: () =>
                context.read<TimerBloc>().add(TimerStopRequestedEvent()),
          ),
          const Spacer(),
          Row(
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
                      ? phaseColor.withOpacity(0.5)
                      : isCurrent
                      ? phaseColor
                      : Colors.white12,
                  borderRadius: BorderRadius.circular(5),
                ),
              );
            }),
          ),
          const Spacer(),
          _GlassIconButton(
            icon: isPaused ? Icons.play_arrow_rounded : Icons.pause_rounded,
            onPressed: () => context.read<TimerBloc>().add(
              isPaused ? TimerResumed() : TimerPaused(),
            ),
            color: phaseColor,
          ),
        ],
      ),
    );
  }
}

class _SequenceList extends StatelessWidget {
  final List<WorkoutPhase> sequence;
  final int currentIndex;
  final int remainingSeconds;

  const _SequenceList({
    super.key,
    required this.sequence,
    required this.currentIndex,
    required this.remainingSeconds,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 10),
            child: Text(
              'SEQUENCE',
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: sequence.length,
              cacheExtent: 1000,
              itemBuilder: (context, i) {
                final phase = sequence[i];
                final isCurrent = i == currentIndex;
                final isPast = i < currentIndex;
                final progress = isCurrent && phase.durationSeconds > 0
                    ? remainingSeconds / phase.durationSeconds
                    : 0.0;

                return _SequenceItem(
                  key: ValueKey(i),
                  phase: phase,
                  isCurrent: isCurrent,
                  isPast: isPast,
                  progress: progress,
                  sequenceIndex: i,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SequenceItem extends StatelessWidget {
  final WorkoutPhase phase;
  final bool isCurrent;
  final bool isPast;
  final double progress;
  final int sequenceIndex;

  const _SequenceItem({
    super.key,
    required this.phase,
    required this.isCurrent,
    required this.isPast,
    required this.progress,
    required this.sequenceIndex,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isCurrent
              ? phase.color.withOpacity(0.15)
              : Colors.white.withOpacity(0.04),
          borderRadius: BorderRadius.circular(14),
          border: isCurrent
              ? Border.all(color: phase.color.withOpacity(0.5), width: 1)
              : null,
        ),
        child: Row(
          children: [
            SizedBox(
              width: 28,
              child: isPast
                  ? Icon(
                      Icons.check_circle_rounded,
                      size: 18,
                      color: phase.color.withOpacity(0.6),
                    )
                  : Text(
                      '${sequenceIndex + 1}',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: isCurrent
                            ? phase.color
                            : Colors.white.withOpacity(0.25),
                      ),
                    ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                phase.name,
                style: AppTextStyles.sequenceItem.copyWith(
                  fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w400,
                  color: isCurrent
                      ? AppColors.textPrimary
                      : (isPast
                            ? AppColors.textTertiary
                            : AppColors.textSecondary),
                ),
              ),
            ),
            Row(
              children: [
                if (isCurrent)
                  Container(
                    margin: const EdgeInsets.only(right: 8),
                    width: 48,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white12,
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: progress.clamp(0.0, 1.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: phase.color,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ),
                Text(
                  '${phase.durationSeconds}s',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isCurrent
                        ? phase.color
                        : Colors.white.withOpacity(0.3),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomButtons extends StatelessWidget {
  final VoidCallback onNext;
  final VoidCallback onStop;

  const _BottomButtons({super.key, required this.onNext, required this.onStop});

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
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
          ),
        ),
      ],
    );
  }
}

// Existing helper widgets (unchanged)
class _AmbientGlow extends StatelessWidget {
  final Color color;
  final double size;
  const _AmbientGlow({super.key, required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color.withOpacity(0.18), Colors.transparent],
        ),
      ),
    );
  }
}

class _PhaseBadge extends StatelessWidget {
  final String label;
  final Color color;
  const _PhaseBadge({super.key, required this.label, required this.color});

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
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w800,
          color: Colors.white,
          letterSpacing: 2.5,
        ),
      ),
    );
  }
}

class _GlassIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color? color;

  const _GlassIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.color,
  });

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
            color: Colors.white.withOpacity(0.07),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
              width: 0.5,
            ),
          ),
          child: Icon(icon, color: color ?? Colors.white70, size: 22),
        ),
      ),
    );
  }
}

class _ArcPainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color trackColor;
  final double strokeWidth;
  final Color glowColor;

  const _ArcPainter({
    required this.progress,
    required this.color,
    required this.trackColor,
    required this.strokeWidth,
    required this.glowColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    const startAngle = -math.pi / 2;

    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = trackColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round,
    );

    if (progress <= 0) return;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      2 * math.pi * progress,
      false,
      Paint()
        ..color = glowColor.withOpacity(0.35)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth + 8
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10),
    );

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      2 * math.pi * progress,
      false,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_ArcPainter old) =>
      old.progress != progress ||
      old.color != color ||
      old.trackColor != trackColor;
}
