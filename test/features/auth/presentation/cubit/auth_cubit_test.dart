import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:fitflow/core/failure/failure.dart';
import 'package:fitflow/core/usecases/usecase.dart';
import 'package:fitflow/features/auth/domain/entities/user_profile.dart';
import 'package:fitflow/features/auth/domain/repositories/auth_repository.dart';
import 'package:fitflow/features/auth/domain/usecases/auth_usecases.dart';
import 'package:fitflow/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:fitflow/features/auth/presentation/cubit/auth_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'auth_cubit_test.mocks.dart';

@GenerateMocks([
  GetCurrentUserProfile,
  SignInWithGoogle,
  SignInAnonymously,
  SignOut,
  AuthRepository,
])
void main() {
  late MockGetCurrentUserProfile mockGetCurrentUser;
  late MockSignInWithGoogle mockSignIn;
  late MockSignInAnonymously mockSignInAnonymously;
  late MockSignOut mockSignOut;
  late MockAuthRepository mockAuthRepository;

  const profile = UserProfile(
    uid: 'uid-1',
    email: 'user@gmail.com',
    displayName: 'FitFlow User',
    providerId: 'google.com',
    googleId: 'google-id',
  );

  const guestProfile = UserProfile(
    uid: 'guest-uid',
    displayName: 'Guest',
    providerId: 'anonymous',
    isAnonymous: true,
  );

  setUp(() {
    mockGetCurrentUser = MockGetCurrentUserProfile();
    mockSignIn = MockSignInWithGoogle();
    mockSignInAnonymously = MockSignInAnonymously();
    mockSignOut = MockSignOut();
    mockAuthRepository = MockAuthRepository();
    when(
      mockAuthRepository.watchAuthState(),
    ).thenAnswer((_) => const Stream.empty());
  });

  AuthCubit buildCubit() => AuthCubit(
    getCurrentUserProfile: mockGetCurrentUser,
    signInWithGoogle: mockSignIn,
    signInAnonymously: mockSignInAnonymously,
    signOut: mockSignOut,
    authRepository: mockAuthRepository,
  );

  group('initialize', () {
    blocTest<AuthCubit, AuthState>(
      'emits authenticated when current user exists',
      build: buildCubit,
      setUp: () {
        when(
          mockGetCurrentUser(NoParams()),
        ).thenAnswer((_) async => const Right(profile));
      },
      act: (cubit) => cubit.initialize(),
      expect: () => [
        const AuthLoading(),
        const AuthAuthenticated(profile),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'emits unauthenticated when no current user',
      build: buildCubit,
      setUp: () {
        when(
          mockGetCurrentUser(NoParams()),
        ).thenAnswer((_) async => const Right(null));
      },
      act: (cubit) => cubit.initialize(),
      expect: () => [
        const AuthLoading(),
        const AuthUnauthenticated(),
      ],
    );
  });

  group('signInWithGoogle', () {
    blocTest<AuthCubit, AuthState>(
      'emits authenticated profile on success',
      build: buildCubit,
      setUp: () {
        when(
          mockSignIn(NoParams()),
        ).thenAnswer((_) async => const Right(profile));
      },
      act: (cubit) => cubit.signInWithGoogle(),
      expect: () => [
        const AuthLoading(),
        const AuthAuthenticated(profile),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'emits error when sign-in fails',
      build: buildCubit,
      seed: () => const AuthAuthenticated(profile),
      setUp: () {
        when(mockSignIn(NoParams())).thenAnswer(
          (_) async => const Left(AuthFailure(message: 'Sign-in cancelled')),
        );
      },
      act: (cubit) => cubit.signInWithGoogle(),
      expect: () => [
        const AuthLoading(),
        const AuthError(message: 'Sign-in cancelled', profile: profile),
      ],
    );
  });

  group('signInAnonymously', () {
    blocTest<AuthCubit, AuthState>(
      'emits authenticated guest profile on success',
      build: buildCubit,
      setUp: () {
        when(
          mockSignInAnonymously(NoParams()),
        ).thenAnswer((_) async => const Right(guestProfile));
      },
      act: (cubit) => cubit.signInAnonymously(),
      expect: () => [
        const AuthLoading(),
        const AuthAuthenticated(guestProfile),
      ],
    );
  });

  group('linkGoogleAccount', () {
    blocTest<AuthCubit, AuthState>(
      'upgrades guest profile when Google linking succeeds',
      build: buildCubit,
      seed: () => const AuthAuthenticated(guestProfile),
      setUp: () {
        when(
          mockSignIn(NoParams()),
        ).thenAnswer((_) async => const Right(profile));
      },
      act: (cubit) => cubit.linkGoogleAccount(),
      expect: () => [
        const AuthLoading(),
        const AuthAuthenticated(profile),
      ],
    );
  });

  group('signOut', () {
    blocTest<AuthCubit, AuthState>(
      'emits unauthenticated on success',
      build: buildCubit,
      seed: () => const AuthAuthenticated(profile),
      setUp: () {
        when(mockSignOut(NoParams())).thenAnswer((_) async => const Right(unit));
      },
      act: (cubit) => cubit.signOut(),
      expect: () => [
        const AuthLoading(),
        const AuthUnauthenticated(),
      ],
    );
  });
}
