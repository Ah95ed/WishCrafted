// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
// import 'package:wishcrafted/Helper/LogApp/LogApp.dart';

// class FacebookSignInService {
//   static final FirebaseAuth _auth = FirebaseAuth.instance;

//   // Sign in with Facebook
//   static Future<UserCredential?> signInWithFacebook() async {
//     try {
//       // Trigger the sign-in flow
//       final LoginResult loginResult = await FacebookAuth.instance.login();

//       // Check if login was successful
//       if (loginResult.status == LoginStatus.success) {
//         // Get access token
//         // final AccessToken accessToken = loginResult.accessToken!;

//         // Create a credential from the access token
//         final OAuthCredential facebookAuthCredential =
//             FacebookAuthProvider.credential(accessToken.tokenString);

//         // Sign in to Firebase with the Facebook credential
//         final UserCredential userCredential = await _auth.signInWithCredential(
//           facebookAuthCredential,
//         );

//         logSuccess(
//           "Facebook login successful: ${userCredential.user?.displayName}",
//         );
//         return userCredential;
//       } else {
//         // Handle login failures
//         logError('Facebook login failed: ${loginResult.status}');
//         logError('Message: ${loginResult.message}');
//         return null;
//       }
//     } catch (e) {
//       logError('Error signing in with Facebook: $e');
//       rethrow;
//     }
//   }

//   // Sign out
//   static Future<void> signOut() async {
//     try {
//       await FacebookAuth.instance.logOut();
//     } catch (e) {
//       logError('Error signing out from Facebook: $e');
//       rethrow;
//     }
//   }
// }
