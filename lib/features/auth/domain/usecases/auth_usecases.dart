import 'package:dartz/dartz.dart';
import 'package:fitflow/core/failure/failure.dart';
import 'package:fitflow/core/usecases/usecase.dart';
import 'package:fitflow/features/auth/domain/entities/user_profile.dart';
import 'package:fitflow/features/auth/domain/repositories/auth_repository.dart';

class SignInWithGoogle implements UseCase<UserProfile, NoParams> {
  final AuthRepository _repository;

  SignInWithGoogle(this._repository);

  @override
  Future<Either<Failure, UserProfile>> call(NoParams params) {
    return _repository.signInWithGoogle();
  }
}

class SignInAnonymously implements UseCase<UserProfile, NoParams> {
  final AuthRepository _repository;

  SignInAnonymously(this._repository);

  @override
  Future<Either<Failure, UserProfile>> call(NoParams params) {
    return _repository.signInAnonymously();
  }
}

class SignOut implements UseCase<Unit, NoParams> {
  final AuthRepository _repository;

  SignOut(this._repository);

  @override
  Future<Either<Failure, Unit>> call(NoParams params) {
    return _repository.signOut();
  }
}

class GetCurrentUserProfile implements UseCase<UserProfile?, NoParams> {
  final AuthRepository _repository;

  GetCurrentUserProfile(this._repository);

  @override
  Future<Either<Failure, UserProfile?>> call(NoParams params) {
    return _repository.getCurrentUser();
  }
}

class ClearAuthProfile implements UseCase<Unit, NoParams> {
  final AuthRepository _repository;

  ClearAuthProfile(this._repository);

  @override
  Future<Either<Failure, Unit>> call(NoParams params) {
    return _repository.clearCachedProfile();
  }
}
