import 'package:app_lifecycle/core/constants/pref_keys.dart';
import 'package:app_lifecycle/core/di/injection.dart';
import 'package:app_lifecycle/features/rep_tracker/presentation/bloc/personal_records_bloc/personal_records_bloc.dart';
import 'package:app_lifecycle/features/rep_tracker/presentation/bloc/workout_history_bloc/workout_history_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:app_lifecycle/features/rep_tracker/presentation/pages/workout_history_page.dart';
import 'package:app_lifecycle/features/rep_tracker/presentation/pages/workout_session_page.dart';
import 'package:app_lifecycle/features/workout_timer/domain/entity/workout_config.dart';
import 'package:app_lifecycle/features/workout_timer/presentation/screens/config_screen.dart';
import 'package:app_lifecycle/features/workout_timer/presentation/screens/running_timer_screen.dart';
import 'package:app_lifecycle/features/workout_timer/presentation/screens/workout_preview_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

Page<void> _buildPage({required GoRouterState state, required Widget child}) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 300),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeInOut,
      );
      return FadeTransition(opacity: curved, child: child);
    },
  );
}

GoRouter createRouter() {
  final prefs = getIt<SharedPreferences>();
  final initialLocation =
      prefs.getString(PrefKeys.lastOpenedFeature) ?? '/rep-tracker';

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: initialLocation,

    errorPageBuilder: (context, state) => _buildPage(
      state: state,
      child: const Scaffold(body: Center(child: Text('Page not found'))),
    ),

    routes: [
      GoRoute(
        path: '/tabata',
        pageBuilder: (context, state) =>
            _buildPage(state: state, child: const ConfigScreen()),

        routes: [
          GoRoute(
            path: 'preview',
            pageBuilder: (context, state) {
              final params = state.uri.queryParameters;
              final config = WorkoutConfig.fromQuery(params);
              return _buildPage(
                state: state,
                child: WorkoutPreviewScreen(config: config),
              );
            },
          ),
          GoRoute(
            path: 'running',
            pageBuilder: (context, state) =>
                _buildPage(state: state, child: const RunningTimerScreen()),
          ),
        ],
      ),

      GoRoute(
        path: '/rep-tracker',
        pageBuilder: (context, state) =>
            _buildPage(state: state, child: const WorkoutSessionPage()),

        routes: [
          GoRoute(
            path: 'history',
            pageBuilder: (context, state) => _buildPage(
              state: state,
              child: MultiBlocProvider(
                providers: [
                  BlocProvider(create: (_) => getIt<WorkoutHistoryBloc>()),
                  BlocProvider(create: (_) => getIt<PersonalRecordsBloc>()),
                ],
                child: const WorkoutHistoryPage(),
              ),
            ),
          ),
        ],
      ),
    ],
  );
}
