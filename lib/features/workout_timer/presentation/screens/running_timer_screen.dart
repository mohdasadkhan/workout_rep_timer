import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:app_lifecycle/core/theme/app_colors.dart';
import 'package:app_lifecycle/core/theme/app_text_styles.dart';
import 'package:app_lifecycle/core/widgets/dialogs/exit_dialog.dart';
import 'package:app_lifecycle/features/workout_timer/domain/entity/workout_phase.dart';
import 'package:app_lifecycle/features/workout_timer/presentation/bloc/timer_bloc.dart';
import 'package:app_lifecycle/features/workout_timer/presentation/bloc/timer_effect.dart';
import 'package:app_lifecycle/features/workout_timer/presentation/widgets/finish_overlay.dart';

class RunningTimerScreen extends StatefulWidget {
  const RunningTimerScreen({super.key});

  @override
  State<RunningTimerScreen> createState() => _RunningTimerScreenState();
}

class _RunningTimerScreenState extends State<RunningTimerScreen> {
  late final StreamSubscription _effectSub;

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    final bloc = context.read<TimerBloc>();

    _effectSub = bloc.effectStream.listen((effect) async {
      if (effect is ShowStopDialogEffect && mounted) {
        final shouldExit = await showExitDialog(context);

        if (!mounted) return;

        if (shouldExit == true) {
          bloc.add(TimerStopped());
        } else {
          bloc.add(TimerResumed());
        }
      }
    });
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    _effectSub.cancel();
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
                if (context.mounted) {
                  showFinishOverlay(context);
                }
              });
            }

            if (state is TimerInitial && context.mounted) {
              context.pop();
            }
          },
          child: const _RunningTimerBody(),
        ),
      ),
    );
  }
}

