import 'package:fitflow/core/router/app_router.dart';
import 'package:fitflow/features/background_lifecycle/data/local/timer_preferences.dart';
import 'package:fitflow/features/background_lifecycle/data/repositories/timer_repository_impl.dart';
import 'package:fitflow/features/background_lifecycle/domain/repositories/timer_repository.dart';
import 'package:fitflow/features/notification/data/datasources/fcm_remote_datasource.dart';
import 'package:fitflow/features/notification/data/datasources/local_notification_datasource.dart';
import 'package:fitflow/features/notification/data/repository/notification_repository_impl.dart';
import 'package:fitflow/features/notification/domain/repositories/notification_repository.dart';
import 'package:fitflow/features/notification/domain/usecases/handle_notification_tap.dart';
import 'package:fitflow/features/notification/domain/usecases/listen_foreground_notifications.dart';
import 'package:fitflow/features/notification/domain/usecases/subscribe_to_topic.dart';
import 'package:fitflow/features/notification/presentation/bloc/notification_bloc.dart';
import 'package:fitflow/features/reminder/data/datasources/reminder_local_datasource.dart';
import 'package:fitflow/features/reminder/data/repositories/reminder_notification_service_impl.dart';
import 'package:fitflow/features/reminder/data/repositories/reminder_repository_impl.dart';
import 'package:fitflow/features/reminder/domain/repositories/reminder_notification_service.dart';
import 'package:fitflow/features/reminder/domain/repositories/reminder_repository.dart';
import 'package:fitflow/features/reminder/domain/usecases/load_reminder_settings_usecases.dart';
import 'package:fitflow/features/reminder/domain/usecases/save_reminder_settings_usecase.dart';
import 'package:fitflow/features/reminder/presentation/bloc/reminder_bloc.dart';
import 'package:fitflow/features/rep_tracker/data/datasources/workout_local_datasource.dart';
import 'package:fitflow/features/rep_tracker/data/repositories/workout_repository_impl.dart';
import 'package:fitflow/features/rep_tracker/domain/repositories/workout_repository.dart';
import 'package:fitflow/features/rep_tracker/domain/usecases/delete_workout_session.dart';
import 'package:fitflow/features/rep_tracker/domain/usecases/get_personal_records.dart';
import 'package:fitflow/features/rep_tracker/domain/usecases/get_workout_history.dart';
import 'package:fitflow/features/rep_tracker/domain/usecases/save_workout_session.dart';
import 'package:fitflow/features/rep_tracker/presentation/bloc/personal_records_bloc/personal_records_bloc.dart';
import 'package:fitflow/features/rep_tracker/presentation/bloc/workout_history_bloc/workout_history_bloc.dart';
import 'package:fitflow/features/rep_tracker/presentation/bloc/workout_session_bloc/workout_session_bloc.dart';
import 'package:fitflow/features/settings/data/datasources/theme_local_datasource.dart';
import 'package:fitflow/features/settings/data/repositories/theme_repository_impl.dart';
import 'package:fitflow/features/settings/domain/repositories/theme_repository.dart';
import 'package:fitflow/features/settings/domain/usecases/get_theme_mode.dart';
import 'package:fitflow/features/settings/domain/usecases/save_theme_mode.dart';
import 'package:fitflow/features/settings/presentation/bloc/theme_bloc.dart';
import 'package:fitflow/features/workout_timer/presentation/bloc/timer_bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive_flutter/hive_flutter.dart';

final getIt = GetIt.instance;

Future<void> registerAppBackgroundFeature() async {
  getIt.registerSingleton<TimerPreferences>(
    TimerPreferences(getIt<SharedPreferences>()),
  );
  getIt.registerSingleton<TimerRepository>(
    TimerRepositoryImpl(timerPreferences: getIt<TimerPreferences>()),
  );
}

Future<void> registerFirebaseFeature() async {
  getIt.registerLazySingleton(() => FirebaseMessaging.instance);
  getIt.registerLazySingleton(() => FlutterLocalNotificationsPlugin());
}

