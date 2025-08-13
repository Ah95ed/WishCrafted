import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wishcrafted/Controller/AccessibilityProvider/AccessibilityProvider.dart';
import 'package:wishcrafted/Helper/LogApp/LogApp.dart';
import 'package:wishcrafted/View/DashboardScreen.dart';
import 'package:wishcrafted/View/Widgets/AccessibleText/AccessibleText.dart';
import 'package:wishcrafted/View/Widgets/CurveClipper/CurveClipper.dart';
import 'package:wishcrafted/View/style/AppColors/AppColors.dart';
import 'package:wishcrafted/View/style/SizeApp/ScreenSize.dart';
import 'package:wishcrafted/Helper/TranslationApp/LanguageTranslation.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AccessibilityProvider>(
      builder: (context, access, child) {
        return Scaffold(
          backgroundColor: access.isDarkMode ? Colors.black : Colors.white,
          body: Stack(
            children: [
              ClipPath(
                clipper: TopCurveClipper(),
                child: Container(
                  height: context.getHeight(200),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.curveTop1, AppColors.curveTop2],
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
                        colors: [
                          AppColors.curveBottom1,
                          AppColors.curveBottom2,
                        ],
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
                        itemCount: access.pages.length,
                        onPageChanged: (index) =>
                            setState(() => _currentPage = index),
                        itemBuilder: (context, index) {
                          var page = access.pages[index];
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
                                color: AppColors.background,
                                shadowColor: AppColors.shadow,
                                child: Padding(
                                  padding: EdgeInsets.all(
                                    context.getMinSize(14),
                                  ),
                                  child: page.isAccessibilityPage
                                      ? Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              height: context.getHeight(20),
                                            ),
                                            AccessibleText(
                                              Lang[Words.fontSize],
                                              style: TextStyle(
                                                fontSize: access.fontSize + 5,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.textMain,
                                              ),
                                            ),
                                            Slider(
                                              value: access.fontSize,
                                              min: 14,
                                              max: 36,
                                              divisions: 11,
                                              label: access.fontSize
                                                  .toInt()
                                                  .toString(),
                                              activeColor:
                                                  AppColors.sliderActive,
                                              onChanged: (value) {
                                                access.fontSize = value;
                                                // ignore: invalid_use_of_protected_member
                                                access.notifyListeners();
                                              },
                                            ),
                                            SizedBox(
                                              height: context.getHeight(10),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                // اختيار لغة
                                                Text(
                                                                                                 Lang[Words.language],
                                                  style: TextStyle(
                                                    fontSize: access.fontSize,
                                                    fontWeight:
                                                        FontWeight.bold,
                                                    color: AppColors.textMain,
                                                  ),
                                                ),
                                                 SizedBox(width: context.getWidth(8)),
                                                DropdownButtonHideUnderline(
                                                  child: DropdownButton<String>(
                                                    value:
                                                        access.selectedLanguage,
                                                    icon: Icon(
                                                      Icons.keyboard_arrow_down,
                                                      color: AppColors.accent,
                                                    ),
                                                    dropdownColor:
                                                        access.isDarkMode
                                                        ? Colors.grey[800]
                                                        : Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          15,
                                                        ),
                                                    items: [
                                                      DropdownMenuItem(
                                                        value: access
                                                            .supportLanguage[0]
                                                            .languageCode,
                                                        child: Row(
                                                          children: [
                                                            SizedBox(width: context.getWidth(8)),
                                                            AccessibleText(
                                                              'العربية',
                                                              style: TextStyle(
                                                                fontSize: access
                                                                    .fontSize,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      DropdownMenuItem(
                                                        value: access
                                                            .supportLanguage[1]
                                                            .languageCode,
                                                        child: Row(
                                                          children: [
                                                            SizedBox(width: 8),
                                                            AccessibleText(
                                                              'English',
                                                              style: TextStyle(
                                                                fontSize: access
                                                                    .fontSize,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                    onChanged: (value) async {
                                                      if (value == null) return;
                                                      access.selectedLanguage =
                                                          value;
                                                      await access
                                                          .changeLanguage(
                                                            value,
                                                          );
                                  
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: context.getHeight(10),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Switch(
                                                  value: access.isDarkMode,
                                                  onChanged: (value) {
                                                    access.toggleDarkMode(
                                                      value,
                                                    );
                                                    // access.toggleContrast();
                                                  },
                                                  activeColor: AppColors.accent,
                                                ),
                                                SizedBox(
                                                  width: context.getWidth(8),
                                                ),
                                                AccessibleText(
                                                  Lang[Words.mode],
                                                  style: TextStyle(
                                                    fontSize: access.fontSize,
                                                    color: AppColors.textMain,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: context.getHeight(6),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Checkbox(
                                                  value: access.ttsEnabled,
                                                  activeColor:
                                                      AppColors.textMain,
                                                  onChanged: (_) =>
                                                      access.toggleTTS(),
                                                ),
                                                AccessibleText(
                                                  Lang[Words.readscreen],
                                                  style: TextStyle(
                                                    fontSize: access.fontSize,
                                                    color: AppColors.textMain,
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
                                            SizedBox(
                                              height: context.getHeight(10),
                                            ),
                                            AccessibleText(
                                              page.title,
                                              style: TextStyle(
                                                fontSize: access.fontSize,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.textMain,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            AccessibleText(
                                              page.description,
                                              style: TextStyle(
                                                fontSize: access.fontSize,
                                                color: AppColors.textMain,
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
                        access.pages.length,
                        (index) => Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: context.getWidth(4),
                            vertical: context.getHeight(8),
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
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.getWidth(8),
                        vertical: context.getHeight(8),
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.background,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            vertical: context.getHeight(8),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          access.stopTTS();
                          if (_currentPage < access.pages.length - 1) {
                            _controller.nextPage(
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeInOut,
                            );
                          } else {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => DashboardScreen(),
                              ),
                            );
                          }
                        },
                        child: Text(
                          _currentPage < access.pages.length - 1
                              ? Lang[Words.next].toString()
                              : Lang[Words.start],
                          style: TextStyle(
                            fontSize: access.fontSize,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textMain,
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
    );
  }
}
