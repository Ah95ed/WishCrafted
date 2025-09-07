import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:wishcrafted/Helper/Service/initService.dart';
import 'package:wishcrafted/Controller/auth_provider.dart';
import 'package:wishcrafted/View/style/AppColors/AppColors.dart';
import 'package:wishcrafted/View/Widgets/CurveClipper/CurveClipper.dart';
import 'package:wishcrafted/View/DashBoardScreen/DashboardScreen.dart';
import 'package:wishcrafted/View/LoginScreen.dart';
import 'package:wishcrafted/View/style/SizeApp/ScreenSize.dart';

import 'onBorder/onBorderScreen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String confirmPassword = '';
  String phoneNumber = '';
  bool isObscure = true;
  bool isConfirmObscure = true;
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _passwordConfirm = TextEditingController();
  final TextEditingController _phoneNumber = TextEditingController();

  /// Helper method to clean and format phone number for use as userId
  String _cleanPhoneNumber(String phone) {
    // Remove spaces, dashes, and parentheses
    String cleaned = phone.replaceAll(RegExp(r'[\s\-\(\)]'), '');

    // Remove leading + if present for cleaner userId
    if (cleaned.startsWith('+')) {
      cleaned = cleaned.substring(1);
    }

    return cleaned;
  }

  late final GoogleSignIn signIn;
  @override
  void initState() {
    signIn = GoogleSignIn.instance;
    signIn.initialize();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _passwordConfirm.dispose();
    _phoneNumber.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
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
              padding: EdgeInsets.all(context.getMinSize(12)),
              child: Card(
                color: AppColors.card,
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Padding(
                  padding: EdgeInsets.all(context.getMinSize(16)),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          radius: context.getMinSize(32),
                          backgroundColor: AppColors.accent,
                          child: Icon(
                            Icons.person_add,
                            size: context.getMinSize(32),
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: context.getHeight(8)),
                        Text(
                          'إنشاء حساب جديد',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textMain,
                          ),
                        ),
                        SizedBox(height: context.getHeight(8)),
                        TextFormField(
                          controller: _email,
                          decoration: InputDecoration(
                            labelText: 'البريد الإلكتروني',
                            prefixIcon: Icon(Icons.email),
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'يرجى إدخال البريد الإلكتروني';
                            }
                            if (!value.contains('@')) {
                              return 'يرجى إدخال بريد إلكتروني صحيح';
                            }
                            return null;
                          },
                          onSaved: (value) => email = value ?? '',
                        ),
                        SizedBox(height: context.getHeight(8)),
                        TextFormField(
                          controller: _phoneNumber,
                          decoration: InputDecoration(
                            labelText: 'رقم الهاتف',
                            prefixIcon: Icon(Icons.phone),
                            border: OutlineInputBorder(),
                            hintText: '+966XXXXXXXXX',
                          ),
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'يرجى إدخال رقم الهاتف';
                            }
                            // Remove spaces and dashes
                            String cleanPhone = value.replaceAll(
                              RegExp(r'[\s-]'),
                              '',
                            );

                            // Check for valid phone number format
                            if (!RegExp(
                              r'^[+]?[0-9]{10,15}$',
                            ).hasMatch(cleanPhone)) {
                              return 'يرجى إدخال رقم هاتف صحيح (10-15 رقم)';
                            }

                            // Saudi phone number validation (optional)
                            if (cleanPhone.startsWith('+966') ||
                                cleanPhone.startsWith('966')) {
                              if (!RegExp(
                                r'^(\+966|966)?[0-9]{9}$',
                              ).hasMatch(cleanPhone)) {
                                return 'رقم الهاتف السعودي يجب أن يكون 9 أرقام بعد 966';
                              }
                            }

                            return null;
                          },
                          onSaved: (value) => phoneNumber = value ?? '',
                        ),
                        SizedBox(height: context.getHeight(8)),
                        TextFormField(
                          controller: _password,
                          decoration: InputDecoration(
                            labelText: 'كلمة المرور',
                            prefixIcon: Icon(Icons.lock),
                            border: OutlineInputBorder(),
                            suffixIcon: IconButton(
                              icon: Icon(
                                isObscure
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  isObscure = !isObscure;
                                });
                              },
                            ),
                          ),
                          obscureText: isObscure,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'يرجى إدخال كلمة المرور';
                            }
                            if (value.length < 8) {
                              return 'كلمة المرور يجب أن تكون 8 أحرف على الأقل';
                            }
                            // Check for at least one number
                            if (!RegExp(r'[0-9]').hasMatch(value)) {
                              return 'كلمة المرور يجب أن تحتوي على رقم واحد على الأقل';
                            }
                            // Check for at least one letter
                            if (!RegExp(r'[a-zA-Z]').hasMatch(value)) {
                              return 'كلمة المرور يجب أن تحتوي على حرف واحد على الأقل';
                            }
                            return null;
                          },
                          onSaved: (value) => password = value ?? '',
                        ),
                        SizedBox(height: context.getHeight(12)),
                        TextFormField(
                          controller: _passwordConfirm,
                          decoration: InputDecoration(
                            labelText: 'تأكيد كلمة المرور',
                            prefixIcon: Icon(Icons.lock),
                            border: OutlineInputBorder(),
                            suffixIcon: IconButton(
                              icon: Icon(
                                isConfirmObscure
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  isConfirmObscure = !isConfirmObscure;
                                });
                              },
                            ),
                          ),
                          obscureText: isConfirmObscure,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'يرجى تأكيد كلمة المرور';
                            }
                            if (value != _password.text) {
                              return 'كلمات المرور غير متطابقة';
                            }
                            return null;
                          },
                          onSaved: (value) => confirmPassword = value ?? '',
                        ),
                        SizedBox(height: context.getHeight(12)),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              backgroundColor: AppColors.accent,
                            ),
                            onPressed: auth.isLoading
                                ? null
                                : () async {
                                    if (_formKey.currentState!.validate()) {
                                      _formKey.currentState!.save();

                                      // Clean and format phone number for use as userId
                                      String cleanPhone = _cleanPhoneNumber(
                                        _phoneNumber.text,
                                      );

                                      final success = await auth.register(
                                        _email.text,
                                        _password.text,
                                        cleanPhone, // Use cleaned phone number as userId
                                      );
                                      if (success) {
                                       await shared.setBool('isLogin', true);
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'تم إنشاء الحساب بنجاح!',
                                            ),
                                            backgroundColor: Colors.green,
                                          ),
                                        );
                                        // Navigate to DashboardScreen
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                OnboardingScreen(),
                                          ),
                                        );
                                      } else {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              auth.error ?? 'فشل إنشاء الحساب',
                                            ),
                                            backgroundColor: Colors.red,
                                            duration: Duration(seconds: 4),
                                          ),
                                        );
                                      }
                                    }
                                  },
                            child: auth.isLoading
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: context.getWidth(14),
                                        height: context.getHeight(14),
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      ),
                                      SizedBox(width: context.getWidth(8)),
                                      Text(
                                        'جاري إنشاء الحساب...',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  )
                                : Text(
                                    'إنشاء حساب',
                                    style: TextStyle(
                                      fontSize: context.getFontSize(18),
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                        SizedBox(height: context.getHeight(10)),
                        Divider(),
                        Text(
                          'أو سجل باستخدام',
                          style: TextStyle(
                            fontSize: context.getFontSize(15),
                            color: AppColors.textMain,
                          ),
                        ),
                        SizedBox(height: 12),
                        SocialButton(
                          text: 'جوجل',
                          color: AppColors.curveTop1,
                          textColor: AppColors.textMain,
                          icon: Icon(
                            Icons.g_mobiledata,
                            size: 30,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            // TODO: Google sign-in logic
                            signIn.authenticate().then((v) {
                              if (v.email !=null) {
                                shared.setBool('isLogin', true);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'تم تسجيل الدخول بنجاح',
                                    ),
                                    backgroundColor: Colors.green,
                                    duration: Duration(seconds: 4),
                                  ),
                                );
                                // Navigate to DashboardScreen
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => OnboardingScreen()
                                  ));
                              }
                            });
                          },
                        ),
                        SizedBox(height: 24),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginScreen(),
                              ),
                            );
                          },
                          child: Text('لديك حساب بالفعل؟ تسجيل الدخول'),
                        ),
                      ],
                    ),
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
