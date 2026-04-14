import 'package:app_lifecycle/core/const/firebase_const.dart';
import 'package:app_lifecycle/core/di/injection.dart';
import 'package:app_lifecycle/core/router/app_router.dart';
import 'package:app_lifecycle/core/theme/app_theme.dart';
import 'package:app_lifecycle/features/notification/presentation/bloc/notification_bloc.dart';
import 'package:app_lifecycle/features/rep_tracker/presentation/bloc/workout_session_bloc/workout_session_bloc.dart';
import 'package:app_lifecycle/features/rep_tracker/presentation/bloc/workout_session_bloc/workout_session_event.dart';
import 'package:app_lifecycle/features/workout_timer/presentation/bloc/timer_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupInjection();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: FirebaseConst.webApiKey,
      appId: FirebaseConst.appId,
      messagingSenderId: FirebaseConst.messageSenderId,
      projectId: FirebaseConst.projectId,
    ),
  );
  FlutterForegroundTask.initCommunicationPort();
  FlutterForegroundTask.init(
    androidNotificationOptions: AndroidNotificationOptions(
      channelId: 'tabata_timer_channel',
      channelName: 'Tabata Timer',
      channelDescription: 'Shows current workout phase and time',
      channelImportance: NotificationChannelImportance.LOW,
      priority: NotificationPriority.LOW,
    ),
    iosNotificationOptions: const IOSNotificationOptions(
      showNotification: true,
      playSound: true,
    ),
    foregroundTaskOptions: ForegroundTaskOptions(
      autoRunOnBoot: false,
      allowWakeLock: true,
      allowWifiLock: true,
      eventAction: ForegroundTaskEventAction.nothing(),
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<TimerBloc>()),
        BlocProvider.value(
          value: getIt<WorkoutSessionBloc>()..add(LoadActiveSession()),
        ),

        BlocProvider(create: (_) => getIt<NotificationBloc>()),
      ],
      child: MaterialApp.router(
        title: 'Workout Timer',
        theme: AppTheme.darkTheme,
        routerConfig: createRouter(),
      ),
    );
  }
}
