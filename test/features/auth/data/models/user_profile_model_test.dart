import 'package:fitflow/features/auth/data/mappers/auth_profile_mapper.dart';
import 'package:fitflow/features/auth/data/models/user_profile_model.dart';
import 'package:fitflow/features/auth/domain/entities/user_profile.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const sampleProfile = UserProfile(
    uid: 'firebase-uid',
    email: 'user@gmail.com',
    displayName: 'FitFlow User',
    photoUrl: 'https://example.com/photo.png',
    phoneNumber: '+10000000000',
    emailVerified: true,
    isAnonymous: false,
    providerId: 'google.com',
    googleId: 'google-id',
    serverAuthCode: 'server-code',
    createdAt: null,
    lastSignInAt: null,
    linkedProviders: [
      LinkedProviderInfo(
        providerId: 'google.com',
        providerUid: 'google-id',
        email: 'user@gmail.com',
        displayName: 'FitFlow User',
        photoUrl: 'https://example.com/photo.png',
      ),
    ],
    accessToken: 'access-token',
    idToken: 'id-token',
  );

  group('UserProfileModel', () {
    test('round-trips through json without session tokens', () {
      final model = AuthProfileMapper.toPersistedModel(sampleProfile);
      final restored = UserProfileModel.fromJson(model.toJson()).toEntity();

      expect(restored.uid, sampleProfile.uid);
      expect(restored.email, sampleProfile.email);
      expect(restored.googleId, sampleProfile.googleId);
      expect(restored.linkedProviders, sampleProfile.linkedProviders);
      expect(restored.accessToken, isNull);
      expect(restored.idToken, isNull);
    });
  });

  group('AuthProfileMapper', () {
    test('strips session tokens from persisted model', () {
      final persisted = AuthProfileMapper.toPersistedModel(sampleProfile);

      expect(persisted.accessToken, isNull);
      expect(persisted.idToken, isNull);
      expect(persisted.email, sampleProfile.email);
    });
  });
}
