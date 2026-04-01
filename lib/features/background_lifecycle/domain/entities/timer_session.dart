import 'package:equatable/equatable.dart';

class TimerSession extends Equatable {
  final int elapsedSeconds;
  final bool isRunning;
  final int setsCompleted;
  const TimerSession({
    required this.elapsedSeconds,
    required this.isRunning,
    required this.setsCompleted,
  });

  TimerSession copyWith({
    int? elapsedSeconds,
    bool? isRunning,
    int? setsCompleted,
  }) {
    return TimerSession(
      elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
      isRunning: isRunning ?? this.isRunning,
      setsCompleted: setsCompleted ?? this.setsCompleted,
    );
  }

  @override
  List<Object?> get props => [elapsedSeconds, isRunning, setsCompleted];

  @override
  String toString() =>
      'TimerSession(elapsedSeconds: $elapsedSeconds, isRunning: $isRunning, setsCompleted: $setsCompleted)';
}
