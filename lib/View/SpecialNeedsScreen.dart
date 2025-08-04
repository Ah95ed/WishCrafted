import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';
import 'package:wishcrafted/Controller/AccessibilityProvider/AccessibilityProvider.dart';
import 'package:wishcrafted/Helper/Service/initService.dart';
import 'package:wishcrafted/View/Widgets/AccessibleText/AccessibleText.dart';
import 'package:wishcrafted/View/Widgets/CurveClipper/CurveClipper.dart';
import 'package:wishcrafted/View/style/AppColors/AppColors.dart';
import 'package:wishcrafted/View/style/SizeApp/ScreenSize.dart';

class AccessibleApp extends StatefulWidget {
  const AccessibleApp({super.key});

  @override
  State<AccessibleApp> createState() => _AccessibleAppState();
}

class _AccessibleAppState extends State<AccessibleApp> {
  double _fontSize = shared.getDouble("access_fontSize") ?? 20;
  final FlutterTts _flutterTts = FlutterTts();

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
              height: 220,
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
                height: 120,
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

          // محتوى الشاشة
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: context.getHeight(20)),
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.shadow.withOpacity(0.15),
                            blurRadius: 16,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 38,
                        backgroundColor: AppColors.accent,
                        child: Icon(
                          Icons.accessibility_new,
                          size: 44,
                          color: AppColors.card,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: context.getHeight(10)),
                  Center(
                    child: AccessibleText(
                      'تسهيل الوصول',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: _fontSize + 4,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textMain,
                      ),
                    ),
                  ),
                  SizedBox(height: context.getHeight(10)),
                  AccessibleText(
                    'هنا يمكنك الحصول على خدمات ودعم مخصص لذوي الاحتياجات الخاصة.',
                    style: TextStyle(
                      fontSize: _fontSize,
                      color: AppColors.textMain,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: context.getHeight(10)),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.shadow.withOpacity(0.08),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        AccessibleText(
                          'الحجم الحالي: ${_fontSize.toInt()}',
                          style: TextStyle(
                            fontSize: _fontSize,
                            color: AppColors.textMain,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: context.getHeight(10)),
                        Slider(
                          value: _fontSize,
                          min: 12,
                          max: 40,
                          divisions: 14,
                          activeColor: AppColors.sliderActive,
                          label: _fontSize.toInt().toString(),
                          onChanged: (value) {
                            setState(() {
                              _fontSize = value;
                            });
                          },
                        ),
                        SizedBox(height: context.getHeight(10)),
                        _buildAccessibleTextBox(
                          "مرحباً بك في تطبيق تسهيل الوصول",
                        ),
                        SizedBox(height: context.getHeight(10)),
                        _buildAccessibleTextBox(
                          "اضغط مطولاً للاستماع إلى هذا النص",
                        ),
                        SizedBox(height: context.getHeight(10)),
                        _buildAccessibleTextBox("تم تكبير الخط بنجاح!"),
                      ],
                    ),
                  ),
                  SizedBox(height: context.getHeight(10)),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 24,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: Icon(Icons.arrow_back, color: AppColors.textMain),
                    label: AccessibleText(
                      'العودة',
                      style: TextStyle(
                        fontSize: _fontSize,
                        color: AppColors.textMain,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccessibleTextBox(String text) {
    final d = Provider.of<AccessibilityProvider>(context);
    return GestureDetector(
      onLongPress: () {
        d.speak(text);
      },
      child: AnimatedDefaultTextStyle(
        duration: const Duration(milliseconds: 300),
        style: TextStyle(
          fontSize: _fontSize,
          color: AppColors.textMain,
          fontWeight: FontWeight.w500,
        ),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.curveBottom1,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow.withOpacity(0.07),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(text),
        ),
      ),
    );
  }
}
