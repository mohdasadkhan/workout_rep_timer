import 'dart:developer';
import 'dart:io';

import 'package:fitflow/core/theme/app_colors.dart';
import 'package:fitflow/core/theme/app_text_styles.dart';
import 'package:fitflow/core/widgets/feature_dropdown/extension_on_appfeature.dart';
import 'package:fitflow/core/widgets/feature_dropdown/feature_dropdown.dart';
import 'package:fitflow/core/widgets/settings_menu_button.dart';
import 'package:fitflow/core/widgets/snackbars/app_snackbar.dart';
import 'package:fitflow/core/widgets/snackbars/app_snackbar_type.dart';
import 'package:fitflow/features/workout_timer/domain/entity/workout_config.dart';
import 'package:fitflow/features/workout_timer/domain/usecases/generate_workout_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:go_router/go_router.dart';
import '../bloc/timer_bloc.dart';
import '../widgets/config_tile.dart';

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
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const FeatureDropdownTitle(current: AppFeature.tabataTimer),
        centerTitle: false,
        automaticallyImplyLeading: false,
        actions: [
          TextButton.icon(
            onPressed: () => context.push('/tabata/preview', extra: _config),
            icon: const Icon(Icons.visibility_outlined, size: 18),
            label: const Text('PREVIEW'),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
              textStyle: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 4),

          SettingsMenuButton(),
        ],
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
                        style: textTheme.titleSmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          letterSpacing: 1.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _formatTotalTime(),
                        style: textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                        ),
                        textAlign: TextAlign.center,
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
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: FilledButton.icon(
              onPressed: () async {
                var permission =
                    await FlutterForegroundTask.checkNotificationPermission();
                if (permission != NotificationPermission.granted) {
                  permission =
                      await FlutterForegroundTask.requestNotificationPermission();
                  if (permission != NotificationPermission.granted) {
                    AppSnackbar.show(
                      context: context,
                      title: 'Permission Required',
                      message:
                          'Notification permission required for background timer',
                      type: AppSnackbarType.warning,
                    );
                    return;
                  }
                }

                if (!await FlutterForegroundTask
                    .isIgnoringBatteryOptimizations) {
                  final ignored =
                      await FlutterForegroundTask.requestIgnoreBatteryOptimization();
                  if (!ignored) {
                    AppSnackbar.show(
                      context: context,
                      title: 'No Battery Optimization',
                      message:
                          'Please allow ignoring battery optimization for reliable background timer',
                      type: AppSnackbarType.warning,
                    );
                  }
                }

                context.read<TimerBloc>().add(TimerStarted(_config));
                context.push('/tabata/running');
              },
              icon: const Icon(Icons.play_arrow, size: 32),
              label: Text(
                'START WORKOUT',
                style: textTheme.titleLarge?.copyWith(letterSpacing: 1.2),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
