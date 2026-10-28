import 'package:equatable/equatable.dart';

/// Identity provider metadata linked to the Firebase account.
class LinkedProviderInfo extends Equatable {
  final String providerId;
  final String? providerUid;
  final String? email;
  final String? displayName;
  final String? photoUrl;
  final String? phoneNumber;

  const LinkedProviderInfo({
    required this.providerId,
    this.providerUid,
    this.email,
    this.displayName,
    this.photoUrl,
    this.phoneNumber,
  });

  LinkedProviderInfo copyWith({
    String? providerId,
    String? providerUid,
    String? email,
    String? displayName,
    String? photoUrl,
    String? phoneNumber,
  }) {
    return LinkedProviderInfo(
      providerId: providerId ?? this.providerId,
      providerUid: providerUid ?? this.providerUid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }

  @override
  List<Object?> get props => [
    providerId,
    providerUid,
    email,
    displayName,
    photoUrl,
    phoneNumber,
  ];
}

/// Aggregated Google + Firebase user profile for settings display.
///
/// [accessToken] and [idToken] are session-only and are not persisted locally.
class UserProfile extends Equatable {
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
  final List<LinkedProviderInfo> linkedProviders;
  final String? accessToken;
  final String? idToken;

  const UserProfile({
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

  bool get isSignedIn => uid.isNotEmpty;

  UserProfile copyWith({
    String? uid,
    String? email,
    String? displayName,
    String? photoUrl,
    String? phoneNumber,
    bool? emailVerified,
    bool? isAnonymous,
    String? providerId,
    String? googleId,
    String? serverAuthCode,
    DateTime? createdAt,
    DateTime? lastSignInAt,
    List<LinkedProviderInfo>? linkedProviders,
    String? accessToken,
    String? idToken,
  }) {
    return UserProfile(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      emailVerified: emailVerified ?? this.emailVerified,
      isAnonymous: isAnonymous ?? this.isAnonymous,
      providerId: providerId ?? this.providerId,
      googleId: googleId ?? this.googleId,
      serverAuthCode: serverAuthCode ?? this.serverAuthCode,
      createdAt: createdAt ?? this.createdAt,
      lastSignInAt: lastSignInAt ?? this.lastSignInAt,
      linkedProviders: linkedProviders ?? this.linkedProviders,
      accessToken: accessToken ?? this.accessToken,
      idToken: idToken ?? this.idToken,
    );
  }

  @override
  List<Object?> get props => [
    uid,
    email,
    displayName,
    photoUrl,
    phoneNumber,
    emailVerified,
    isAnonymous,
    providerId,
    googleId,
    serverAuthCode,
    createdAt,
    lastSignInAt,
    linkedProviders,
    accessToken,
    idToken,
  ];
}
