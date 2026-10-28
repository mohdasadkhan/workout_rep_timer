import 'package:dartz/dartz.dart';
import 'package:fitflow/core/failure/failure.dart';
import 'package:fitflow/features/auth/domain/entities/user_profile.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserProfile>> signInWithGoogle();

  Future<Either<Failure, UserProfile>> signInAnonymously();

  Future<Either<Failure, Unit>> signOut();

  Future<Either<Failure, UserProfile?>> getCurrentUser();

  Future<Either<Failure, UserProfile?>> getCachedUserProfile();

  Stream<UserProfile?> watchAuthState();

  Future<Either<Failure, Unit>> clearCachedProfile();
}
