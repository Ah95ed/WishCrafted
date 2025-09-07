// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:twitter_login/twitter_login.dart';
// import 'package:wishcrafted/Helper/LogApp/LogApp.dart';

// class TwitterSignInService {
//   static final FirebaseAuth _auth = FirebaseAuth.instance;

//   // Your Twitter API keys - replace with actual values
//   static const String apiKey = 'YOUR_TWITTER_API_KEY';
//   static const String apiSecretKey = 'YOUR_TWITTER_API_SECRET_KEY';
//   static const String redirectURI = 'wishcrafted://';

//   // Sign in with Twitter
// /*************  ✨ Windsurf Command ⭐  *************/
//   /// Signs in to Firebase using Twitter.
//   ///
//   /// This function will open a browser and prompt the user to login to Twitter.
//   /// If the user is already logged in to Twitter, the authentication flow will
//   /// be skipped and the user will be redirected back to the app.
//   ///
//   /// The function will return a [UserCredential] if the login was successful, or
//   /// `null` if the login was cancelled by the user or an error occurred.
//   ///
//   /// If an error occurs, a log entry will be written with the error message.
//   ///
// /*******  08c3cd03-f2a9-4633-8424-b331a8ce9c4a  *******/
//   static Future<UserCredential?> signInWithTwitter() async {
//     try {
//       // Create an instance of TwitterLogin
//       final twitterLogin = TwitterLogin(
//         apiKey: apiKey,
//         apiSecretKey: apiSecretKey,
//         redirectURI: redirectURI,
//       );

//       // Trigger the authentication flow
//       final authResult = await twitterLogin.login();

//       // Check if login was successful
//       switch (authResult.status) {
//         case TwitterLoginStatus.loggedIn:
//           // Create a credential from the access token
//           final twitterAuthCredential = TwitterAuthProvider.credential(
//             accessToken: authResult.authToken!,
//             secret: authResult.authTokenSecret!,
//           );

//           // Sign in to Firebase with the Twitter credential
//           final userCredential = await _auth.signInWithCredential(
//             twitterAuthCredential,
//           );

//           logSuccess(
//             "Twitter login successful: ${userCredential.user?.displayName}",
//           );
//           return userCredential;

//         case TwitterLoginStatus.cancelledByUser:
//           logError('Twitter login cancelled by user');
//           return null;

//         case TwitterLoginStatus.error:
//           logError('Twitter login error: ${authResult.errorMessage}');
//           return null;

//         default:
//           logError('Twitter login unknown status: ${authResult.status}');
//           return null;
//       }
//     } catch (e) {
//       logError('Error signing in with Twitter: $e');
//       rethrow;
//     }
//   }
// }
