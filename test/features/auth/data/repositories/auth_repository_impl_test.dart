import 'package:dartz/dartz.dart';
import 'package:fitflow/core/failure/auth_exceptions.dart';
import 'package:fitflow/core/failure/failure.dart';
import 'package:fitflow/features/auth/data/datasources/auth_datasources.dart';
import 'package:fitflow/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:fitflow/features/auth/domain/entities/user_profile.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'auth_repository_impl_test.mocks.dart';

@GenerateMocks([AuthRemoteDatasource, UserProfileLocalDatasource])
void main() {
  late MockAuthRemoteDatasource mockRemote;
  late MockUserProfileLocalDatasource mockLocal;
  late AuthRepositoryImpl sut;

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
    mockRemote = MockAuthRemoteDatasource();
    mockLocal = MockUserProfileLocalDatasource();
    sut = AuthRepositoryImpl(
      remoteDatasource: mockRemote,
      localDatasource: mockLocal,
    );
  });

  group('signInWithGoogle', () {
    test('returns profile and caches it on success', () async {
      when(mockRemote.signInWithGoogle()).thenAnswer((_) async => profile);
      when(mockLocal.saveProfile(profile)).thenAnswer((_) async {});

      final result = await sut.signInWithGoogle();

      expect(result, const Right(profile));
      verify(mockRemote.signInWithGoogle()).called(1);
      verify(mockLocal.saveProfile(profile)).called(1);
    });

    test('returns AuthFailure when remote throws AuthException', () async {
      when(mockRemote.signInWithGoogle()).thenThrow(
        const AuthException(message: 'Sign-in cancelled'),
      );

      final result = await sut.signInWithGoogle();

      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<AuthFailure>());
          expect(failure.message, 'Sign-in cancelled');
        },
        (_) => fail('expected Left'),
      );
      verifyNever(mockLocal.saveProfile(any));
    });
  });

  group('signInAnonymously', () {
    test('returns guest profile and caches it on success', () async {
      when(mockRemote.signInAnonymously()).thenAnswer((_) async => guestProfile);
      when(mockLocal.saveProfile(guestProfile)).thenAnswer((_) async {});

      final result = await sut.signInAnonymously();

      expect(result, const Right(guestProfile));
      verify(mockRemote.signInAnonymously()).called(1);
      verify(mockLocal.saveProfile(guestProfile)).called(1);
    });

    test('returns AuthFailure when remote throws AuthException', () async {
      when(mockRemote.signInAnonymously()).thenThrow(
        const AuthException(message: 'Anonymous auth disabled'),
      );

      final result = await sut.signInAnonymously();

      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<AuthFailure>());
          expect(failure.message, 'Anonymous auth disabled');
        },
        (_) => fail('expected Left'),
      );
    });
  });

  group('signOut', () {
    test('signs out remotely and clears cached profile', () async {
      when(mockRemote.signOut()).thenAnswer((_) async {});
      when(mockLocal.clearProfile()).thenAnswer((_) async {});

      final result = await sut.signOut();

      expect(result, const Right(unit));
      verify(mockRemote.signOut()).called(1);
      verify(mockLocal.clearProfile()).called(1);
    });
  });

  group('getCachedUserProfile', () {
    test('returns cached profile from local datasource', () async {
      when(mockLocal.getCachedProfile()).thenAnswer((_) async => profile);

      final result = await sut.getCachedUserProfile();

      expect(result, const Right(profile));
    });
  });
}
