// The router listens to NotificationBloc state changes and navigates
// when a deep-link target is set. The Bloc doesn't know about GoRouter —
// the router knows about the Bloc. Dependency direction stays clean.

import 'package:app_lifecycle/features/rep_tracker/presentation/pages/workout_history_page.dart';
import 'package:app_lifecycle/features/rep_tracker/presentation/pages/workout_session_page.dart';
import 'package:app_lifecycle/features/workout_timer/presentation/screens/config_screen.dart';
import 'package:app_lifecycle/features/workout_timer/presentation/screens/running_timer_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

Page<void> _buildPage({required GoRouterState state, required Widget child}) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 300),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      // CurvedAnimation makes it feel snappy, not robotic
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
// final _rootNavigatorKey = GlobalKey<NavigatorState>();

// GoRouter createRouter() {
//   return GoRouter(
//     navigatorKey: _rootNavigatorKey,
//     initialLocation: '/tabata', // or '/' for HomeScreen
//     routes: [
//       GoRoute(
//         path: '/tabata',
//         builder: (_, __) => const ConfigScreen(),
//         routes: [
//           GoRoute(
//             path: 'running',
//             builder: (_, __) => const RunningTimerScreen(),
//           ),
//         ],
//       ),
//       GoRoute(
//         path: '/rep-tracker',
//         builder: (_, __) => const WorkoutSessionPage(),
//         routes: [
//           GoRoute(
//             path: 'history',
//             builder: (_, __) => const WorkoutHistoryPage(),
//           ),
//         ],
//       ),
//     ],
//   );
// }
