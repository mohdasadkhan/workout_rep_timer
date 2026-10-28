import 'package:equatable/equatable.dart';

/// Lightweight profile stub — onboarding will populate this in a later sprint.
class UserFitnessProfile extends Equatable {
  final String? primaryGoal;
  final String? experienceLevel;
  final int? daysPerWeek;

  const UserFitnessProfile({
    this.primaryGoal,
    this.experienceLevel,
    this.daysPerWeek,
  });

  static const empty = UserFitnessProfile();

  bool get isComplete =>
      primaryGoal != null &&
      experienceLevel != null &&
      daysPerWeek != null;

  @override
  List<Object?> get props => [primaryGoal, experienceLevel, daysPerWeek];
}
