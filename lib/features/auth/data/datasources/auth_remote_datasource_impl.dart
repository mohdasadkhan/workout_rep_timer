import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitflow/core/config/google_oauth_config.dart';
import 'package:fitflow/core/failure/auth_exceptions.dart';
import 'package:fitflow/features/auth/data/datasources/auth_datasources.dart';
import 'package:fitflow/features/auth/data/mappers/auth_profile_mapper.dart';
import 'package:fitflow/features/auth/domain/entities/user_profile.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  AuthRemoteDatasourceImpl({
    FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
  }) : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
       _googleSignIn = googleSignIn ?? GoogleSignIn.instance;

  @override
  Future<UserProfile> signInWithGoogle() async {
    try {
      final webClientId = await GoogleOAuthConfig.resolveWebClientId();
      if (webClientId == null || webClientId.isEmpty) {
        throw AuthException(message: GoogleOAuthConfig.missingWebClientMessage);
      }

      await _googleSignIn.signOut();

      final googleUser = await _googleSignIn.authenticate();
      final googleAuth = googleUser.authentication;

      if (googleAuth.idToken == null || googleAuth.idToken!.isEmpty) {
        throw const AuthException(
          message:
              'Google did not return an ID token. '
              'Re-download google-services.json from Firebase after enabling Google sign-in.',
        );
      }

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      final userCredential = await _signInOrLinkGoogle(credential: credential);
      final firebaseUser = userCredential.user;
      if (firebaseUser == null) {
        throw const AuthException(
          message: 'Firebase user is null after Google sign-in',
        );
      }

      return AuthProfileMapper.fromFirebaseAndGoogle(
        firebaseUser: firebaseUser,
        googleAccount: googleUser,
        idToken: googleAuth.idToken,
      );
    } on GoogleSignInException catch (e) {
      throw AuthException(message: _googleSignInMessage(e));
    } on FirebaseAuthException catch (e) {
      throw AuthException(message: _firebaseAuthMessage(e));
    } on AuthException {
      rethrow;
    } catch (e) {
      throw AuthException(message: _genericGoogleSignInMessage(e));
    }
  }

  Future<UserCredential> _signInOrLinkGoogle({
    required AuthCredential credential,
  }) async {
    final currentUser = _firebaseAuth.currentUser;

    if (currentUser != null && currentUser.isAnonymous) {
      try {
        return await currentUser.linkWithCredential(credential);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'credential-already-in-use') {
          throw const AuthException(
            message:
                'This Google account is already linked to another FitFlow profile.',
          );
        }
        if (e.code == 'provider-already-linked') {
          return _firebaseAuth.signInWithCredential(credential);
        }
        rethrow;
      }
    }

    return _firebaseAuth.signInWithCredential(credential);
  }

  String _googleSignInMessage(GoogleSignInException e) {
    if (e.code == GoogleSignInExceptionCode.canceled) {
      return 'Sign-in cancelled';
    }
    if (e.code == GoogleSignInExceptionCode.clientConfigurationError) {
      return GoogleOAuthConfig.missingWebClientMessage;
    }

    final description = e.description ?? '';
    if (_isDeletedClientError(description)) {
      return _deletedClientMessage;
    }
    if (description.contains('28444') ||
        description.toLowerCase().contains('developer console')) {
      return 'Google Sign-In is misconfigured. Re-download google-services.json '
          'from Firebase after enabling Google sign-in, then rebuild the app.';
    }

    return description.isNotEmpty
        ? description
        : 'Google sign-in failed (${e.code.name})';
  }

  String _genericGoogleSignInMessage(Object error) {
    final message = error.toString();
    if (_isDeletedClientError(message)) {
      return _deletedClientMessage;
    }
    return 'Google sign-in failed: $message';
  }

  bool _isDeletedClientError(String message) {
    final lower = message.toLowerCase();
    return lower.contains('deleted_client') ||
        lower.contains('oauth client was deleted') ||
        lower.contains('authorisation error') ||
        lower.contains('authorization error');
  }

  static const _deletedClientMessage =
      'Your Firebase Google OAuth client was deleted. '
      'In Firebase Console open Authentication → Sign-in method → Google, '
      'disable and re-enable Google, download a new google-services.json, '
      'replace android/app/google-services.json, then run flutter clean && flutter run.';

  @override
  Future<UserProfile> signInAnonymously() async {
    try {
      final userCredential = await _firebaseAuth.signInAnonymously();
      final firebaseUser = userCredential.user;
      if (firebaseUser == null) {
        throw const AuthException(
          message: 'Firebase user is null after anonymous sign-in',
        );
      }

      final profile = AuthProfileMapper.fromFirebaseUser(firebaseUser);
      if (profile == null) {
        throw const AuthException(message: 'Could not build guest profile');
      }
      return profile;
    } on FirebaseAuthException catch (e) {
      throw AuthException(message: _firebaseAuthMessage(e));
    } catch (e) {
      throw AuthException(message: 'Anonymous sign-in failed: $e');
    }
  }

  String _firebaseAuthMessage(FirebaseAuthException e) {
    if (e.code == 'operation-not-allowed') {
      return 'Google sign-in is disabled in Firebase Console. '
          'Enable it under Authentication → Sign-in method → Google.';
    }
    final message = e.message ?? '';
    if (_isDeletedClientError(message)) {
      return _deletedClientMessage;
    }
    return e.message ?? 'Firebase authentication failed (${e.code})';
  }

  @override
  Future<void> signOut() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
        _googleSignIn.signOut(),
      ]);
    } catch (e) {
      throw AuthException(message: 'Sign-out failed: $e');
    }
  }

  @override
  Future<UserProfile?> getCurrentUser() async {
    return AuthProfileMapper.fromFirebaseUser(_firebaseAuth.currentUser);
  }

  @override
  Stream<UserProfile?> authStateChanges() {
    return _firebaseAuth.authStateChanges().map(
      AuthProfileMapper.fromFirebaseUser,
    );
  }
}

/// Android requires a Web OAuth client ID as [serverClientId] for Firebase Auth.
Future<void> initializeGoogleSignIn() async {
  final webClientId = await GoogleOAuthConfig.resolveWebClientId();
  if (webClientId == null || webClientId.isEmpty) {
    return;
  }

  await GoogleSignIn.instance.initialize(serverClientId: webClientId);
}
