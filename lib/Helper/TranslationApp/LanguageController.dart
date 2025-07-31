import 'package:flutter/material.dart';
import 'package:wishcrafted/Helper/Service/initService.dart';
import 'package:wishcrafted/Helper/TranslationApp/LanguageTranslation.dart';
class LanguageController extends ChangeNotifier{
final supportLanguage = [
    const Locale.fromSubtags(languageCode: 'ar'),
    const Locale.fromSubtags(languageCode: 'en'),
  ];

  Locale currentLocale =   shared.getString("lang") == null
      ? const Locale('ar')
      : Locale(
          shared.getString("lang")!,
        );
 void changeLanguage(String? lang) async {
    currentLocale = Locale(lang ?? "ar");
    await shared.setString("lang", lang!);
    await initLang(lang);
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