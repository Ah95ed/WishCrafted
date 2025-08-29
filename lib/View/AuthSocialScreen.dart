import 'package:flutter/material.dart';
import 'package:wishcrafted/View/style/AppColors/AppColors.dart';
import 'package:wishcrafted/View/Widgets/CurveClipper/CurveClipper.dart';

class AuthSocialScreen extends StatelessWidget {
  const AuthSocialScreen({super.key});

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
              height: 180,
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
                height: 100,
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
          SafeArea(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.all(16),
              child: Card(
                color: AppColors.card,
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Padding(
                  padding: EdgeInsets.all(24),
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
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textMain,
                        ),
                      ),
                      SizedBox(height: 32),
                      SocialButton(
                        text: 'جوجل',
                        color: Colors.white,
                        textColor: Colors.black87,
                        icon: Icon(
                          Icons.g_mobiledata,
                          size: 24,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          // TODO: Google sign-in logic
                        },
                      ),
                      SizedBox(height: 16),
                      SocialButton(
                        text: 'فيسبوك',
                        color: Color(0xFF1877F3),
                        textColor: Colors.white,
                        icon: Icon(
                          Icons.facebook,
                          size: 24,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          // TODO: Facebook sign-in logic
                        },
                      ),
                      SizedBox(height: 16),
                      SocialButton(
                        text: 'تويتر',
                        color: Color(0xFF1DA1F2),
                        textColor: Colors.white,
                        icon: Icon(
                          Icons.tag,
                          size: 24,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          // TODO: Twitter sign-in logic
                        },
                      ),
                      SizedBox(height: 24),
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