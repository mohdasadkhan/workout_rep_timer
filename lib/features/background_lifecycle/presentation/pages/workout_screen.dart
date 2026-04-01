import 'dart:developer';

import 'package:app_lifecycle/core/di/injection.dart';
import 'package:app_lifecycle/features/background_lifecycle/presentation/background_lifecycle_bloc/background_lifecycle_bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({super.key});

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen>
    with WidgetsBindingObserver {
  late final BackgroundLifecycleBloc _timerBloc;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _timerBloc = getIt<BackgroundLifecycleBloc>();
    _timerBloc.add(const LoadTimerEvent());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timerBloc.close();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.paused:
        _timerBloc.add(const PauseTimerEvent());
      case AppLifecycleState.resumed:
        final currentState = _timerBloc.state;
        log('inside resumed current state >> $currentState');
        if (currentState is TimerLoaded && currentState.isRunning) {
          _timerBloc.add(const StartTimerEvent());
        }
      case AppLifecycleState.detached:
        _timerBloc.add(PauseTimerEvent());
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.hidden:
        _timerBloc.add(const PauseTimerEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _timerBloc,
      child: Scaffold(
        backgroundColor: Colors.grey[900],
        appBar: AppBar(
          backgroundColor: Colors.grey[900],
          title: const Text(
            'Workout Timer',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: BlocBuilder<BackgroundLifecycleBloc, TimerState>(
          builder: (context, state) => switch (state) {
            TimerInitial() => Center(child: CircularProgressIndicator()),
            TimerError() => Center(
              child: Text(state.message, style: TextStyle(color: Colors.red)),
            ),
            TimerLoaded() => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // sets completed badge
                  Text(
                    'Sets Completed: ${state.setsCompleted}',
                    style: const TextStyle(color: Colors.white54, fontSize: 18),
                  ),

                  const SizedBox(height: 24),

                  // main timer display
                  Text(
                    state.formattedTime,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 72,
                      fontWeight: FontWeight.bold,
                      fontFeatures: [
                        FontFeature.tabularFigures(),
                      ], // digits don't jump
                    ),
                  ),

                  const SizedBox(height: 48),

                  // start / pause button
                  ElevatedButton(
                    onPressed: () {
                      if (state.isRunning) {
                        context.read<BackgroundLifecycleBloc>().add(const PauseTimerEvent());
                      } else {
                        context.read<BackgroundLifecycleBloc>().add(const StartTimerEvent());
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                    ),
                    child: Icon(
                      state.isRunning ? Icons.pause : Icons.play_arrow,
                      color: Colors.white,
                      size: 100,
                    ),
                  ),

                  const SizedBox(height: 32),

                  // complete set button
                  TextButton(
                    onPressed: state.isRunning
                        ? () => context.read<BackgroundLifecycleBloc>().add(
                            const CompleteTimerEvent(),
                          )
                        : null,
                    child: const Text(
                      'Complete Set ✓',
                      style: TextStyle(color: Colors.greenAccent, fontSize: 16),
                    ),
                  ),

                  // reset button
                  TextButton(
                    onPressed: () =>
                        context.read<BackgroundLifecycleBloc>().add(const ResetTimerEvent()),
                    child: const Text(
                      'Reset',
                      style: TextStyle(color: Colors.redAccent, fontSize: 16),
                    ),
                  ),

                  TextButton(
                    onPressed: () async {
                      String? token = await FirebaseMessaging.instance
                          .getToken();
                      print("FCM_TOKEN: $token");
                    },
                    child: Text('Get Fcm Token'),
                  ),
                ],
              ),
            ),
          },
        ),
      ),
    );
  }
}
