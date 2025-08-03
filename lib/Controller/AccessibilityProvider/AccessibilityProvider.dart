import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:wishcrafted/Helper/Service/initService.dart';

class AccessibilityProvider extends ChangeNotifier {
  double fontSize = 20;
  bool highContrast = false;
  bool ttsEnabled = true;
  String selectedLanguage = shared.getString("lang") ?? 'en'; // أو 'en'
bool isDarkMode = false;
  final FlutterTts flutterTts = FlutterTts();

  AccessibilityProvider() {
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
}