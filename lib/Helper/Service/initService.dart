import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wishcrafted/Controller/AccessibilityProvider/AccessibilityProvider.dart';

late SharedPreferences shared;

class InitService {
  // Singleton instance
  static final InitService instance = InitService._();
  InitService._();

  Future<void> initService() async {
    WidgetsFlutterBinding.ensureInitialized();
    shared = await SharedPreferences.getInstance();
     await initLang(shared.getString('lang') ?? 'en');
  }
}
