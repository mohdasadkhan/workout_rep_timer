import 'dart:async';

import 'package:fitflow/features/workout_timer/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:fitflow/core/widgets/dialogs/exit_dialog.dart';
import 'package:fitflow/features/workout_timer/domain/entity/workout_phase.dart';
import 'package:fitflow/features/workout_timer/presentation/bloc/timer_bloc.dart';
import 'package:fitflow/features/workout_timer/presentation/bloc/timer_effect.dart';
import 'package:fitflow/features/workout_timer/presentation/view_models/timer_view_models.dart';

/// Entry point for the active workout session.
///
/// Responsibilities:
/// - Lock orientation to portrait.
/// - Subscribe to [TimerBloc.effectStream] for one-shot UI side-effects.
/// - Handle back-gesture via [PopScope].
/// - Delegate all visual rendering to focused child widgets.
class RunningTimerScreen extends StatefulWidget {
  const RunningTimerScreen({super.key});

  @override
  State<RunningTimerScreen> createState() => _RunningTimerScreenState();
}

class _RunningTimerScreenState extends State<RunningTimerScreen> {
  late final StreamSubscription<TimerEffect> _effectSub;

  @override
  void initState() {
    super.initState();
    _lockPortrait();

    final bloc = context.read<TimerBloc>();
    _effectSub = bloc.effectStream.listen(_onEffect);
  }

  void _lockPortrait() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  Future<void> _onEffect(TimerEffect effect) async {
    if (effect is ShowStopDialogEffect && mounted) {
      final shouldExit = await showExitDialog(context);
      if (!mounted) return;

      final bloc = context.read<TimerBloc>();
      bloc.add(shouldExit == true ? TimerStopped() : TimerResumed());
    }
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
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: BlocListener<TimerBloc, TimerState>(
          listener: _onStateChange,
          child: const _TimerBody(),
        ),
      ),
    );
  }

  void _onStateChange(BuildContext context, TimerState state) {
    if (state is TimerFinished && context.mounted) {
      // Defer so the build phase isn't interrupted by an overlay push.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) showFinishOverlay(context);
      });
    }

    if (state is TimerInitial && context.mounted) {
      context.pop();
    }
  }
}

/// Builds the full timer UI from BLoC state.
/// Kept as a [StatelessWidget] — all stateful concerns (scroll, orientation)
/// live in their own dedicated widgets.
class _TimerBody extends StatelessWidget {
  const _TimerBody();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerBloc, TimerState>(
      // Only rebuild when the state type changes (Running ↔ Initial).
      // Inner BlocSelectors handle fine-grained updates.
      buildWhen: (prev, curr) => curr.runtimeType != prev.runtimeType,
      builder: (context, state) {
        if (state is! TimerRunning) {
          return const Center(child: CircularProgressIndicator());
        }

        return Stack(
          children: [
            // Ambient color blobs — self-contained, self-selecting from BLoC.
            const TimerAmbientBackground(),

            SafeArea(
              child: Column(
                children: [
                  // ── Top bar ──────────────────────────────────────────────
                  BlocSelector<TimerBloc, TimerState, TopBarViewModel>(
                    selector: (s) {
                      if (s is! TimerRunning) return const TopBarViewModel.empty();
                      return TopBarViewModel(
                        currentSet: s.currentSet,
                        totalSets: s.totalSets,
                        isPaused: s.isPaused,
                        color: s.sequence[s.currentIndex].color,
                      );
                    },
                    builder: (_, data) => TimerTopBar(
                      data: data,
                      bloc: context.read<TimerBloc>(),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ── Phase badge ──────────────────────────────────────────
                  BlocSelector<TimerBloc, TimerState, WorkoutPhase?>(
                    selector: (s) =>
                        s is TimerRunning ? s.sequence[s.currentIndex] : null,
                    builder: (_, phase) {
                      if (phase == null) return const SizedBox.shrink();
                      return RepaintBoundary(
                        child: TimerPhaseBadge(
                          key: ValueKey(phase.name),
                          label: phase.name.toUpperCase(),
                          color: phase.color,
                        ),
                      );
                    },
                  ),

                  // ── Countdown circle ─────────────────────────────────────
                  Expanded(
                    flex: 5,
                    child: Center(
                      child: BlocSelector<TimerBloc, TimerState,
                          TimerCircleViewModel>(
                        selector: (s) {
                          if (s is! TimerRunning) {
                            return const TimerCircleViewModel.empty();
                          }
                          final phase = s.sequence[s.currentIndex];
                          return TimerCircleViewModel(
                            remainingSeconds: s.remainingSeconds,
                            totalDuration: phase.durationSeconds,
                            phaseColor: phase.color,
                            isPaused: s.isPaused,
                          );
                        },
                        builder: (_, data) => TimerCircle(data: data),
                      ),
                    ),
                  ),

                  // ── Sequence list (auto-scrolls to active phase) ─────────
                  Expanded(
                    flex: 4,
                    child: BlocSelector<TimerBloc, TimerState,
                        SequenceViewModel>(
                      selector: (s) {
                        if (s is! TimerRunning) {
                          return const SequenceViewModel.empty();
                        }
                        return SequenceViewModel(
                          sequence: s.sequence,
                          currentIndex: s.currentIndex,
                          remainingSeconds: s.remainingSeconds,
                        );
                      },
                      builder: (_, data) => TimerSequenceList(data: data),
                    ),
                  ),

                  // ── Bottom buttons ───────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    child: TimerBottomButtons(
                      onNext: () =>
                          context.read<TimerBloc>().add(TimerNextPhase()),
                      onStop: () =>
                          context.read<TimerBloc>().add(TimerStopRequestedEvent()),
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