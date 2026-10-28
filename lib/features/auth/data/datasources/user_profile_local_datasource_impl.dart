import 'dart:convert';

import 'package:fitflow/core/constants/pref_keys.dart';
import 'package:fitflow/core/failure/cache_exceptions.dart';
import 'package:fitflow/features/auth/data/datasources/auth_datasources.dart';
import 'package:fitflow/features/auth/data/mappers/auth_profile_mapper.dart';
import 'package:fitflow/features/auth/data/models/user_profile_model.dart';
import 'package:fitflow/features/auth/domain/entities/user_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfileLocalDatasourceImpl implements UserProfileLocalDatasource {
  final SharedPreferences _prefs;

  const UserProfileLocalDatasourceImpl({required SharedPreferences prefs})
    : _prefs = prefs;

  @override
  Future<UserProfile?> getCachedProfile() async {
    final jsonString = _prefs.getString(PrefKeys.userProfile);
    if (jsonString == null || jsonString.isEmpty) {
      return null;
    }

    try {
      final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
      return UserProfileModel.fromJson(jsonMap).toEntity();
    } catch (e) {
      throw CacheException(message: 'Failed to load cached profile: $e');
    }
  }

  @override
  Future<void> saveProfile(UserProfile profile) async {
    try {
      final model = AuthProfileMapper.toPersistedModel(profile);
      await _prefs.setString(
        PrefKeys.userProfile,
        jsonEncode(model.toJson()),
      );
    } catch (e) {
      throw CacheException(message: 'Failed to save profile: $e');
    }
  }

  @override
  Future<void> clearProfile() async {
    try {
      await _prefs.remove(PrefKeys.userProfile);
    } catch (e) {
      throw CacheException(message: 'Failed to clear profile: $e');
    }
  }
}
