import 'package:app_lifecycle/features/workout_timer/domain/entity/workout_config.dart';
import 'package:app_lifecycle/features/workout_timer/presentation/bloc/timer_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

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
          return true;
        });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(methodChannel, null);
  });

  const config = WorkoutConfig(
    prepareSeconds: 1,
    workSeconds: 2,
    restSeconds: 1,
    cyclesPerSet: 1,
    numberOfSets: 2,
    restBetweenSetsSeconds: 1,
    coolDownSeconds: 0,
  );

  blocTest<TimerBloc, TimerState>(
    'TimerStarted emits TimerRunning',
    build: TimerBloc.new,
    act: (bloc) => bloc.add(TimerStarted(config)),
    expect: () => [isA<TimerRunning>()],
  );

  blocTest<TimerBloc, TimerState>(
    'TimerStopped returns TimerInitial',
    build: TimerBloc.new,
    act: (bloc) async {
      bloc.add(TimerStarted(config));
      await Future<void>.delayed(const Duration(milliseconds: 10));
      bloc.add(TimerStopped());
    },
    expect: () => [isA<TimerRunning>(), isA<TimerInitial>()],
  );
}
