
//sealed means no new events can be added outside this file

import 'package:equatable/equatable.dart';

class TimerEvent extends Equatable {
  const TimerEvent();

  @override
  List<Object> get props => [];
}

final class LoadTimerEvent extends TimerEvent {
  const LoadTimerEvent();
}

final class StartTimerEvent extends TimerEvent {
  const StartTimerEvent();
}

final class PauseTimerEvent extends TimerEvent {
  const PauseTimerEvent();
}

final class CompleteTimerEvent extends TimerEvent {
  const CompleteTimerEvent();
}

final class ResetTimerEvent extends TimerEvent {
  const ResetTimerEvent();
}
