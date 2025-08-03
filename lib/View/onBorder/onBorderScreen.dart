import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wishcrafted/Controller/AccessibilityProvider/AccessibilityProvider.dart';
import 'package:wishcrafted/View/SpecialNeedsScreen.dart';
import 'package:wishcrafted/View/Widgets/AccessibleText/AccessibleText.dart';
import 'package:wishcrafted/View/style/AppColors/AppColors.dart';
import 'package:wishcrafted/View/style/SizeApp/ScreenSize.dart';
import 'package:wishcrafted/Helper/TranslationApp/LanguageTranslation.dart';
import 'package:wishcrafted/Helper/TranslationApp/LanguageController.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<_OnboardPageData> pages = [
    _OnboardPageData(
      title: Lang[Words.welcome],
      description: 'تطبيق يسهّل الوصول للجميع ويقدم تجربة مريحة وذكية.',
      icon: Icons.accessibility_new,
      isAccessibilityPage: true,
    ),
    _OnboardPageData(
      title: 'سهولة الاستخدام',
      description: 'واجهة بسيطة وألوان هادئة تناسب جميع المستخدمين.',
      icon: Icons.touch_app,
    ),
    _OnboardPageData(
      title: 'تجربة شاملة',
      description: 'ميزات ذكية لكل احتياجاتك الرقمية.',
      icon: Icons.star,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AccessibilityProvider(),
      child: Consumer<AccessibilityProvider>(
        builder: (context, access, child) {
          final isDark = access.isDarkMode;
          final bgColor = AppColors.background(isDark);
          final textColor = AppColors.textMain(isDark);
          final cardColor = AppColors.card(isDark);
          final shadowColor = AppColors.shadow(isDark);
          final accentColor = AppColors.accent(isDark);
          final curveTop1 = AppColors.curveTop1(isDark);
          final curveTop2 = AppColors.curveTop2(isDark);
          final curveBottom1 = AppColors.curveBottom1(isDark);
          final curveBottom2 = AppColors.curveBottom2(isDark);
          final sliderActiveColor = AppColors.sliderActive(isDark);

          return Scaffold(
            backgroundColor: bgColor,
            body: Stack(
              children: [
                ClipPath(
                  clipper: TopCurveClipper(),
                  child: Container(
                    height: context.getHeight(200),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: access.highContrast
                            ? [Colors.black, Colors.grey[800]!]
                            : [curveTop1, curveTop2],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ClipPath(
                    clipper: BottomCurveClipper(),
                    child: Container(
                      height: context.getHeight(100),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: access.highContrast
                              ? [Colors.grey[800]!, Colors.black]
                              : [curveBottom1, curveBottom2],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                    ),
                  ),
                ),
                SafeArea(
                  child: Column(
                    children: [
                      Expanded(
                        child: PageView.builder(
                          controller: _controller,
                          itemCount: pages.length,
                          onPageChanged: (index) =>
                              setState(() => _currentPage = index),
                          itemBuilder: (context, index) {
                            final page = pages[index];
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: context.getWidth(24),
                                vertical: context.getHeight(20),
                              ),
                              child: Semantics(
                                label: '${page.title}. ${page.description}',
                                child: Card(
                                  elevation: 8,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  color: cardColor,
                                  shadowColor: shadowColor,
                                  child: Padding(
                                    padding: const EdgeInsets.all(28.0),
                                    child: page.isAccessibilityPage
                                        ? Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              AccessibleText("تغيير حجم الخط"),
                                              Slider(
                                                value: access.fontSize,
                                                min: 14,
                                                max: 36,
                                                divisions: 11,
                                                label: access.fontSize
                                                    .toInt()
                                                    .toString(),
                                                activeColor: sliderActiveColor,
                                                onChanged: (value) {
                                                  access.fontSize = value;
                                                  access.notifyListeners();
                                                },
                                              ),
                                              const SizedBox(height: 24),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Switch(
                                                    value: access.highContrast,
                                                    onChanged: (value) {
                                                      access.toggleContrast();
                                                    },
                                                    activeColor: accentColor,
                                                  ),
                                                  Checkbox(
                                                    value: access.highContrast,
                                                    activeColor: accentColor,
                                                    onChanged: (_) =>
                                                        access.toggleContrast(),
                                                  ),
                                                  AccessibleText(
                                                    'تفعيل التباين العالي',
                                                    style: TextStyle(
                                                      fontSize: access.fontSize,
                                                      color: textColor,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 24),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Checkbox(
                                                    value: access.ttsEnabled,
                                                    activeColor: accentColor,
                                                    onChanged: (_) =>
                                                        access.toggleTTS(),
                                                  ),
                                                  AccessibleText(
                                                    Lang[Words.readscreen],
                                                    style: TextStyle(
                                                      fontSize: access.fontSize,
                                                      color: textColor,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          )
                                        : Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              CircleAvatar(
                                                radius: 38,
                                                backgroundColor: accentColor,
                                                child: Icon(
                                                  page.icon,
                                                  size: 44,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              SizedBox(
                                                height: context.getHeight(16),
                                              ),
                                              AccessibleText(
                                                page.title,
                                                style: TextStyle(
                                                  fontSize: access.fontSize + 5,
                                                  fontWeight: FontWeight.bold,
                                                  color: textColor,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                              SizedBox(
                                                height: context.getHeight(16),
                                              ),
                                              AccessibleText(
                                                page.description,
                                                style: TextStyle(
                                                  fontSize: access.fontSize,
                                                  color: textColor,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          pages.length,
                          (index) => Container(
                            margin: EdgeInsets.symmetric(
                              horizontal: context.getWidth(4),
                              vertical: context.getHeight(18),
                            ),
                            width: _currentPage == index ? 18 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: _currentPage == index
                                  ? accentColor
                                  : curveTop1,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: context.getWidth(10),
                          vertical: context.getHeight(12),
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: shadowColor,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                              vertical: context.getHeight(8),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            if (_currentPage < pages.length - 1) {
                              _controller.nextPage(
                                duration: const Duration(milliseconds: 400),
                                curve: Curves.easeInOut,
                              );
                            } else {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => AccessibleApp(),
                                ),
                              );
                            }
                          },
                          child: Text(
                            _currentPage < pages.length - 1
                                ? Lang[Words.next].toString()
                                : Lang[Words.start],
                            style: TextStyle(
                              fontSize: access.fontSize,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _OnboardPageData {
  final String title;
  final String description;
  final IconData icon;
  final bool isAccessibilityPage;
  const _OnboardPageData({
    required this.title,
    required this.description,
    required this.icon,
    this.isAccessibilityPage = false,
  });
}

class TopCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 60);
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - 60,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class BottomCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0, 60);
    path.quadraticBezierTo(size.width / 2, 0, size.width, 60);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
