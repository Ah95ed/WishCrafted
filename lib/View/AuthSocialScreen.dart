import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wishcrafted/Helper/Service/googleService.dart';
import 'package:wishcrafted/View/style/AppColors/AppColors.dart';
import 'package:wishcrafted/View/Widgets/CurveClipper/CurveClipper.dart';
import 'package:wishcrafted/View/style/SizeApp/ScreenSize.dart';

class AuthSocialScreen extends StatefulWidget {
  const AuthSocialScreen({super.key});

  @override
  State<AuthSocialScreen> createState() => _AuthSocialScreenState();
}

class _AuthSocialScreenState extends State<AuthSocialScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    GoogleSignInService.initSignIn();
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
                          UserCredential? s =
                              await GoogleSignInService.signInWithGoogle();
                       
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
