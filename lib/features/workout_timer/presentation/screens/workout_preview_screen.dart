import 'package:app_lifecycle/core/theme/app_colors.dart';
import 'package:app_lifecycle/features/workout_timer/domain/entity/workout_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:timeline_tile/timeline_tile.dart';

import '../../domain/entity/workout_phase.dart';
import '../../domain/usecases/generate_workout_usecase.dart';
import '../bloc/timer_bloc.dart';

class WorkoutPreviewScreen extends StatefulWidget {
  final WorkoutConfig config;

  const WorkoutPreviewScreen({super.key, required this.config});

  @override
  State<WorkoutPreviewScreen> createState() => _WorkoutPreviewScreenState();
}

class _WorkoutPreviewScreenState extends State<WorkoutPreviewScreen> {
  late final ScrollController _scrollController;
  double _scrollProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_updateScrollProgress);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_updateScrollProgress);
    _scrollController.dispose();
    super.dispose();
  }

  void _updateScrollProgress() {
    if (!mounted) return;

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;

    if (maxScroll <= 0) {
      setState(() => _scrollProgress = 1.0);
      return;
    }

    final progress = (currentScroll / maxScroll).clamp(0.0, 1.0);
    setState(() => _scrollProgress = progress);
  }

  @override
  Widget build(BuildContext context) {
    final sequence = generateWorkoutSequence(widget.config);
    final totalTimeStr = _formatTotalTime(sequence, widget.config);

    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Preview'),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: LinearProgressIndicator(
            value: _scrollProgress,
            backgroundColor: Colors.grey.shade200,
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.teal),
            minHeight: 4,
          ),
        ),
      ),
      body: Column(
        children: [
          // Summary Card
          Padding(
            padding: const EdgeInsets.all(16),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      'YOUR WORKOUT FLOW',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      totalTimeStr,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Timeline
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: sequence.length,
              itemBuilder: (context, index) {
                final phase = sequence[index];
                final isLast = index == sequence.length - 1;

                return TimelineTile(
                  alignment: TimelineAlign.manual,
                  lineXY: 0.18,
                  isFirst: index == 0,
                  isLast: isLast,
                  indicatorStyle: IndicatorStyle(
                    width: 34,
                    color: _getPhaseColor(phase.type),
                    iconStyle: IconStyle(
                      iconData: _getPhaseIcon(phase.type),
                      color: AppColors.white,
                    ),
                  ),
                  beforeLineStyle: const LineStyle(
                    color: AppColors.grey,
                    thickness: 3,
                  ),
                  afterLineStyle: LineStyle(
                    color: isLast ? Colors.transparent : AppColors.grey,
                    thickness: 3,
                  ),
                  startChild: Padding(
                    padding: const EdgeInsets.only(right: 16, top: 10),
                    child: Text(
                      _formatDuration(phase.durationSeconds),
                      style: theme.textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  endChild: Padding(
                    padding: const EdgeInsets.only(
                      left: 16,
                      top: 8,
                      bottom: 24,
                    ),
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  _getPhaseIcon(phase.type),
                                  color: _getPhaseColor(phase.type),
                                  size: 26,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    phase.name,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Set ${phase.currentSet} of ${phase.totalSets}',
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontSize: 14,
                              ),
                            ),
                            if (phase.currentCycle != null)
                              Text(
                                'Cycle ${phase.currentCycle} of ${phase.totalCycles}',
                                style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontSize: 14,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FilledButton.icon(
            onPressed: () {
              context.read<TimerBloc>().add(TimerStarted(widget.config));
              context.push('/tabata/running');
            },
            icon: const Icon(Icons.play_arrow, size: 32),
            label: Text(
              'START WORKOUT',

              style: theme.textTheme.titleLarge?.copyWith(letterSpacing: 1.2),
            ),
          ),
        ),
      ),
    );
  }

  // Keep all your helper methods the same
  String _formatDuration(int seconds) {
    final min = seconds ~/ 60;
    final sec = seconds % 60;
    return min > 0 ? '$min:${sec.toString().padLeft(2, '0')}' : '$sec s';
  }

  Color _getPhaseColor(PhaseType type) {
    switch (type) {
      case PhaseType.prepare:
        return Colors.blue;
      case PhaseType.work:
        return Colors.teal;
      case PhaseType.rest:
        return Colors.orange;
      case PhaseType.restBetweenSets:
        return Colors.deepPurple;
      case PhaseType.coolDown:
        return Colors.grey.shade600;
    }
  }

  IconData _getPhaseIcon(PhaseType type) {
    switch (type) {
      case PhaseType.prepare:
        return Icons.timer_outlined;
      case PhaseType.work:
        return Icons.fitness_center;
      case PhaseType.rest:
        return Icons.pause_circle_outline;
      case PhaseType.restBetweenSets:
        return Icons.hourglass_empty;
      case PhaseType.coolDown:
        return Icons.sports_gymnastics;
    }
  }

  String _formatTotalTime(List<WorkoutPhase> sequence, WorkoutConfig config) {
    final totalSeconds = sequence.fold<int>(
      0,
      (sum, p) => sum + p.durationSeconds,
    );
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')} • ${sequence.length} intervals • ${config.numberOfSets} sets';
  }
}