class _RunningTimerBody extends StatelessWidget {
  const _RunningTimerBody();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerBloc, TimerState>(
      buildWhen: (previous, current) {
        return current is TimerRunning || current is TimerInitial;
      },
      builder: (context, state) {
        if (state is! TimerRunning) {
          return const Center(child: CircularProgressIndicator());
        }

        final currentPhase = state.sequence[state.currentIndex];
        final phaseColor = currentPhase.color;

        return Stack(
          children: [
            Positioned(
              top: -80,
              left: -60,
              child: RepaintBoundary(
                child: _AmbientGlow(
                  color: phaseColor.withOpacity(0.12),
                  size: 240,
                ),
              ),
            ),

            Positioned(
              bottom: -60,
              right: -40,
              child: RepaintBoundary(
                child: _AmbientGlow(
                  color: phaseColor.withOpacity(0.08),
                  size: 180,
                ),
              ),
            ),

            SafeArea(
              child: Column(
                children: [
                  BlocSelector<TimerBloc, TimerState, _TopBarData>(
                    selector: (state) {
                      if (state is! TimerRunning) {
                        return const _TopBarData.empty();
                      }

                      return _TopBarData(
                        currentSet: state.currentSet,
                        totalSets: state.totalSets,
                        isPaused: state.isPaused,
                        color: state.sequence[state.currentIndex].color,
                      );
                    },
                    builder: (_, data) {
                      return _TopBar(
                        currentSet: data.currentSet,
                        totalSets: data.totalSets,
                        isPaused: data.isPaused,
                        phaseColor: data.color,
                      );
                    },
                  ),

                  const SizedBox(height: 12),

                  BlocSelector<TimerBloc, TimerState, WorkoutPhase?>(
                    selector: (state) {
                      if (state is! TimerRunning) return null;
                      return state.sequence[state.currentIndex];
                    },
                    builder: (_, phase) {
                      if (phase == null) {
                        return const SizedBox.shrink();
                      }

                      return RepaintBoundary(
                        child: _PhaseBadge(
                          key: ValueKey(phase.name),
                          label: phase.name.toUpperCase(),
                          color: phase.color,
                        ),
                      );
                    },
                  ),

                  Expanded(
                    flex: 5,
                    child: Center(
                      child:
                          BlocSelector<TimerBloc, TimerState, _TimerCircleData>(
                            selector: (state) {
                              if (state is! TimerRunning) {
                                return const _TimerCircleData.empty();
                              }

                              final phase = state.sequence[state.currentIndex];

                              return _TimerCircleData(
                                remainingSeconds: state.remainingSeconds,
                                totalDuration: phase.durationSeconds,
                                phaseColor: phase.color,
                                isPaused: state.isPaused,
                              );
                            },
                            builder: (_, data) {
                              return TimerCircle(
                                remainingSeconds: data.remainingSeconds,
                                totalDuration: data.totalDuration,
                                phaseColor: data.phaseColor,
                                isPaused: data.isPaused,
                              );
                            },
                          ),
                    ),
                  ),

                  Expanded(
                    flex: 4,
                    child: BlocSelector<TimerBloc, TimerState, _SequenceData>(
                      selector: (state) {
                        if (state is! TimerRunning) {
                          return const _SequenceData.empty();
                        }

                        return _SequenceData(
                          sequence: state.sequence,
                          currentIndex: state.currentIndex,
                          remainingSeconds: state.remainingSeconds,
                        );
                      },
                      builder: (_, data) {
                        return _SequenceList(
                          sequence: data.sequence,
                          currentIndex: data.currentIndex,
                          remainingSeconds: data.remainingSeconds,
                        );
                      },
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    child: _BottomButtons(
                      onNext: () {
                        context.read<TimerBloc>().add(TimerNextPhase());
                      },
                      onStop: () {
                        context.read<TimerBloc>().add(
                          TimerStopRequestedEvent(),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class TimerCircle extends StatelessWidget {
  const TimerCircle({
    super.key,
    required this.remainingSeconds,
    required this.totalDuration,
    required this.phaseColor,
    required this.isPaused,
  });

  final int remainingSeconds;
  final int totalDuration;
  final Color phaseColor;
  final bool isPaused;

  @override
  Widget build(BuildContext context) {
    final minutes = (remainingSeconds ~/ 60).toString().padLeft(2, '0');

    final seconds = (remainingSeconds % 60).toString().padLeft(2, '0');

    final progress = totalDuration <= 0
        ? 0.0
        : remainingSeconds / totalDuration;

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
                  color: phaseColor,
                  trackColor: phaseColor.withOpacity(0.10),
                  strokeWidth: 12,
                ),
              ),
            ),

            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.98, end: 1.0),
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              builder: (_, scale, child) {
                return Transform.scale(scale: scale, child: child);
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$minutes:$seconds',
                    style: AppTextStyles.timerDisplay.copyWith(
                      color: Colors.white,

                      shadows: [
                        Shadow(
                          color: phaseColor.withOpacity(0.25),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 6),

                  AnimatedOpacity(
                    opacity: isPaused ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    child: Text(
                      'PAUSED',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: phaseColor,
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
  _ArcPainter({
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

    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;

    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;

    canvas.drawArc(rect, -math.pi / 2, math.pi * 2, false, trackPaint);

    canvas.drawArc(
      rect,
      -math.pi / 2,
      math.pi * 2 * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _ArcPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}

class _AmbientGlow extends StatelessWidget {
  const _AmbientGlow({required this.color, required this.size});

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

class _TopBarData {
  final int currentSet;
  final int totalSets;
  final bool isPaused;
  final Color color;

  const _TopBarData({
    required this.currentSet,
    required this.totalSets,
    required this.isPaused,
    required this.color,
  });

  const _TopBarData.empty()
    : currentSet = 0,
      totalSets = 0,
      isPaused = false,
      color = Colors.white;
}

class _TimerCircleData {
  final int remainingSeconds;
  final int totalDuration;
  final Color phaseColor;
  final bool isPaused;

  const _TimerCircleData({
    required this.remainingSeconds,
    required this.totalDuration,
    required this.phaseColor,
    required this.isPaused,
  });

  const _TimerCircleData.empty()
    : remainingSeconds = 0,
      totalDuration = 0,
      phaseColor = Colors.white,
      isPaused = false;
}

class _SequenceData {
  final List<WorkoutPhase> sequence;
  final int currentIndex;
  final int remainingSeconds;

  const _SequenceData({
    required this.sequence,
    required this.currentIndex,
    required this.remainingSeconds,
  });

  const _SequenceData.empty()
    : sequence = const [],
      currentIndex = 0,
      remainingSeconds = 0;
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
