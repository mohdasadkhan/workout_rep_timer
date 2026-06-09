import 'package:fitflow/core/const/firebase_const.dart';
import 'package:fitflow/core/di/injection.dart';
import 'package:fitflow/core/router/app_router.dart';
import 'package:fitflow/core/services/notification_reminder_service.dart';
import 'package:fitflow/core/theme/app_theme.dart';
import 'package:fitflow/features/notification/presentation/bloc/notification_bloc.dart';
import 'package:fitflow/features/rep_tracker/presentation/bloc/workout_session_bloc/workout_session_bloc.dart';
import 'package:fitflow/features/rep_tracker/presentation/bloc/workout_session_bloc/workout_session_event.dart';
import 'package:fitflow/features/settings/domain/entities/app_theme_mode.dart';
import 'package:fitflow/features/settings/presentation/bloc/theme_bloc.dart';
import 'package:fitflow/features/workout_timer/presentation/bloc/timer_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize SharedPreferences first to load theme synchronously
  final prefs = await SharedPreferences.getInstance();
  final savedThemeStr = prefs.getString('theme_mode') ?? 'system';
  final initialThemeMode = _getInitialThemeMode(savedThemeStr);

  // Rest of your initialization
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

  await NotificationReminderService.init();
  tz.setLocalLocation(tz.getLocation('Asia/Kolkata'));

  runApp(MyApp(initialThemeMode: initialThemeMode));
}

ThemeMode _getInitialThemeMode(String value) {
  switch (value.toLowerCase()) {
    case 'light':
      return ThemeMode.light;
    case 'dark':
      return ThemeMode.dark;
    case 'system':
    default:
      return ThemeMode.system;
  }
}

class MyApp extends StatelessWidget {
  final ThemeMode initialThemeMode;

  const MyApp({super.key, required this.initialThemeMode});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<TimerBloc>()),
        BlocProvider.value(
          value: getIt<WorkoutSessionBloc>()..add(LoadActiveSession()),
        ),
        BlocProvider(create: (_) => getIt<NotificationBloc>()),
        BlocProvider(create: (_) => getIt<ThemeBloc>()..add(LoadTheme())),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          // Use pre-loaded theme immediately to prevent flash
          final themeMode = state is ThemeLoaded
              ? state.mode.toThemeMode()
              : initialThemeMode;

          return MaterialApp.router(
            title: 'FitFlow',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeMode,
            routerConfig: createRouter(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
