import 'package:fitflow/core/constants/pref_keys.dart';
import 'package:fitflow/features/auth/data/datasources/user_profile_local_datasource_impl.dart';
import 'package:fitflow/features/auth/domain/entities/user_profile.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  const profile = UserProfile(
    uid: 'uid-1',
    email: 'user@gmail.com',
    displayName: 'FitFlow User',
    photoUrl: 'https://example.com/photo.png',
    providerId: 'google.com',
    googleId: 'google-id',
    emailVerified: true,
  );

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('saves and loads cached profile', () async {
    final prefs = await SharedPreferences.getInstance();
    final datasource = UserProfileLocalDatasourceImpl(prefs: prefs);

    await datasource.saveProfile(profile);
    final loaded = await datasource.getCachedProfile();

    expect(loaded, profile);
    expect(prefs.getString(PrefKeys.userProfile), isNotNull);
  });

  test('clearProfile removes cached profile', () async {
    final prefs = await SharedPreferences.getInstance();
    final datasource = UserProfileLocalDatasourceImpl(prefs: prefs);

    await datasource.saveProfile(profile);
    await datasource.clearProfile();

    expect(await datasource.getCachedProfile(), isNull);
    expect(prefs.getString(PrefKeys.userProfile), isNull);
  });
}
