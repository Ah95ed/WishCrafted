import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:wishcrafted/Helper/LogApp/LogApp.dart';
import 'package:wishcrafted/Helper/Service/initService.dart';
import 'package:wishcrafted/Helper/TranslationApp/LanguageTranslation.dart';

class OnboardPageData {
  final String title;
  final String description;

  final bool isAccessibilityPage;
  const OnboardPageData({
    required this.title,
    required this.description,

    this.isAccessibilityPage = false,
  });
}

class AccessibilityProvider extends ChangeNotifier {
  double fontSize = 16;
  bool highContrast = false;
  bool ttsEnabled = true;
  late String selectedLanguage = shared.getString("lang") ?? "en"; // أو 'en'
  final FlutterTts flutterTts = FlutterTts();
  late List<OnboardPageData> pages;

  Future<void> initdata() async {
    pages = [
      OnboardPageData(
        title: '',
        description: 'تطبيق يسهّل الوصول للجميع ويقدم تجربة مريحة وذكية.',
        // icon: Icons.accessibility_new,
        isAccessibilityPage: true,
      ),
      OnboardPageData(title: '', description: Lang[Words.goalDescription]),
      OnboardPageData(title: '', description: Lang[Words.goalDescription2]),
    ];
  }

  AccessibilityProvider() {
    initdata();
    _loadPrefs();
    flutterTts.setLanguage(shared.getString("lang") ?? 'en');
    flutterTts.setSpeechRate(0.4);
    flutterTts.setPitch(1.0);
  }

  void _loadPrefs() {
    fontSize = shared.getDouble('access_fontSize') ?? 20;
    highContrast = shared.getBool('access_highContrast') ?? false;
    ttsEnabled = shared.getBool('access_ttsEnabled') ?? true;
    notifyListeners();
  }

  void _savePrefs() {
    shared.setDouble('access_fontSize', fontSize);
    shared.setBool('access_highContrast', highContrast);
    shared.setBool('access_ttsEnabled', ttsEnabled);
  }

  void increaseFontSize() {
    if (fontSize < 36) {
      fontSize += 2;
      _savePrefs();
      notifyListeners();
    }
  }

  void decreaseFontSize() {
    if (fontSize > 14) {
      fontSize -= 2;
      _savePrefs();
      notifyListeners();
    }
  }

  void toggleContrast() {
    highContrast = !highContrast;
    _savePrefs();
    notifyListeners();
  }

  void toggleTTS() {
    ttsEnabled = !ttsEnabled;
    _savePrefs();
    notifyListeners();
  }

  Future<void> speak(String text) async {
    if (ttsEnabled) {
      await flutterTts.stop();
      await flutterTts.speak(text);
    }
  }

  Future<void> stopTTS() async {
    if (ttsEnabled) {
      await flutterTts.stop();
    }
  }

  bool isDarkMode = shared.getBool('access_isDarkMode') ?? false;
  var supportLanguage = [
    Locale.fromSubtags(languageCode: 'ar'),
    Locale.fromSubtags(languageCode: 'en'),
  ];

  Locale currentLocale = shared.getString("lang") == null
      ? Locale('en')
      : Locale(shared.getString("lang")!);

  Future<void> changeLanguage(String? lang) async {
    currentLocale = Locale(lang!);
    await shared.setString("lang", lang);
    await initLang(lang);
    notifyListeners();
  }

  Future<void> toggleDarkMode(bool value) async {
    isDarkMode = value;
    await shared.setBool('access_isDarkMode', isDarkMode);
    notifyListeners();
  }
}

Map Lang = {};
late String language;

initLang(String lang) async {
  if (lang == 'ar') {
    Lang = Words.keys['ar']!;
  } else {
    Lang = Words.keys['en']!;
  }
}
