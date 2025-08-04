import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:wishcrafted/Helper/Service/initService.dart';
import 'package:wishcrafted/Helper/TranslationApp/LanguageTranslation.dart';

class OnboardPageData {
  final String title;
  final String description;
  final IconData icon;
  final bool isAccessibilityPage;
  const OnboardPageData({
    required this.title,
    required this.description,
    required this.icon,
    this.isAccessibilityPage = false,
  });
}

class AccessibilityProvider extends ChangeNotifier {
  double fontSize = 20;
  bool highContrast = false;
  bool ttsEnabled = true;
  String selectedLanguage = shared.getString("lang") ?? 'en'; // أو 'en'
  final FlutterTts flutterTts = FlutterTts();
  late List<OnboardPageData> pages;
  void initdata() {
    pages = [
      OnboardPageData(
        title: Lang[Words.welcome],
        description: 'تطبيق يسهّل الوصول للجميع ويقدم تجربة مريحة وذكية.',
        icon: Icons.accessibility_new,
        isAccessibilityPage: true,
      ),
      OnboardPageData(
        title: Lang[Words.goal],
        description: Lang[Words.goalDescription],
        icon: Icons.touch_app,
      ),
      OnboardPageData(
        title: 'تجربة شاملة',
        description: 'ميزات ذكية لكل احتياجاتك الرقمية.',
        icon: Icons.star,
      ),
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
  final supportLanguage = [
    const Locale.fromSubtags(languageCode: 'ar'),
    const Locale.fromSubtags(languageCode: 'en'),
  ];

  Locale currentLocale = shared.getString("lang") == null
      ? const Locale('ar')
      : Locale(shared.getString("lang")!);

  Future<void> changeLanguage(String? lang) async {
    currentLocale = Locale(lang ?? "ar");
    await shared.setString("lang", lang!);
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
