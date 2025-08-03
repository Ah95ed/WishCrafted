import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:wishcrafted/Controller/AccessibilityProvider/AccessibilityProvider.dart';
import 'package:wishcrafted/Helper/LogApp/LogApp.dart';
import 'package:wishcrafted/Helper/Service/initService.dart';
import 'package:wishcrafted/Helper/TranslationApp/LanguageController.dart';
import 'package:wishcrafted/Helper/TranslationApp/LanguageTranslation.dart';
import 'package:wishcrafted/View/onBorder/onBorderScreen.dart';
import 'package:wishcrafted/View/style/SizeApp/ScreenSize.dart';
import 'package:wishcrafted/View/style/SizeApp/SizeBuilder.dart';

void main() async {
  await runZonedGuarded<Future<void>>(
    () async {
      // Initialize services
      await WidgetsFlutterBinding.ensureInitialized();
      await InitService.instance.initService();
      runApp(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (_) => LanguageController(),
              lazy: true,
            ),
            ChangeNotifierProvider(
              create: (_) => AccessibilityProvider(),
              lazy: true,
            ),
          ],
          child: WishCraftedApp(),
          // child: DevicePreview(
          //   enabled: !kReleaseMode,
          //   builder: (context) => WishCraftedApp(), // Wrap your app
          // ),
        ),
      );
    },
    (error, stackTrace) {
      // Handle errors
      logError('An error occurred in the main zone - ${error.toString()}');
    },
  );
}

class WishCraftedApp extends StatelessWidget {
  const WishCraftedApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<LanguageController, AccessibilityProvider>(
      builder: (c, value, access, child) {
        return SizeBuilder(
          baseSize: Size(360, 690),
          height: context.screenHeight,
          width: context.screenWidth,
          child: MaterialApp(
            supportedLocales: value.supportLanguage,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            theme: ThemeData(
              useMaterial3: true,
              brightness: access.isDarkMode ? Brightness.dark : Brightness.light,
              // colorSchemeSeed: AppColors.accent,
              fontFamily: 'Cairo',
            ),
            title: Lang[Words.appName],
            locale: value.currentLocale,
            home: OnboardingScreen(),
            debugShowCheckedModeBanner: false,
          ),
        );
      },
    );
  }
}