Future<void> registerNotificationFeature() async {
  getIt.registerLazySingleton<FcmRemoteDatasource>(
    () => FcmRemoteDatasourceImpl(messaging: getIt<FirebaseMessaging>()),
  );
  getIt.registerLazySingleton<LocalNotificationDataSourceImpl>(
    () => LocalNotificationDataSourceImpl(
      plugin: getIt<FlutterLocalNotificationsPlugin>(),
    ),
  );

  await getIt<LocalNotificationDataSourceImpl>().initialize();
  getIt.registerLazySingleton<NotificationRepository>(
    () => NotificationRepositoryImpl(
      fcmRemoteDatasource: getIt<FcmRemoteDatasource>(),
      localDataSource: getIt<LocalNotificationDataSourceImpl>(),
    ),
  );
  getIt.registerLazySingleton(
    () => ListenForegroundNotifications(getIt<NotificationRepository>()),
  );
  getIt.registerLazySingleton(
    () => HandleNotificationTap(getIt<NotificationRepository>()),
  );
  getIt.registerLazySingleton(
    () => SubscribeToTopic(getIt<NotificationRepository>()),
  );

  getIt.registerFactory(
    () => NotificationBloc(
      listenForeground: getIt<ListenForegroundNotifications>(),
      handleNotificationTap: getIt<HandleNotificationTap>(),
      subscribeToTopic: getIt<SubscribeToTopic>(),
      repository: getIt<NotificationRepository>(),
    ),
  );
}

Future<void> registerRepTrackerFeature() async {
  getIt.registerLazySingleton<WorkoutLocalDatasource>(
    () => WorkoutLocalDatasourceImpl(hive: Hive),
  );

  getIt.registerLazySingleton<WorkoutRepository>(
    () => WorkoutRepositoryImpl(localDatasource: getIt()),
  );

  getIt.registerLazySingleton(() => SaveWorkoutSession(getIt()));
  getIt.registerLazySingleton(() => GetWorkoutHistory(getIt()));
  getIt.registerLazySingleton(() => DeleteWorkoutSessionUsecase(getIt()));
  getIt.registerLazySingleton(() => GetPersonalRecords(getIt()));

  getIt.registerFactory(
    () => WorkoutSessionBloc(
      saveWorkoutSession: getIt<SaveWorkoutSession>(),
      workoutRepository: getIt<WorkoutRepository>(),
    ),
  );
  getIt.registerFactory(
    () => PersonalRecordsBloc(getPersonalRecords: getIt<GetPersonalRecords>()),
  );
  getIt.registerFactory(
    () => WorkoutHistoryBloc(
      getWorkoutHistory: getIt<GetWorkoutHistory>(),
      deleteWorkoutSession: getIt<DeleteWorkoutSessionUsecase>(),
      saveWorkoutSession: getIt<SaveWorkoutSession>(),
    ),
  );
}

Future<void> registerWorkoutTimerFeature() async {
  getIt.registerFactory<TimerBloc>(() => TimerBloc());
}

Future<void> setupInjection() async {
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
  await Hive.initFlutter();
  getIt.registerLazySingleton<GoRouter>(() => createRouter());
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);
  await registerAppBackgroundFeature();
  await registerFirebaseFeature();
  await registerNotificationFeature();
  await registerRepTrackerFeature();
  await registerWorkoutTimerFeature();
  await _registerReminderFeature();
  await _registerThemeFeature();
}

Future<void> _registerReminderFeature() async {
  getIt.registerLazySingleton<ReminderLocalDatasource>(
    () => ReminderLocalDatasource(getIt<SharedPreferences>()),
  );

  getIt.registerLazySingleton<ReminderRepository>(
    () => ReminderRepositoryImpl(getIt<ReminderLocalDatasource>()),
  );

  getIt.registerLazySingleton<ReminderNotificationService>(
    () => const ReminderNotificationServiceImpl(),
  );

  getIt.registerLazySingleton(
    () => LoadReminderSettingsUseCase(getIt<ReminderRepository>()),
  );
  getIt.registerLazySingleton(
    () => SaveReminderSettingsUseCase(
      repository: getIt<ReminderRepository>(),
      notificationService: getIt<ReminderNotificationService>(),
    ),
  );

  getIt.registerFactory(
    () => ReminderBloc(
      loadSettings: getIt<LoadReminderSettingsUseCase>(),
      saveSettings: getIt<SaveReminderSettingsUseCase>(),
    ),
  );
}

Future<void> _registerThemeFeature() async {
  // Theme
  getIt.registerLazySingleton<ThemeLocalDatasource>(
    () => ThemeLocalDatasourceImpl(sharedPreferences: getIt()),
  );
  getIt.registerLazySingleton<ThemeRepository>(
    () => ThemeRepositoryImpl(localDatasource: getIt()),
  );
  getIt.registerFactory<GetThemeMode>(() => GetThemeMode(getIt()));
  getIt.registerFactory<SaveThemeMode>(() => SaveThemeMode(getIt()));
  getIt.registerFactory<ThemeBloc>(
    () => ThemeBloc(getThemeMode: getIt(), saveThemeMode: getIt()),
  );
}
