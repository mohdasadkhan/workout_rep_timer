import 'package:fitflow/core/constants/pref_keys.dart';
import 'package:fitflow/core/di/injection.dart';
import 'package:fitflow/core/router/auth_router_refresh.dart';
import 'package:fitflow/features/ai_coach/presentation/bloc/coach_home_bloc/coach_home_bloc.dart';
import 'package:fitflow/features/ai_coach/presentation/bloc/coach_home_bloc/coach_home_event.dart';
import 'package:fitflow/features/ai_coach/presentation/screens/coach_home_screen.dart';
import 'package:fitflow/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:fitflow/features/auth/presentation/cubit/auth_state.dart';
import 'package:fitflow/features/auth/presentation/screens/landing_screen.dart';
import 'package:fitflow/features/auth/presentation/screens/user_profile_screen.dart';
import 'package:fitflow/features/reminder/presentation/bloc/reminder_bloc.dart';
import 'package:fitflow/features/reminder/presentation/bloc/reminder_event.dart';
import 'package:fitflow/features/reminder/presentation/screens/reminder_settings_screen.dart';
import 'package:fitflow/features/rep_tracker/presentation/bloc/personal_records_bloc/personal_records_bloc.dart';
import 'package:fitflow/features/rep_tracker/presentation/bloc/workout_history_bloc/workout_history_bloc.dart';
import 'package:fitflow/features/rep_tracker/presentation/pages/workout_history_page.dart';
import 'package:fitflow/features/rep_tracker/presentation/pages/workout_session_page.dart';
import 'package:fitflow/features/settings/presentation/screens/settings_screen.dart';
import 'package:fitflow/features/workout_timer/domain/entity/workout_config.dart';
import 'package:fitflow/features/workout_timer/presentation/screens/config_screen.dart';
import 'package:fitflow/features/workout_timer/presentation/screens/running_timer_screen.dart';
import 'package:fitflow/features/workout_timer/presentation/screens/workout_preview_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
const _landingPath = '/landing';

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

bool _isSignedIn(AuthState state) {
  return state is AuthAuthenticated ||
      (state is AuthError && state.profile != null);
}

String? _authRedirect({
  required AuthState authState,
  required GoRouterState routerState,
  required String homeLocation,
}) {
  final location = routerState.matchedLocation;
  final onLanding = location == _landingPath;

  if (authState is AuthInitial || authState is AuthLoading) {
    return onLanding ? null : _landingPath;
  }

  if (!_isSignedIn(authState)) {
    return onLanding ? null : _landingPath;
  }

  if (onLanding) {
    return homeLocation;
  }

  return null;
}

GoRouter createRouter() {
  final prefs = getIt<SharedPreferences>();
  final authCubit = getIt<AuthCubit>();

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: _landingPath,
    refreshListenable: AuthRouterRefresh(authCubit),
    redirect: (context, state) {
      final homeLocation =
          prefs.getString(PrefKeys.lastOpenedFeature) ?? '/coach';
      return _authRedirect(
        authState: authCubit.state,
        routerState: state,
        homeLocation: homeLocation,
      );
    },
    errorPageBuilder: (context, state) => _buildPage(
      state: state,
      child: const Scaffold(body: Center(child: Text('Page not found'))),
    ),
    routes: [
      GoRoute(
        path: _landingPath,
        pageBuilder: (context, state) =>
            _buildPage(state: state, child: const LandingScreen()),
      ),
      GoRoute(
        path: '/coach',
        pageBuilder: (context, state) => _buildPage(
          state: state,
          child: BlocProvider(
            create: (_) =>
                getIt<CoachHomeBloc>()..add(const CoachHomeLoadRequested()),
            child: const CoachHomeScreen(),
          ),
        ),
      ),
      GoRoute(
        path: '/tabata',
        pageBuilder: (context, state) =>
            _buildPage(state: state, child: const ConfigScreen()),
        routes: [
          GoRoute(
            path: 'preview',
            pageBuilder: (context, state) {
              final config =
                  state.extra as WorkoutConfig? ?? const WorkoutConfig();
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
        pageBuilder: (context, state) => _buildPage(
          state: state,
          child: const WorkoutSessionPage(),
        ),
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
      GoRoute(
        path: '/settings',
        name: 'settings',
        pageBuilder: (context, state) =>
            _buildPage(state: state, child: const SettingsScreen()),
        routes: [
          GoRoute(
            path: 'profile',
            name: 'settings-profile',
            pageBuilder: (context, state) => _buildPage(
              state: state,
              child: const UserProfileScreen(),
            ),
          ),
        ],
      ),
      GoRoute(
        path: '/reminder-settings',
        name: 'reminder-settings',
        pageBuilder: (context, state) => _buildPage(
          state: state,
          child: BlocProvider(
            create: (context) =>
                getIt<ReminderBloc>()..add(ReminderLoadSettings()),
            child: const ReminderSettingsScreen(),
          ),
        ),
      ),
    ],
  );
}
