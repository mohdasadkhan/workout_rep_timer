import 'package:equatable/equatable.dart';
import 'package:fitflow/features/auth/domain/entities/user_profile.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

final class AuthInitial extends AuthState {
  const AuthInitial();
}

final class AuthLoading extends AuthState {
  const AuthLoading();
}

final class AuthAuthenticated extends AuthState {
  final UserProfile profile;

  const AuthAuthenticated(this.profile);

  @override
  List<Object?> get props => [profile];
}

final class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

final class AuthError extends AuthState {
  final String message;
  final UserProfile? profile;

  const AuthError({required this.message, this.profile});

  @override
  List<Object?> get props => [message, profile];
}
