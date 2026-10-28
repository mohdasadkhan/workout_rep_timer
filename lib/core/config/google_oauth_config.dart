import 'dart:convert';

import 'package:fitflow/core/const/firebase_const.dart';
import 'package:flutter/services.dart';

/// Resolves the Web OAuth client ID used as [GoogleSignIn] `serverClientId` on Android.
class GoogleOAuthConfig {
  GoogleOAuthConfig._();

  static const _googleServicesAsset = 'android/app/google-services.json';
  static const _packageName = 'com.asadcoder.fitness.fitflow';

  static String? _cachedWebClientId;

  static Future<String?> resolveWebClientId() async {
    if (_cachedWebClientId != null) {
      return _cachedWebClientId;
    }

    if (FirebaseConst.serverClientId.isNotEmpty) {
      _cachedWebClientId = FirebaseConst.serverClientId;
      return _cachedWebClientId;
    }

    try {
      final jsonString = await rootBundle.loadString(_googleServicesAsset);
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      _cachedWebClientId = _readWebClientIdFromGoogleServices(json, _packageName);
    } on Object {
      _cachedWebClientId = null;
    }

    return _cachedWebClientId;
  }

  static String? _readWebClientIdFromGoogleServices(
    Map<String, dynamic> json,
    String packageName,
  ) {
    final clients = json['client'] as List<dynamic>?;
    if (clients == null) {
      return null;
    }

    for (final client in clients) {
      final clientMap = client as Map<String, dynamic>;
      final clientInfo = clientMap['client_info'] as Map<String, dynamic>?;
      final androidInfo =
          clientInfo?['android_client_info'] as Map<String, dynamic>?;
      if (androidInfo?['package_name'] != packageName) {
        continue;
      }

      final fromOAuthClients = _findWebClientId(
        clientMap['oauth_client'] as List<dynamic>?,
      );
      if (fromOAuthClients != null) {
        return fromOAuthClients;
      }

      final services = clientMap['services'] as Map<String, dynamic>?;
      final appInvite = services?['appinvite_service'] as Map<String, dynamic>?;
      return _findWebClientId(
        appInvite?['other_platform_oauth_client'] as List<dynamic>?,
      );
    }

    return null;
  }

  static String? _findWebClientId(List<dynamic>? oauthClients) {
    if (oauthClients == null) {
      return null;
    }

    for (final oauthClient in oauthClients) {
      final oauthMap = oauthClient as Map<String, dynamic>;
      if (oauthMap['client_type'] == 3) {
        final clientId = oauthMap['client_id'];
        if (clientId is String && clientId.isNotEmpty) {
          return clientId;
        }
      }
    }

    return null;
  }

  static const missingWebClientMessage =
      'Google Sign-In is missing a Web OAuth client. '
      'In Firebase Console enable Authentication → Sign-in method → Google, '
      'copy the Web client ID (or add a Web app and re-download google-services.json), '
      'then paste it into FirebaseConst.serverClientId or replace android/app/google-services.json.';
}
