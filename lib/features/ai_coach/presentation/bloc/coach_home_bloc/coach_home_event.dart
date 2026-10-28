import 'package:equatable/equatable.dart';

abstract class CoachHomeEvent extends Equatable {
  const CoachHomeEvent();

  @override
  List<Object?> get props => [];
}

class CoachHomeLoadRequested extends CoachHomeEvent {
  const CoachHomeLoadRequested();
}

class CoachHomeRefreshRequested extends CoachHomeEvent {
  const CoachHomeRefreshRequested();
}
