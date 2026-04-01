import 'package:app_lifecycle/core/router/app_router.dart';
import 'package:app_lifecycle/features/background_lifecycle/data/local/timer_preferences.dart';
import 'package:app_lifecycle/features/background_lifecycle/data/repositories/timer_repository_impl.dart';
import 'package:app_lifecycle/features/background_lifecycle/domain/repositories/timer_repository.dart';
import 'package:app_lifecycle/features/background_lifecycle/presentation/background_lifecycle_bloc/background_lifecycle_bloc.dart';
import 'package:app_lifecycle/features/notification/data/datasources/fcm_remote_datasource.dart';
import 'package:app_lifecycle/features/notification/data/datasources/local_notification_datasource.dart';
import 'package:app_lifecycle/features/notification/data/repository/notification_repository_impl.dart';
import 'package:app_lifecycle/features/notification/domain/repositories/notification_repository.dart';
import 'package:app_lifecycle/features/notification/domain/usecases/handle_notification_tap.dart';
import 'package:app_lifecycle/features/notification/domain/usecases/listen_foreground_notifications.dart';
import 'package:app_lifecycle/features/notification/domain/usecases/subscribe_to_topic.dart';
import 'package:app_lifecycle/features/notification/presentation/bloc/notification_bloc.dart';
import 'package:app_lifecycle/features/rep_tracker/data/datasources/workout_local_datasource.dart';
import 'package:app_lifecycle/features/rep_tracker/data/repositories/workout_repository_impl.dart';
import 'package:app_lifecycle/features/rep_tracker/domain/repositories/workout_repository.dart';
import 'package:app_lifecycle/features/rep_tracker/domain/usecases/get_personal_records.dart';
import 'package:app_lifecycle/features/rep_tracker/domain/usecases/get_workout_history.dart';
import 'package:app_lifecycle/features/rep_tracker/domain/usecases/save_workout_session.dart';
import 'package:app_lifecycle/features/rep_tracker/presentation/bloc/workout_bloc.dart';
import 'package:app_lifecycle/features/workout_timer/presentation/bloc/timer_bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';

final getIt = GetIt.instance;

Future<void> registerAppBackgroundFeature() async {
  getIt.registerSingleton<TimerPreferences>(
    TimerPreferences(getIt<SharedPreferences>()),
  );
  getIt.registerSingleton<TimerRepository>(
    TimerRepositoryImpl(timerPreferences: getIt<TimerPreferences>()),
  );

  getIt.registerFactory<BackgroundLifecycleBloc>(
    () => BackgroundLifecycleBloc(timerRepository: getIt<TimerRepository>()),
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
  // Datasource
  getIt.registerLazySingleton<WorkoutLocalDatasource>(
    () => WorkoutLocalDatasourceImpl(hive: Hive),
  );

  // Repository — binds the abstract contract to the impl (Dependency Inversion)
  getIt.registerLazySingleton<WorkoutRepository>(
    () => WorkoutRepositoryImpl(localDatasource: getIt()),
  );

  // Use cases
  getIt.registerLazySingleton(() => SaveWorkoutSession(getIt()));
  getIt.registerLazySingleton(() => GetWorkoutHistory(getIt()));
  getIt.registerLazySingleton(() => GetPersonalRecords(getIt()));

  // BLoC — registered as factory so each page gets a fresh instance
  getIt.registerFactory(
    () => WorkoutBloc(
      saveWorkoutSession: getIt(),
      getWorkoutHistory: getIt(),
      getPersonalRecords: getIt(),
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
}
