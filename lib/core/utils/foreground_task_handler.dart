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

  @override
  void onNotificationButtonPressed(String id) {
    super.onNotificationButtonPressed(id);
    debugPrint('🔘 Button pressed: $id');
    // if (id == 'stop') {
    //   FlutterForegroundTask.launchApp('/running');
    // }
    FlutterForegroundTask.sendDataToMain({'action': id});
  }
}
