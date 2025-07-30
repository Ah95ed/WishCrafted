import 'package:flutter/material.dart';

class AuthSocialScreen extends StatelessWidget {
  const AuthSocialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[50],
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            child: Padding(
              padding: const EdgeInsets.all(28.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.deepPurple,
                    child: Icon(Icons.person, size: 48, color: Colors.white),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'تسجيل الدخول عبر وسائل التواصل',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple[700],
                    ),
                  ),
                  const SizedBox(height: 32),
                  SocialButton(
                    text: 'تسجيل الدخول بواسطة جوجل',
                    color: Colors.white,
                    textColor: Colors.black87,
                    icon: const Icon(
                      Icons.ac_unit,
                      size: 24,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      
                    },
                  ),
                  const SizedBox(height: 16),
                  SocialButton(
                    text: 'تسجيل الدخول بواسطة فيسبوك',
                    color: const Color(0xFF1877F3),
                    textColor: Colors.white,
                    icon: const Icon(
                      Icons.ac_unit,
                      size: 24,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      // TODO: Facebook sign-in logic
                    },
                  ),
                  const SizedBox(height: 16),
                  SocialButton(
                    text: 'تسجيل الدخول بواسطة تويتر',
                    color: const Color(0xFF1DA1F2),
                    textColor: Colors.white,
                    icon: const Icon(
                      Icons.ac_unit,
                      size: 24,
                      color: Colors.white,
                    ),
                    // icon: Image.asset(
                    //   // 'assets/twitter.png',
                    //   height: 24,
                    //   width: 24,
                    // ),
                    onPressed: () {
                      // TODO: Twitter sign-in logic
                    },
                  ),
                  const SizedBox(height: 24),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('العودة'),
                  ),
                ],
              ),
            ),
          ),
        ),
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
