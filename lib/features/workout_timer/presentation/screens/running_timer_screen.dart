// =====================================================
// lib/features/workout_timer/presentation/screens/running_timer_screen.dart
// =====================================================
import 'package:app_lifecycle/core/widgets/dialogs/exit_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/timer_bloc.dart';

class RunningTimerScreen extends StatelessWidget {
  const RunningTimerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // Prevents the screen from popping immediately
      onPopInvokedWithResult: (bool didPop, dynamic result) async {
        if (didPop) {
          return;
        }
        final shouldExit = await showExitDialog(context);
        if (shouldExit == true && context.mounted) {
          context.read<TimerBloc>().add(TimerStopped());
          Navigator.of(context).pop();
        }
        return;
      },
      child: Scaffold(
        body: BlocBuilder<TimerBloc, TimerState>(
          builder: (context, state) {
            if (state is TimerFinished) {
              return const Center(
                child: Text(
                  'Workout Complete! 🎉',
                  style: TextStyle(fontSize: 32),
                ),
              );
            }

            if (state is! TimerRunning) {
              return const Center(child: CircularProgressIndicator());
            }

            final s = state;
            final min = (s.remainingSeconds ~/ 60).toString().padLeft(2, '0');
            final sec = (s.remainingSeconds % 60).toString().padLeft(2, '0');

            return Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF00BFA5), Color(0xFF00796B)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    // Header
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                          Text(
                            '${s.currentSet}/${s.totalSets}  •  ${s.currentPhaseName.toUpperCase()}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              s.isPaused ? Icons.play_arrow : Icons.pause,
                              color: Colors.white,
                            ),
                            onPressed: () => context.read<TimerBloc>().add(
                              s.isPaused ? TimerResumed() : TimerPaused(),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Large Timer
                    Expanded(
                      child: Center(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 280,
                              height: 280,
                              child: CircularProgressIndicator(
                                value:
                                    s.remainingSeconds /
                                    s.sequence[s.currentIndex].durationSeconds,
                                strokeWidth: 18,
                                backgroundColor: Colors.white24,
                                valueColor: const AlwaysStoppedAnimation(
                                  Colors.white,
                                ),
                              ),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '$min:$sec',
                                  style: const TextStyle(
                                    fontSize: 78,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                    height: 1,
                                  ),
                                ),
                                Text(
                                  s.currentPhaseName,
                                  style: const TextStyle(
                                    fontSize: 28,
                                    color: Colors.white70,
                                    letterSpacing: 2,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Phase list (scrollable, like your screenshot)
                    Container(
                      height: 240,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ListView.builder(
                        itemCount: s.sequence.length,
                        itemBuilder: (context, i) {
                          final phase = s.sequence[i];
                          final isCurrent = i == s.currentIndex;
                          final isPast = i < s.currentIndex;
                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: isCurrent ? Colors.white : Colors.white10,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  '${i + 1}.',
                                  style: TextStyle(
                                    color: isCurrent
                                        ? Colors.black
                                        : Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    phase.name,
                                    style: TextStyle(
                                      color: isCurrent
                                          ? Colors.black
                                          : Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                Text(
                                  '${phase.durationSeconds}s',
                                  style: TextStyle(
                                    color: isCurrent
                                        ? Colors.black
                                        : Colors.white70,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                if (isPast)
                                  const Icon(
                                    Icons.check,
                                    color: Colors.green,
                                    size: 20,
                                  ),
                                if (isCurrent)
                                  const Icon(
                                    Icons.timer,
                                    color: Colors.teal,
                                    size: 20,
                                  ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),

                    // Bottom controls
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              icon: const Icon(Icons.skip_next),
                              label: const Text('NEXT'),
                              onPressed: () => context.read<TimerBloc>().add(
                                TimerNextPhase(),
                              ),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: FilledButton.icon(
                              icon: const Icon(Icons.stop),
                              label: const Text('STOP'),
                              onPressed: () {
                                context.read<TimerBloc>().add(TimerStopped());
                                Navigator.pop(context);
                              },
                              style: FilledButton.styleFrom(
                                backgroundColor: Colors.redAccent,
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
          },
        ),
      ),
    );
  }
}
