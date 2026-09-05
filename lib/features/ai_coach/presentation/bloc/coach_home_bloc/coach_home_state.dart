import 'package:equatable/equatable.dart';
import 'package:fitflow/features/ai_coach/domain/entities/fitness_context.dart';

abstract class CoachHomeState extends Equatable {
  const CoachHomeState();

  @override
  List<Object?> get props => [];
}

class CoachHomeInitial extends CoachHomeState {
  const CoachHomeInitial();
}

class CoachHomeLoading extends CoachHomeState {
  const CoachHomeLoading();
}

class CoachHomeLoaded extends CoachHomeState {
  final FitnessContext context;

  const CoachHomeLoaded({required this.context});

  @override
  List<Object?> get props => [context];
}

class CoachHomeError extends CoachHomeState {
  final String message;

  const CoachHomeError({required this.message});

  @override
  List<Object?> get props => [message];
}
