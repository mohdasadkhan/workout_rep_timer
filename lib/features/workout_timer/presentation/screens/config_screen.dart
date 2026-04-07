import 'dart:developer';

import 'package:app_lifecycle/core/widgets/feature_dropdown/extension_on_appfeature.dart';
import 'package:app_lifecycle/core/widgets/feature_dropdown/feature_dropdown.dart';
import 'package:app_lifecycle/features/workout_timer/domain/entity/workout_config.dart';
import 'package:app_lifecycle/features/workout_timer/domain/usecases/generate_workout_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:go_router/go_router.dart';
import '../bloc/timer_bloc.dart';
import '../widgets/config_tile.dart';
import 'running_timer_screen.dart';

class ConfigScreen extends StatefulWidget {
  const ConfigScreen({super.key});

  @override
  State<ConfigScreen> createState() => _ConfigScreenState();
}

class _ConfigScreenState extends State<ConfigScreen> {
  late WorkoutConfig _config;

  @override
  void initState() {
    super.initState();
    _config = const WorkoutConfig();
  }

  void _updateConfig(WorkoutConfig newConfig) {
    setState(() => _config = newConfig);
    context.read<TimerBloc>().add(TimerConfigChanged(newConfig));
  }

  String _formatTotalTime() {
    final sequence = generateWorkoutSequence(_config);
    final totalSeconds = sequence.fold<int>(
      0,
      (sum, phase) => sum + phase.durationSeconds,
    );
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    final totalIntervals = sequence.length;
    return '$minutes:${seconds.toString().padLeft(2, '0')} • $totalIntervals intervals • ${_config.numberOfSets} sets';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FeatureDropdownTitle(current: AppFeature.tabataTimer),
            TextButton.icon(
              onPressed: () => context.push('/tabata/preview', extra: _config),
              icon: const Icon(Icons.visibility_outlined),
              label: const Text('PREVIEW'),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
                textStyle: theme.textTheme.titleMedium,
              ),
            ),
          ],
        ),
        centerTitle: false,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        'TOTAL TIME',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _formatTotalTime(),
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.teal,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            ConfigTile(
              title: 'Prepare',
              seconds: _config.prepareSeconds,
              onChanged: (v) =>
                  _updateConfig(_config.copyWith(prepareSeconds: v)),
            ),
            ConfigTile(
              title: 'Work',
              seconds: _config.workSeconds,
              onChanged: (v) => _updateConfig(_config.copyWith(workSeconds: v)),
            ),
            ConfigTile(
              title: 'Rest (intra-cycle)',
              seconds: _config.restSeconds,
              onChanged: (v) => _updateConfig(_config.copyWith(restSeconds: v)),
            ),
            ConfigTile(
              title: 'Cycles per set',
              isNumber: true,
              value: _config.cyclesPerSet,
              onChanged: (v) =>
                  _updateConfig(_config.copyWith(cyclesPerSet: v)),
            ),
            ConfigTile(
              title: 'Number of sets',
              isNumber: true,
              value: _config.numberOfSets,
              onChanged: (v) =>
                  _updateConfig(_config.copyWith(numberOfSets: v)),
            ),
            ConfigTile(
              title: 'Rest between sets',
              seconds: _config.restBetweenSetsSeconds,
              onChanged: (v) =>
                  _updateConfig(_config.copyWith(restBetweenSetsSeconds: v)),
            ),
            ConfigTile(
              title: 'Cool down',
              seconds: _config.coolDownSeconds,
              onChanged: (v) =>
                  _updateConfig(_config.copyWith(coolDownSeconds: v)),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FilledButton.icon(
            onPressed: () async {
              var permission =
                  await FlutterForegroundTask.checkNotificationPermission();
              log('check notification permission >> $permission');
              if (permission != NotificationPermission.granted) {
                permission =
                    await FlutterForegroundTask.requestNotificationPermission();
                log('request notification permission >> $permission');
                if (permission != NotificationPermission.granted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Notification permission required for background timer',
                      ),
                    ),
                  );
                  return;
                }
              }

              if (!await FlutterForegroundTask.isIgnoringBatteryOptimizations) {
                final ignored =
                    await FlutterForegroundTask.requestIgnoreBatteryOptimization();
                if (!ignored) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Please select "No restrictions" for reliable background timer',
                      ),
                    ),
                  );
                }
              }
              context.read<TimerBloc>().add(TimerStarted(_config));

              context.push('/tabata/running');
            },
            icon: const Icon(Icons.play_arrow),
            label: const Text('START WORKOUT', style: TextStyle(fontSize: 18)),
            style: FilledButton.styleFrom(
              minimumSize: const Size(double.infinity, 56),
              backgroundColor: Colors.teal,
            ),
          ),
        ),
      ),
    );
  }
}
