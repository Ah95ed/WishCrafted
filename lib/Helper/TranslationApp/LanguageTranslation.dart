class Words {
  static const start = "start";
  static const appName = 'appName';
  static const next = "next";
  static const String welcome = "welcome";

  @override
  static Map<String, Map<String, String>> get keys => {
    'ar': {
      start: "ابدأ",
      appName: "WishCrafted",
      next: 'التالي',
      welcome: "مرحبا بك" + " في \nWishCrafted",
    },
    'en': {
      appName: "WishCrafted",
      start: "Start",
      next: "Next",
      welcome: "Welcome" + " to \nWishCrafted",
    },
  };
}
