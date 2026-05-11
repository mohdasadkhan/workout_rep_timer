import 'package:app_lifecycle/features/workout_timer/domain/entity/workout_config.dart';
import 'package:app_lifecycle/features/workout_timer/presentation/bloc/timer_bloc.dart';
import 'package:app_lifecycle/features/workout_timer/presentation/screens/config_screen.dart';
import 'package:app_lifecycle/features/workout_timer/presentation/screens/workout_preview_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockTimerBloc extends Mock implements TimerBloc {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const methodChannel = MethodChannel('flutter_foreground_task/methods');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(methodChannel, (call) async {
          if (call.method == 'isRunningService') return false;
          if (call.method == 'stopService') return true;
          if (call.method == 'startService') return true;
          if (call.method == 'updateService') return true;
          if (call.method == 'addTaskDataCallback') return true;
          if (call.method == 'checkNotificationPermission') return 1;
          if (call.method == 'requestNotificationPermission') return 1;
          if (call.method == 'isIgnoringBatteryOptimizations') return true;
          return true;
        });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(methodChannel, null);
  });

  testWidgets('ConfigScreen renders key UI', (tester) async {
    final bloc = TimerBloc();

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<TimerBloc>.value(value: bloc, child: const ConfigScreen()),
      ),
    );

    expect(find.text('TOTAL TIME'), findsOneWidget);
    expect(find.text('START WORKOUT'), findsOneWidget);
  });

  testWidgets('WorkoutPreviewScreen renders summary', (tester) async {
    final bloc = TimerBloc();

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<TimerBloc>.value(
          value: bloc,
          child: const WorkoutPreviewScreen(config: WorkoutConfig()),
        ),
      ),
    );

    expect(find.text('Workout Preview'), findsOneWidget);
    expect(find.text('YOUR WORKOUT FLOW'), findsOneWidget);
  });

}
