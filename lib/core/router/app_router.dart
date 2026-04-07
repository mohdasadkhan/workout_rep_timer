import 'package:app_lifecycle/features/rep_tracker/presentation/pages/workout_history_page.dart';
import 'package:app_lifecycle/features/rep_tracker/presentation/pages/workout_session_page.dart';
import 'package:app_lifecycle/features/workout_timer/domain/entity/workout_config.dart';
import 'package:app_lifecycle/features/workout_timer/presentation/screens/config_screen.dart';
import 'package:app_lifecycle/features/workout_timer/presentation/screens/running_timer_screen.dart';
import 'package:app_lifecycle/features/workout_timer/presentation/screens/workout_preview_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/tabata',
    routes: [
      GoRoute(
        path: '/tabata',
        pageBuilder: (context, state) =>
            _buildPage(state: state, child: const ConfigScreen()),
      ),

      GoRoute(
        path: '/tabata/preview',
        pageBuilder: (context, state) {
          final config = state.extra as WorkoutConfig;
          return _buildPage(
            state: state,
            child: WorkoutPreviewScreen(config: config),
          );
        },
      ),
      GoRoute(
        path: '/tabata/running',
        pageBuilder: (context, state) =>
            _buildPage(state: state, child: const RunningTimerScreen()),
      ),
      GoRoute(
        path: '/rep-tracker',
        pageBuilder: (context, state) =>
            _buildPage(state: state, child: const WorkoutSessionPage()),
      ),
      GoRoute(
        path: '/rep-tracker/history',
        pageBuilder: (context, state) =>
            _buildPage(state: state, child: const WorkoutHistoryPage()),
      ),
    ],
  );
}
