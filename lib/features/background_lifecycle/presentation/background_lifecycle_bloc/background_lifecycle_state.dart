part of 'background_lifecycle_bloc.dart';

sealed class TimerState extends Equatable {
  const TimerState();

  @override
  List<Object> get props => [];
}

final class TimerInitial extends TimerState {
  const TimerInitial();
  @override
  List<Object> get props => [];
}

final class TimerLoaded extends TimerState {
  final TimerSession timerSession;
  const TimerLoaded({required this.timerSession});

  String get formattedTime {
    final minutes = timerSession.elapsedSeconds ~/ 60;
    final seconds = timerSession.elapsedSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  bool get isRunning => timerSession.isRunning;
  int get setsCompleted => timerSession.setsCompleted;
  @override
  List<Object> get props => [timerSession];
}

final class TimerError extends TimerState {
  final String message;
  const TimerError({required this.message});
  @override
  List<Object> get props => [message];
}
