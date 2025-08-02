import 'package:flutter/material.dart';
import 'package:wishcrafted/Helper/LogApp/LogApp.dart';
import 'package:wishcrafted/Helper/TranslationApp/LanguageController.dart';
import 'package:wishcrafted/Helper/TranslationApp/LanguageTranslation.dart';
import 'package:wishcrafted/View/SpecialNeedsScreen.dart';
import 'package:wishcrafted/View/style/AppColors/AppColors.dart';
import 'package:wishcrafted/View/style/SizeApp/ScreenSize.dart';

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
      icon: Icons.star,
    ),
    _OnboardPageData(
      title: 'سهولة الاستخدام',
      description: 'واجهة بسيطة وألوان هادئة تناسب جميع المستخدمين.',
      icon: Icons.touch_app,
    ),
    _OnboardPageData(
      title: 'دعم الاحتياجات الخاصة',
      description: 'ميزات مخصصة للمكفوفين وذوي الاحتياجات الخاصة.',
      icon: Icons.accessibility_new,
    ),
  ];

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
              height: context.getHeight(200),
              decoration: const BoxDecoration(
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
                height: context.getHeight(100),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.curveBottom1, AppColors.curveBottom2],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
          ),
          // محتوى الصفحات
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: _controller,
                    itemCount: pages.length,
                    onPageChanged: (index) {
                      logInfo("message onPageChanged: $index");
                      // setState(() {
                         logInfo("message setState currentPage: $_currentPage");
                        _currentPage = index;
                      // });
                    },
                    itemBuilder: (context, index) {
                      final page = pages[index];
                      return Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: context.getWidth(24),
                          vertical: context.getHeight(20),
                        ),
                        child: Card(
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          color: AppColors.card,
                          shadowColor: AppColors.shadow,
                          child: Padding(
                            padding: const EdgeInsets.all(28.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 38,
                                  backgroundColor: AppColors.accent,
                                  child: Icon(
                                    page.icon,
                                    size: 44,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: context.getHeight(16)),
                                Text(
                                  page.title,
                                  style: TextStyle(
                                    fontSize: context.getFontSize(25),
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textMain,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: context.getHeight(16)),
                                Text(
                                  page.description,
                                  style: TextStyle(
                                    fontSize: context.getFontSize(20),
                                    color: AppColors.textMain,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // مؤشرات الصفحات
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
                            ? AppColors.accent
                            : AppColors.curveTop1,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                // زر التالي أو البدء
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.getWidth(10),
                    vertical: context.getHeight(12),
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.shadow,
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
                        // انتقل إلى الشاشة الرئيسية أو تسجيل الدخول
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AccessibleApp(),
                          ),
                          (Route<dynamic> route) =>
                              true, // هذا الشرط يزيل كل الشاشات السابقة
                        );
                        return;
                      }
                    },
                    child: Text(
                      _currentPage < pages.length - 1
                          ? Lang[Words.next].toString()
                          : Lang[Words.start],
                      style: TextStyle(
                        fontSize: context.getFontSize(16),
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
  }
}

class _OnboardPageData {
  final String title;
  final String description;
  final IconData icon;
  const _OnboardPageData({
    required this.title,
    required this.description,
    required this.icon,
  });
}

// منحنى علوي
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

// منحنى سفلي
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
