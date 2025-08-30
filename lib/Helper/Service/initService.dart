import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:wishcrafted/Controller/AccessibilityProvider/AccessibilityProvider.dart';
import 'package:wishcrafted/firebase_options.dart';

late SharedPreferences shared;

class InitService {
  // Singleton instance
  static final InitService instance = InitService._();
  InitService._();

  Future<void> initService() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    shared = await SharedPreferences.getInstance();
    await initLang(shared.getString('lang') ?? 'en');
  }
}
