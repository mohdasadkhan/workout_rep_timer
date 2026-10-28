import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:fitflow/core/failure/failure.dart';
import 'package:fitflow/core/usecases/usecase.dart';
import 'package:fitflow/features/auth/domain/entities/user_profile.dart';
import 'package:fitflow/features/auth/domain/repositories/auth_repository.dart';
import 'package:fitflow/features/auth/domain/usecases/auth_usecases.dart';
import 'package:fitflow/features/auth/presentation/cubit/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<AuthState> {
  final GetCurrentUserProfile _getCurrentUserProfile;
  final SignInWithGoogle _signInWithGoogle;
  final SignInAnonymously _signInAnonymously;
  final SignOut _signOut;
  final AuthRepository _authRepository;

  StreamSubscription<UserProfile?>? _authSubscription;

  AuthCubit({
    required GetCurrentUserProfile getCurrentUserProfile,
    required SignInWithGoogle signInWithGoogle,
    required SignInAnonymously signInAnonymously,
    required SignOut signOut,
    required AuthRepository authRepository,
  }) : _getCurrentUserProfile = getCurrentUserProfile,
       _signInWithGoogle = signInWithGoogle,
       _signInAnonymously = signInAnonymously,
       _signOut = signOut,
       _authRepository = authRepository,
       super(const AuthInitial());

  Future<void> initialize() async {
    emit(const AuthLoading());

    await _authSubscription?.cancel();
    _authSubscription = _authRepository.watchAuthState().listen(
      (profile) {
        if (profile == null) {
          emit(const AuthUnauthenticated());
        } else {
          emit(AuthAuthenticated(profile));
        }
      },
      onError: (Object error) {
        emit(AuthError(message: error.toString()));
      },
    );

    final result = await _getCurrentUserProfile(NoParams());
    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (profile) {
        if (profile == null) {
          emit(const AuthUnauthenticated());
        } else {
          emit(AuthAuthenticated(profile));
        }
      },
    );
  }

  Future<void> signInWithGoogle() async {
    await _performSignIn(() => _signInWithGoogle(NoParams()));
  }

  Future<void> signInAnonymously() async {
    await _performSignIn(() => _signInAnonymously(NoParams()));
  }

  Future<void> linkGoogleAccount() async {
    await _performSignIn(() => _signInWithGoogle(NoParams()));
  }

  Future<void> signOut() async {
    final previousProfile = _currentProfile;
    emit(const AuthLoading());

    final result = await _signOut(NoParams());
    result.fold(
      (failure) => emit(
        AuthError(message: failure.message, profile: previousProfile),
      ),
      (_) => emit(const AuthUnauthenticated()),
    );
  }

  Future<void> _performSignIn(
    Future<Either<Failure, UserProfile>> Function() signInAction,
  ) async {
    final previousProfile = _currentProfile;
    emit(const AuthLoading());

    final result = await signInAction();
    result.fold(
      (failure) => emit(
        AuthError(message: failure.message, profile: previousProfile),
      ),
      (profile) => emit(AuthAuthenticated(profile)),
    );
  }

  UserProfile? get _currentProfile {
    final current = state;
    if (current is AuthAuthenticated) {
      return current.profile;
    }
    if (current is AuthError) {
      return current.profile;
    }
    return null;
  }

  @override
  Future<void> close() async {
    await _authSubscription?.cancel();
    return super.close();
  }
}
