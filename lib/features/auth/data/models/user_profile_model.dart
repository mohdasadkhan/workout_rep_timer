import 'package:fitflow/features/auth/domain/entities/user_profile.dart';

class UserProfileModel {
  final String uid;
  final String? email;
  final String? displayName;
  final String? photoUrl;
  final String? phoneNumber;
  final bool emailVerified;
  final bool isAnonymous;
  final String providerId;
  final String? googleId;
  final String? serverAuthCode;
  final DateTime? createdAt;
  final DateTime? lastSignInAt;
  final List<LinkedProviderInfoModel> linkedProviders;
  final String? accessToken;
  final String? idToken;

  const UserProfileModel({
    required this.uid,
    this.email,
    this.displayName,
    this.photoUrl,
    this.phoneNumber,
    this.emailVerified = false,
    this.isAnonymous = false,
    this.providerId = 'google.com',
    this.googleId,
    this.serverAuthCode,
    this.createdAt,
    this.lastSignInAt,
    this.linkedProviders = const [],
    this.accessToken,
    this.idToken,
  });

  factory UserProfileModel.fromEntity(UserProfile profile) {
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
      accessToken: profile.accessToken,
      idToken: profile.idToken,
    );
  }

  UserProfile toEntity() {
    return UserProfile(
      uid: uid,
      email: email,
      displayName: displayName,
      photoUrl: photoUrl,
      phoneNumber: phoneNumber,
      emailVerified: emailVerified,
      isAnonymous: isAnonymous,
      providerId: providerId,
      googleId: googleId,
      serverAuthCode: serverAuthCode,
      createdAt: createdAt,
      lastSignInAt: lastSignInAt,
      linkedProviders: linkedProviders.map((provider) => provider.toEntity()).toList(),
      accessToken: accessToken,
      idToken: idToken,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'phoneNumber': phoneNumber,
      'emailVerified': emailVerified,
      'isAnonymous': isAnonymous,
      'providerId': providerId,
      'googleId': googleId,
      'serverAuthCode': serverAuthCode,
      'createdAt': createdAt?.toIso8601String(),
      'lastSignInAt': lastSignInAt?.toIso8601String(),
      'linkedProviders': linkedProviders.map((provider) => provider.toJson()).toList(),
    };
  }

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    final providersJson = json['linkedProviders'] as List<dynamic>? ?? const [];

    return UserProfileModel(
      uid: json['uid'] as String? ?? '',
      email: json['email'] as String?,
      displayName: json['displayName'] as String?,
      photoUrl: json['photoUrl'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      emailVerified: json['emailVerified'] as bool? ?? false,
      isAnonymous: json['isAnonymous'] as bool? ?? false,
      providerId: json['providerId'] as String? ?? 'google.com',
      googleId: json['googleId'] as String?,
      serverAuthCode: json['serverAuthCode'] as String?,
      createdAt: _parseDate(json['createdAt'] as String?),
      lastSignInAt: _parseDate(json['lastSignInAt'] as String?),
      linkedProviders: providersJson
          .whereType<Map<String, dynamic>>()
          .map(LinkedProviderInfoModel.fromJson)
          .toList(),
    );
  }

  static DateTime? _parseDate(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }
    return DateTime.tryParse(value);
  }
}

class LinkedProviderInfoModel {
  final String providerId;
  final String? providerUid;
  final String? email;
  final String? displayName;
  final String? photoUrl;
  final String? phoneNumber;

  const LinkedProviderInfoModel({
    required this.providerId,
    this.providerUid,
    this.email,
    this.displayName,
    this.photoUrl,
    this.phoneNumber,
  });

  factory LinkedProviderInfoModel.fromEntity(LinkedProviderInfo info) {
    return LinkedProviderInfoModel(
      providerId: info.providerId,
      providerUid: info.providerUid,
      email: info.email,
      displayName: info.displayName,
      photoUrl: info.photoUrl,
      phoneNumber: info.phoneNumber,
    );
  }

  LinkedProviderInfo toEntity() {
    return LinkedProviderInfo(
      providerId: providerId,
      providerUid: providerUid,
      email: email,
      displayName: displayName,
      photoUrl: photoUrl,
      phoneNumber: phoneNumber,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'providerId': providerId,
      'providerUid': providerUid,
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'phoneNumber': phoneNumber,
    };
  }

  factory LinkedProviderInfoModel.fromJson(Map<String, dynamic> json) {
    return LinkedProviderInfoModel(
      providerId: json['providerId'] as String? ?? '',
      providerUid: json['providerUid'] as String?,
      email: json['email'] as String?,
      displayName: json['displayName'] as String?,
      photoUrl: json['photoUrl'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
    );
  }
}
