import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:wishcrafted/Helper/LogApp/LogApp.dart';
import 'package:wishcrafted/Helper/Service/initService.dart';
import 'package:wishcrafted/Helper/TranslationApp/LanguageController.dart';
import 'package:wishcrafted/View/SplashScreen/SplashScreen.dart';
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
          ],
          child: const WishCraftedApp(),
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
    return Consumer<LanguageController>(
      builder: (context, value, child) {
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
            title: 'WishCrafted Login',
            locale: value.currentLocale,
            home: SplashScreen(),
            debugShowCheckedModeBanner: false,
          ),
        );
      },
    );
  }
}
