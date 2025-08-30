import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:wishcrafted/Models/user_model.dart';

enum AuthStatus { unknown, authenticated, unauthenticated, loading }

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
    clientId:
        '677713293845-5mce6vpr1tdfhgsa33i7vt65eg40jmb1.apps.googleusercontent.com',
  );

  // Get current user
  User? get currentUser => _firebaseAuth.currentUser;

  // Stream of auth state changes
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  // Google Sign In
  Future<UserModel?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // User canceled the sign-in
        return null;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credentials
      final UserCredential userCredential = await _firebaseAuth
          .signInWithCredential(credential);

      if (userCredential.user != null) {
        return UserModel.fromFirebaseUser(userCredential.user!);
      }

      return null;
    } catch (e) {
      print('Error signing in with Google: $e');
      throw Exception('فشل في تسجيل الدخول بواسطة Google: $e');
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await Future.wait([_firebaseAuth.signOut(), _googleSignIn.signOut()]);
    } catch (e) {
      print('Error signing out: $e');
      throw Exception('فشل في تسجيل الخروج: $e');
    }
  }

  // Delete account
  Future<void> deleteAccount() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user != null) {
        await user.delete();
        await _googleSignIn.signOut();
      }
    } catch (e) {
      print('Error deleting account: $e');
      throw Exception('فشل في حذف الحساب: $e');
    }
  }

  // Check if user is signed in
  bool get isSignedIn => currentUser != null;

  // Get current user model
  UserModel? getCurrentUserModel() {
    final user = currentUser;
    if (user != null) {
      return UserModel.fromFirebaseUser(user);
    }
    return null;
  }

  // Reload user data
  Future<void> reloadUser() async {
    await currentUser?.reload();
  }
}
