import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:wishcrafted/Helper/LogApp/LogApp.dart';
import 'package:wishcrafted/Helper/Service/googleService.dart';
import 'package:wishcrafted/View/DashBoardScreen/DashboardScreen.dart';
import 'package:wishcrafted/View/style/AppColors/AppColors.dart';
import 'package:wishcrafted/View/Widgets/CurveClipper/CurveClipper.dart';
import 'package:wishcrafted/View/style/SizeApp/ScreenSize.dart';

class AuthSocialScreen extends StatefulWidget {
  const AuthSocialScreen({super.key});

  @override
  State<AuthSocialScreen> createState() => _AuthSocialScreenState();
}

class _AuthSocialScreenState extends State<AuthSocialScreen> {
  GoogleSignInAccount? _currentUser;
  late GoogleSignIn signIn;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // GoogleSignInService.initSignIn();
     signIn = GoogleSignIn.instance;
     signIn.initialize(serverClientId: '141006181667-na7a8q4ll7qvesejt11khvr6tu20s4p3.apps.googleusercontent.com');
    // unawaited(
    //   signIn.initialize().then((_) {
    //     signIn.authenticationEvents
    //         .listen(_handleAuthenticationEvent)
    //         .onError(_handleAuthenticationError);

    //     /// This example always uses the stream-based approach to determining
    //     /// which UI state to show, rather than using the future returned here,
    //     /// if any, to conditionally skip directly to the signed-in state.
    //     signIn.attemptLightweightAuthentication();
    //   }),
    // );
  }

  Future<void> _handleAuthenticationEvent(
    GoogleSignInAuthenticationEvent event,
  ) async {
    // #docregion CheckAuthorization
    final GoogleSignInAccount? user = // ...
        // #enddocregion CheckAuthorization
        switch (event) {
          GoogleSignInAuthenticationEventSignIn() => event.user,
          GoogleSignInAuthenticationEventSignOut() => null,
        };

    // Check for existing authorization.
    // #docregion CheckAuthorization
    final GoogleSignInClientAuthorization? authorization = await user
        ?.authorizationClient
        .authorizationForScopes(scopes);
    // #enddocregion CheckAuthorization

    setState(() {
      // _currentUser = user;
      // _isAuthorized = authorization != null;
      // _errorMessage = '';
    });

    // If the user has already granted access to the required scopes, call the
    // REST API.
    if (user != null && authorization != null) {
      unawaited(_handleGetContact(user));
    }
  }

  List<String> scopes = <String>[
    'https://www.googleapis.com/auth/contacts.readonly',
  ];
  Future<void> _handleGetContact(GoogleSignInAccount user) async {
    setState(() {
      // _contactText = 'Loading contact info...';
    });
    final Map<String, String>? headers = await user.authorizationClient
        .authorizationHeaders(scopes);
    if (headers == null) {
      setState(() {
        // _contactText = '';
        // _errorMessage = 'Failed to construct authorization headers.';
      });
      return;
    }
    final http.Response response = await http.get(
      Uri.parse(
        'https://people.googleapis.com/v1/people/me/connections?personFields=names,emailAddresses,phoneNumbers',
      ),
      headers: headers,
    );
    if (response.statusCode != 200) {
      if (response.statusCode == 401 || response.statusCode == 403) {
        setState(() {
          // _isAuthorized = false;
          // _errorMessage = 'People API gave a ${response.statusCode} response. '
          'Please re-authorize access.';
        });
      } else {
        print('People API ${response.statusCode} response: ${response.body}');
        setState(() {
          // _contactText = 'People API gave a ${response.statusCode} '
          // 'response. Check logs for details.';
        });
      }
      return;
    }
    final Map<String, dynamic> data =
        json.decode(response.body) as Map<String, dynamic>;
    final String? namedContact = _pickFirstNamedContact(data);
    setState(() {
      if (namedContact != null) {
        // _contactText = 'I see you know $namedContact!';
      } else {
        // _contactText = 'No contacts to display.';
      }
    });
  }

  String? _pickFirstNamedContact(Map<String, dynamic> data) {
    final List<dynamic>? connections = data['connections'] as List<dynamic>?;
    final Map<String, dynamic>? contact =
        connections?.firstWhere(
              (dynamic contact) =>
                  (contact as Map<Object?, dynamic>)['names'] != null,
              orElse: () => null,
            )
            as Map<String, dynamic>?;
    if (contact != null) {
      final List<dynamic> names = contact['names'] as List<dynamic>;
      final Map<String, dynamic>? name =
          names.firstWhere(
                (dynamic name) =>
                    (name as Map<Object?, dynamic>)['displayName'] != null,
                orElse: () => null,
              )
              as Map<String, dynamic>?;
      if (name != null) {
        return name['displayName'] as String?;
      }
    }
    return null;
  }

  Future<void> _handleAuthenticationError(Object e) async {
    setState(() {
      // _currentUser = null;
      // _isAuthorized = false;
      // _errorMessage = e is GoogleSignInException
      //     ? _errorMessageFromSignInException(e)
      //     : 'Unknown error: $e';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // منحنى علوي
          ClipPath(
            clipper: TopCurveClipper(),
            child: Container(
              height: context.getHeight(100),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.curveTop1, AppColors.curveTop2],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
          // منحنى سفلي
          Align(
            alignment: Alignment.bottomCenter,
            child: ClipPath(
              clipper: BottomCurveClipper(),
              child: Container(
                height: context.getHeight(80),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.curveBottom1, AppColors.curveBottom2],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
          ),
          // المحتوى مع Scroll
          Center(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.all(context.getMinSize(10)),
              child: Card(
                color: AppColors.card,
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Padding(
                  padding: EdgeInsets.all(context.getMinSize(10)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: AppColors.accent,
                        child: Icon(Icons.share, size: 48, color: Colors.white),
                      ),
                      SizedBox(height: 24),
                      Text(
                        'تسجيل الدخول عبر وسائل التواصل',
                        style: TextStyle(
                          fontSize: context.getFontSize(18),
                          fontWeight: FontWeight.bold,
                          color: AppColors.textMain,
                        ),
                      ),
                      SizedBox(height: context.getHeight(18)),
                      SocialButton(
                        text: 'جوجل',
                        color: AppColors.curveTop1,
                        textColor: AppColors.textMain,
                        icon: Icon(
                          Icons.g_mobiledata,
                          size: 30,
                          color: Colors.red,
                        ),
                        onPressed: () async {
                          
                          try {
                            await signIn.authenticate();
                            final GoogleSignInAccount? user = _currentUser;
                            if (user != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) {
                                    return DashboardScreen();
                                  },
                                ),
                              );
                            }
                          } catch (e) {
                            // #enddocregion ExplicitSignIn
                            logError('message:==== ${e.toString()}');
                            // #docregion ExplicitSignIn
                          }
                          //  GoogleSignInAccount sign = await GoogleSignIn.instance.authenticate();
                        },
                      ),
                      SizedBox(height: context.getHeight(18)),
                      SocialButton(
                        text: 'فيسبوك',
                        color: AppColors.curveTop1,
                        textColor: AppColors.textMain,
                        icon: Icon(
                          Icons.facebook,
                          size: 24,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          // TODO: Facebook sign-in logic
                        },
                      ),
                      SizedBox(height: context.getHeight(18)),
                      SocialButton(
                        text: 'تويتر',
                        color: AppColors.curveTop1,
                        textColor: AppColors.textMain,
                        icon: Icon(Icons.tag, size: 24, color: Colors.white),
                        onPressed: () {
                          // TODO: Twitter sign-in logic
                        },
                      ),
                      SizedBox(height: context.getHeight(18)),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('العودة'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SocialButton extends StatelessWidget {
  final String text;
  final Color color;
  final Color textColor;
  final Widget icon;
  final VoidCallback onPressed;

  const SocialButton({
    super.key,
    required this.text,
    required this.color,
    required this.textColor,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: textColor,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        icon: icon,
        label: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }
}
