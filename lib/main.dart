import 'package:fitflow/core/const/firebase_const.dart';
import 'package:fitflow/core/di/injection.dart';
import 'package:fitflow/core/router/app_router.dart';
import 'package:fitflow/core/services/notification_reminder_service.dart';
import 'package:fitflow/core/services/app_info_service.dart';
import 'package:fitflow/core/theme/app_theme.dart';
import 'package:fitflow/features/notification/presentation/bloc/notification_bloc.dart';
import 'package:fitflow/features/rep_tracker/presentation/bloc/workout_session_bloc/workout_session_bloc.dart';
import 'package:fitflow/features/rep_tracker/presentation/bloc/workout_session_bloc/workout_session_event.dart';
import 'package:fitflow/features/settings/domain/entities/app_theme_mode.dart';
import 'package:fitflow/features/settings/presentation/bloc/sound_settings/sound_settings_bloc.dart';
import 'package:fitflow/features/settings/presentation/bloc/theme_bloc/theme_bloc.dart';
import 'package:fitflow/features/settings/presentation/bloc/theme_bloc/theme_event.dart';
import 'package:fitflow/features/settings/presentation/bloc/theme_bloc/theme_state.dart';
import 'package:fitflow/features/workout_timer/presentation/bloc/timer_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final savedThemeStr = prefs.getString('theme_mode') ?? 'system';
  final initialThemeMode = _getInitialThemeMode(savedThemeStr);

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
  // Initialize version service
  // After setupInjection() and before runApp()

  final appInfoService = getIt<AppInfoService>();
  appInfoService.init(); // 🔥 No 'await' - fires in background

  try {
    NotificationReminderService.init();
  } catch (e) {
    debugPrint('⚠️ Reminder service init failed: $e');
  }
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
        BlocProvider(create: (_) => getIt<ThemeBloc>()..add(LoadTheme())),
        BlocProvider(
          // Eager-load sound settings so TimerBloc has them before any
          // workout starts. The bloc is a singleton-lifetime provider here.
          create: (_) => getIt<SoundSettingsBloc>()..add(LoadSoundSettings()),
        ),
        BlocProvider(create: (_) => getIt<TimerBloc>()),
        BlocProvider.value(
          value: getIt<WorkoutSessionBloc>()..add(LoadActiveSession()),
        ),
        BlocProvider(create: (_) => getIt<NotificationBloc>()),
      ],
      child: BlocListener<SoundSettingsBloc, SoundSettingsState>(
        // When the user changes sound prefs, push them into TimerBloc so the
        // currently-running timer picks up the change without any restart.
        listenWhen: (_, current) => current is SoundSettingsLoaded,
        listener: (context, state) {
          if (state is SoundSettingsLoaded) {
            context.read<TimerBloc>().add(
              TimerSoundSettingsChanged(
                soundEnabled: state.settings.soundEnabled,
                hapticEnabled: state.settings.hapticEnabled,
              ),
            );
          }
        },
        child: BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, state) {
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
      ),
    );
  }
}
