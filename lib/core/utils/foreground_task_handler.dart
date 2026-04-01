import 'dart:isolate';
import 'package:flutter/foundation.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';

@pragma('vm:entry-point')
void startCallback() {
  FlutterForegroundTask.setTaskHandler(TimerTaskHandler());
}

class TimerTaskHandler extends TaskHandler {
  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    debugPrint('✅ Service started');
  }

  @override
  void onRepeatEvent(DateTime timestamp) {}

  @override
  Future<void> onDestroy(DateTime timestamp, bool isUserAction) async {
    debugPrint('❌ Service destroyed');
  }
}
// class TimerTaskHandler extends TaskHandler {
//   @override
//   Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
//     // Make this extremely lightweight and fast
//     await FlutterForegroundTask.updateService(
//       notificationTitle: 'Tabata Timer',
//       notificationText: 'Workout in progress...',
//     );
//     debugPrint('Foreground service onStart completed');
//   }

//   @override
//   void onRepeatEvent(DateTime timestamp) {
//     // Leave empty for now - we update from main isolate
//   }

//   @override
//   Future<void> onDestroy(DateTime timestamp, bool isUserAction) async {
//     debugPrint('Foreground service destroyed');
//   }
// }
