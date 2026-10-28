import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GoogleOAuthConfig', () {
    test('reads web client id from oauth_client client_type 3', () {
      const json = {
        'client': [
          {
            'client_info': {
              'android_client_info': {
                'package_name': 'com.asadcoder.fitness.fitflow',
              },
            },
            'oauth_client': [
              {
                'client_id':
                    '645766871209-bca5rmvejn7lvm4u2uga1s7o84pa8lt2.apps.googleusercontent.com',
                'client_type': 1,
              },
              {
                'client_id':
                    '645766871209-examplewebclient.apps.googleusercontent.com',
                'client_type': 3,
              },
            ],
          },
        ],
      };

      final clientId = _readWebClientIdForTest(json);
      expect(
        clientId,
        '645766871209-examplewebclient.apps.googleusercontent.com',
      );
    });

    test('returns null when web oauth client is missing', () {
      const json = {
        'client': [
          {
            'client_info': {
              'android_client_info': {
                'package_name': 'com.asadcoder.fitness.fitflow',
              },
            },
            'oauth_client': [
              {
                'client_id':
                    '645766871209-bca5rmvejn7lvm4u2uga1s7o84pa8lt2.apps.googleusercontent.com',
                'client_type': 1,
              },
            ],
          },
        ],
      };

      expect(_readWebClientIdForTest(json), isNull);
    });
  });
}

String? _readWebClientIdForTest(Map<String, dynamic> json) {
  final clients = json['client'] as List<dynamic>;
  for (final client in clients) {
    final clientMap = client as Map<String, dynamic>;
    final clientInfo = clientMap['client_info'] as Map<String, dynamic>;
    final androidInfo =
        clientInfo['android_client_info'] as Map<String, dynamic>;
    if (androidInfo['package_name'] != 'com.asadcoder.fitness.fitflow') {
      continue;
    }

    final oauthClients = clientMap['oauth_client'] as List<dynamic>;
    for (final oauthClient in oauthClients) {
      final oauthMap = oauthClient as Map<String, dynamic>;
      if (oauthMap['client_type'] == 3) {
        return oauthMap['client_id'] as String;
      }
    }
  }
  return null;
}
