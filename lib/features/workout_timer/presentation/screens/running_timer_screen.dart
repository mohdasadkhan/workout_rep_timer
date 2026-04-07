import 'dart:async';
import 'dart:math' as math;

import 'package:app_lifecycle/core/widgets/dialogs/exit_dialog.dart';
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
  late final AnimationController _progressController;
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

    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    final bloc = context.read<TimerBloc>();

    _effectSub = bloc.effectStream.listen((effect) async {
      if (effect is ShowStopDialogEffect) {
        if (!mounted) return;

        final shouldExit = await showExitDialog(context);

        if (!mounted) return;

        if (shouldExit == true) {
          bloc.add(TimerStopped());
        } else {
          bloc.add(TimerResumed()); // resume if user cancels
        }
      }
    });
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    _effectSub.cancel();
    _pulseController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  Color _phaseColor(String phaseName) {
    final name = phaseName.toLowerCase();
    if (name.contains('work')) return const Color(0xFF00E5A0);
    if (name.contains('rest')) return const Color(0xFF4FC3F7);
    if (name.contains('prepare')) return const Color(0xFFFFD54F);
    if (name.contains('cool')) return const Color(0xFFCE93D8);
    return const Color(0xFF00E5A0);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic result) async {
        if (didPop) return;
        final shouldExit = await showExitDialog(context);
        if (shouldExit == true && context.mounted) {
          context.read<TimerBloc>().add(TimerStopped());
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF0A0A0F),
        body: BlocListener<TimerBloc, TimerState>(
          listener: (context, state) {
            if (state is TimerInitial) context.pop();
          },
          child: BlocBuilder<TimerBloc, TimerState>(
            builder: (context, state) {
              if (state is TimerFinished) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (context.mounted) showFinishOverlay(context);
                });
              }

              if (state is! TimerRunning) {
                return const Center(child: CircularProgressIndicator());
              }

              final s = state;
              final phaseColor = _phaseColor(s.currentPhaseName);
              final totalDuration = s.sequence[s.currentIndex].durationSeconds;
              final progress = s.remainingSeconds / totalDuration;
              final min = (s.remainingSeconds ~/ 60).toString().padLeft(2, '0');
              final sec = (s.remainingSeconds % 60).toString().padLeft(2, '0');

              return Stack(
                children: [
                  Positioned(
                    top: -100,
                    left: -80,
                    child: _AmbientGlow(color: phaseColor, size: 400),
                  ),
                  Positioned(
                    bottom: -80,
                    right: -60,
                    child: _AmbientGlow(
                      color: phaseColor.withOpacity(0.4),
                      size: 300,
                    ),
                  ),

                  SafeArea(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                          child: Row(
                            children: [
                              _GlassIconButton(
                                icon: Icons.close_rounded,
                                onPressed: () => context.read<TimerBloc>().add(
                                  TimerStopRequestedEvent(),
                                ),
                              ),
                              const Spacer(),

                              Row(
                                children: List.generate(s.totalSets, (i) {
                                  final isCurrent = i + 1 == s.currentSet;
                                  final isPast = i + 1 < s.currentSet;
                                  return AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 3,
                                    ),
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
                                icon: s.isPaused
                                    ? Icons.play_arrow_rounded
                                    : Icons.pause_rounded,
                                onPressed: () => context.read<TimerBloc>().add(
                                  s.isPaused ? TimerResumed() : TimerPaused(),
                                ),
                                color: phaseColor,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 12),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 350),
                          child: _PhaseBadge(
                            key: ValueKey(s.currentPhaseName),
                            label: s.currentPhaseName.toUpperCase(),
                            color: phaseColor,
                          ),
                        ),

                        Expanded(
                          flex: 5,
                          child: Center(
                            child: ScaleTransition(
                              scale: s.isPaused
                                  ? const AlwaysStoppedAnimation(1.0)
                                  : _pulseAnimation,
                              child: SizedBox(
                                width: 260,
                                height: 260,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    CustomPaint(
                                      size: const Size(260, 260),
                                      painter: _ArcPainter(
                                        progress: progress,
                                        color: phaseColor,
                                        trackColor: phaseColor.withOpacity(
                                          0.12,
                                        ),
                                        strokeWidth: 14,
                                        glowColor: phaseColor,
                                      ),
                                    ),

                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        AnimatedSwitcher(
                                          duration: const Duration(
                                            milliseconds: 220,
                                          ),
                                          switchInCurve: Curves.easeOut,
                                          switchOutCurve: Curves.easeIn,
                                          transitionBuilder:
                                              (child, animation) {
                                                final scale = TweenSequence([
                                                  TweenSequenceItem(
                                                    tween: Tween(
                                                      begin: 0.9,
                                                      end: 1.05,
                                                    ),
                                                    weight: 60,
                                                  ),
                                                  TweenSequenceItem(
                                                    tween: Tween(
                                                      begin: 1.05,
                                                      end: 1.0,
                                                    ),
                                                    weight: 40,
                                                  ),
                                                ]).animate(animation);

                                                final fade = CurvedAnimation(
                                                  parent: animation,
                                                  curve: Curves.easeInOut,
                                                );

                                                return FadeTransition(
                                                  opacity: fade,
                                                  child: ScaleTransition(
                                                    scale: scale,
                                                    child: child,
                                                  ),
                                                );
                                              },
                                          child: Text(
                                            '$min:$sec',
                                            key: ValueKey(
                                              '${s.remainingSeconds}',
                                            ),
                                            style: TextStyle(
                                              fontSize: 72,
                                              fontWeight: FontWeight.w900,
                                              color: Colors.white,
                                              letterSpacing: -2,
                                              shadows: [
                                                Shadow(
                                                  color: phaseColor.withOpacity(
                                                    0.7,
                                                  ),
                                                  blurRadius: 30,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          '${totalDuration}s total',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.white.withOpacity(
                                              0.35,
                                            ),
                                            letterSpacing: 1.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                        Expanded(
                          flex: 4,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 4,
                                    bottom: 10,
                                  ),
                                  child: Text(
                                    'SEQUENCE',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white.withOpacity(0.35),
                                      letterSpacing: 2.5,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: s.sequence.length,
                                    itemBuilder: (context, i) {
                                      final phase = s.sequence[i];
                                      final isCurrent = i == s.currentIndex;
                                      final isPast = i < s.currentIndex;
                                      final itemColor = _phaseColor(phase.name);

                                      return AnimatedContainer(
                                        duration: const Duration(
                                          milliseconds: 300,
                                        ),
                                        curve: Curves.easeOut,
                                        margin: const EdgeInsets.only(
                                          bottom: 8,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 14,
                                          vertical: 10,
                                        ),
                                        decoration: BoxDecoration(
                                          color: isCurrent
                                              ? itemColor.withOpacity(0.15)
                                              : Colors.white.withOpacity(0.04),
                                          borderRadius: BorderRadius.circular(
                                            14,
                                          ),
                                          border: isCurrent
                                              ? Border.all(
                                                  color: itemColor.withOpacity(
                                                    0.5,
                                                  ),
                                                  width: 1,
                                                )
                                              : Border.all(
                                                  color: Colors.transparent,
                                                ),
                                        ),
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: 28,
                                              child: isPast
                                                  ? Icon(
                                                      Icons
                                                          .check_circle_rounded,
                                                      size: 18,
                                                      color: itemColor
                                                          .withOpacity(0.6),
                                                    )
                                                  : Text(
                                                      '${i + 1}',
                                                      style: TextStyle(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: isCurrent
                                                            ? itemColor
                                                            : Colors.white
                                                                  .withOpacity(
                                                                    0.25,
                                                                  ),
                                                      ),
                                                    ),
                                            ),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Text(
                                                phase.name,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: isCurrent
                                                      ? FontWeight.w700
                                                      : FontWeight.w400,
                                                  color: isCurrent
                                                      ? Colors.white
                                                      : Colors.white
                                                            .withOpacity(
                                                              isPast
                                                                  ? 0.3
                                                                  : 0.6,
                                                            ),
                                                ),
                                              ),
                                            ),

                                            Row(
                                              children: [
                                                if (isCurrent)
                                                  Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                          right: 8,
                                                        ),
                                                    width: 48,
                                                    height: 4,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white12,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            2,
                                                          ),
                                                    ),
                                                    child: FractionallySizedBox(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      widthFactor: progress,
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                          color: itemColor,
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                2,
                                                              ),
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
                                                        ? itemColor
                                                        : Colors.white
                                                              .withOpacity(0.3),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                          child: Row(
                            children: [
                              Expanded(
                                child: _OutlineActionButton(
                                  icon: Icons.skip_next_rounded,
                                  label: 'NEXT',
                                  color: Colors.white60,
                                  onPressed: () => context
                                      .read<TimerBloc>()
                                      .add(TimerNextPhase()),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                flex: 2,
                                child: _FilledActionButton(
                                  icon: Icons.stop_rounded,
                                  label: 'STOP',
                                  color: const Color(0xFFFF4757),
                                  onPressed: () => context
                                      .read<TimerBloc>()
                                      .add(TimerStopRequestedEvent()),
                                ),
                              ),
                            ],
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

class _AmbientGlow extends StatelessWidget {
  final Color color;
  final double size;
  const _AmbientGlow({required this.color, required this.size});

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

class _GlassIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color? color;
  const _GlassIconButton({
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

class _OutlineActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onPressed;
  const _OutlineActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: OutlinedButton.icon(
        icon: Icon(icon, size: 20),
        label: Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.5,
          ),
        ),
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: color,
          side: BorderSide(color: color.withOpacity(0.3)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }
}

class _FilledActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onPressed;
  const _FilledActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: FilledButton.icon(
        icon: Icon(icon, size: 20),
        label: Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.5,
          ),
        ),
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
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
      old.progress != progress || old.color != color;
}

class AnimatedDigit extends StatelessWidget {
  final String digit;

  const AnimatedDigit(this.digit, {super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      transitionBuilder: (child, animation) {
        final slide = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
            .animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
            );

        return ClipRect(
          child: SlideTransition(position: slide, child: child),
        );
      },
      child: Text(
        digit,
        key: ValueKey(digit),
        style: const TextStyle(
          fontSize: 72,
          fontWeight: FontWeight.w900,
          color: Colors.white,
        ),
      ),
    );
  }
}
