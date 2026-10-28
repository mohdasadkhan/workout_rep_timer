import 'package:fitflow/features/auth/domain/entities/user_profile.dart';

abstract class AuthRemoteDatasource {
  Future<UserProfile> signInWithGoogle();

  Future<UserProfile> signInAnonymously();

  Future<void> signOut();

  Future<UserProfile?> getCurrentUser();

  Stream<UserProfile?> authStateChanges();
}

abstract class UserProfileLocalDatasource {
  Future<UserProfile?> getCachedProfile();

  Future<void> saveProfile(UserProfile profile);

  Future<void> clearProfile();
}
