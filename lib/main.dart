import 'package:app_lifecycle/core/const/firebase_const.dart';
import 'package:app_lifecycle/core/di/injection.dart';
import 'package:app_lifecycle/features/notification/presentation/bloc/notification_bloc.dart';
import 'package:app_lifecycle/features/rep_tracker/presentation/bloc/workout_bloc.dart';
import 'package:app_lifecycle/features/workout_timer/presentation/bloc/timer_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:go_router/go_router.dart';

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
      channelImportance: NotificationChannelImportance.MAX,
      priority: NotificationPriority.MAX,
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
        BlocProvider(create: (_) => getIt<WorkoutBloc>()),
        BlocProvider(create: (_) => getIt<NotificationBloc>()),
      ],
      child: MaterialApp.router(
        title: 'Workout Timer',
        theme: ThemeData.dark(useMaterial3: true),
        routerConfig: getIt<GoRouter>(),
      ),
    );
  }
}
