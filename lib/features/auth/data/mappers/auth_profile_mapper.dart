import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitflow/features/auth/data/models/user_profile_model.dart';
import 'package:fitflow/features/auth/domain/entities/user_profile.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthProfileMapper {
  const AuthProfileMapper._();

  static UserProfile fromFirebaseAndGoogle({
    required User firebaseUser,
    required GoogleSignInAccount googleAccount,
    String? accessToken,
    String? idToken,
    String? serverAuthCode,
  }) {
    final linkedProviders = firebaseUser.providerData
        .map(
          (info) => LinkedProviderInfo(
            providerId: info.providerId,
            providerUid: info.uid,
            email: info.email,
            displayName: info.displayName,
            photoUrl: info.photoURL,
            phoneNumber: info.phoneNumber,
          ),
        )
        .toList();

    final googleProvider = linkedProviders.firstWhere(
      (provider) => provider.providerId == 'google.com',
      orElse: () => LinkedProviderInfo(
        providerId: 'google.com',
        providerUid: googleAccount.id,
        email: googleAccount.email,
        displayName: googleAccount.displayName,
        photoUrl: googleAccount.photoUrl,
      ),
    );

    return UserProfile(
      uid: firebaseUser.uid,
      email: firebaseUser.email ?? googleAccount.email,
      displayName: firebaseUser.displayName ?? googleAccount.displayName,
      photoUrl: firebaseUser.photoURL ?? googleAccount.photoUrl,
      phoneNumber: firebaseUser.phoneNumber,
      emailVerified: firebaseUser.emailVerified,
      isAnonymous: firebaseUser.isAnonymous,
      providerId: googleProvider.providerId,
      googleId: googleAccount.id,
      serverAuthCode: serverAuthCode,
      createdAt: firebaseUser.metadata.creationTime,
      lastSignInAt: firebaseUser.metadata.lastSignInTime,
      linkedProviders: linkedProviders,
      accessToken: accessToken,
      idToken: idToken ?? googleAccount.authentication.idToken,
    );
  }

  static UserProfile? fromFirebaseUser(User? firebaseUser) {
    if (firebaseUser == null) {
      return null;
    }

    final linkedProviders = firebaseUser.providerData
        .map(
          (info) => LinkedProviderInfo(
            providerId: info.providerId,
            providerUid: info.uid,
            email: info.email,
            displayName: info.displayName,
            photoUrl: info.photoURL,
            phoneNumber: info.phoneNumber,
          ),
        )
        .toList();

    final googleProvider = linkedProviders
        .where((provider) => provider.providerId == 'google.com')
        .cast<LinkedProviderInfo?>()
        .firstWhere(
          (provider) => provider != null,
          orElse: () => linkedProviders.isNotEmpty ? linkedProviders.first : null,
        );

    return UserProfile(
      uid: firebaseUser.uid,
      email: firebaseUser.email,
      displayName: firebaseUser.displayName ??
          (firebaseUser.isAnonymous ? 'Guest' : null),
      photoUrl: firebaseUser.photoURL,
      phoneNumber: firebaseUser.phoneNumber,
      emailVerified: firebaseUser.emailVerified,
      isAnonymous: firebaseUser.isAnonymous,
      providerId: firebaseUser.isAnonymous
          ? 'anonymous'
          : (googleProvider?.providerId ?? 'password'),
      googleId: googleProvider?.providerUid,
      createdAt: firebaseUser.metadata.creationTime,
      lastSignInAt: firebaseUser.metadata.lastSignInTime,
      linkedProviders: linkedProviders,
    );
  }

  static UserProfileModel toPersistedModel(UserProfile profile) {
    return UserProfileModel(
      uid: profile.uid,
      email: profile.email,
      displayName: profile.displayName,
      photoUrl: profile.photoUrl,
      phoneNumber: profile.phoneNumber,
      emailVerified: profile.emailVerified,
      isAnonymous: profile.isAnonymous,
      providerId: profile.providerId,
      googleId: profile.googleId,
      serverAuthCode: profile.serverAuthCode,
      createdAt: profile.createdAt,
      lastSignInAt: profile.lastSignInAt,
      linkedProviders: profile.linkedProviders
          .map(LinkedProviderInfoModel.fromEntity)
          .toList(),
    );
  }
}
