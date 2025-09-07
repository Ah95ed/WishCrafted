import 'package:firebase_auth/firebase_auth.dart';
import 'package:wishcrafted/Helper/LogApp/LogApp.dart';
import 'package:wishcrafted/Helper/Service/googleService.dart';
import 'package:wishcrafted/Helper/Service/facebookService.dart';

enum AuthProvider { google }

class AuthenticationService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user
  static User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Check if user is logged in
  static bool isLoggedIn() {
    return _auth.currentUser != null;
  }

  // Sign in with a specific provider
  static Future<UserCredential?> signInWithProvider(
    AuthProvider provider,
  ) async {
    try {
      switch (provider) {
        case AuthProvider.google:
          return await GoogleSignInService.signInWithGoogle();
        // case AuthProvider.facebook:
        //   return await FacebookSignInService.signInWithFacebook();
        // case AuthProvider.twitter:
        //   return await TwitterSignInService.signInWithTwitter();
      }
    } catch (e) {
      logError('Error signing in with ${provider.toString()}: $e');
      rethrow;
    }
  }

  // Sign out from all providers
  static Future<void> signOut() async {
    try {
      // Sign out from Firebase
      await _auth.signOut();

      // Sign out from Google (if signed in)
      try {
        await GoogleSignInService.signOut();
      } catch (e) {
        logError('Error signing out from Google: $e');
      }

      // Sign out from Facebook (if signed in)
      try {
        // await FacebookSignInService.signOut();
      } catch (e) {
        logError('Error signing out from Facebook: $e');
      }

      // No explicit sign out method for Twitter in our implementation
    } catch (e) {
      logError('Error signing out: $e');
      rethrow;
    }
  }
}
