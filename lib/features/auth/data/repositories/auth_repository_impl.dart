import 'package:dartz/dartz.dart';
import 'package:fitflow/core/failure/auth_exceptions.dart';
import 'package:fitflow/core/failure/cache_exceptions.dart';
import 'package:fitflow/core/failure/failure.dart';
import 'package:fitflow/features/auth/data/datasources/auth_datasources.dart';
import 'package:fitflow/features/auth/domain/entities/user_profile.dart';
import 'package:fitflow/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource _remoteDatasource;
  final UserProfileLocalDatasource _localDatasource;

  const AuthRepositoryImpl({
    required AuthRemoteDatasource remoteDatasource,
    required UserProfileLocalDatasource localDatasource,
  }) : _remoteDatasource = remoteDatasource,
       _localDatasource = localDatasource;

  @override
  Future<Either<Failure, UserProfile>> signInWithGoogle() async {
    try {
      final profile = await _remoteDatasource.signInWithGoogle();
      await _localDatasource.saveProfile(profile);
      return Right(profile);
    } on AuthException catch (e) {
      return Left(AuthFailure(message: e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(AuthFailure(message: 'Sign-in failed: $e'));
    }
  }

  @override
  Future<Either<Failure, UserProfile>> signInAnonymously() async {
    try {
      final profile = await _remoteDatasource.signInAnonymously();
      await _localDatasource.saveProfile(profile);
      return Right(profile);
    } on AuthException catch (e) {
      return Left(AuthFailure(message: e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(AuthFailure(message: 'Anonymous sign-in failed: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> signOut() async {
    try {
      await _remoteDatasource.signOut();
      await _localDatasource.clearProfile();
      return const Right(unit);
    } on AuthException catch (e) {
      return Left(AuthFailure(message: e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(AuthFailure(message: 'Sign-out failed: $e'));
    }
  }

  @override
  Future<Either<Failure, UserProfile?>> getCurrentUser() async {
    try {
      final profile = await _remoteDatasource.getCurrentUser();
      if (profile != null) {
        await _localDatasource.saveProfile(profile);
      }
      return Right(profile);
    } on AuthException catch (e) {
      return Left(AuthFailure(message: e.message));
    } catch (e) {
      return Left(AuthFailure(message: 'Failed to load current user: $e'));
    }
  }

  @override
  Future<Either<Failure, UserProfile?>> getCachedUserProfile() async {
    try {
      final profile = await _localDatasource.getCachedProfile();
      return Right(profile);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to load cached profile: $e'));
    }
  }

  @override
  Stream<UserProfile?> watchAuthState() {
    return _remoteDatasource.authStateChanges().asyncMap((profile) async {
      if (profile != null) {
        await _localDatasource.saveProfile(profile);
      } else {
        await _localDatasource.clearProfile();
      }
      return profile;
    });
  }

  @override
  Future<Either<Failure, Unit>> clearCachedProfile() async {
    try {
      await _localDatasource.clearProfile();
      return const Right(unit);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to clear profile: $e'));
    }
  }
}
