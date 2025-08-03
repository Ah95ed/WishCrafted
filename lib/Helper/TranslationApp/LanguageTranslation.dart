class Words {
  static const start = "start";
  static const appName = 'appName';
  static const next = "next";
  static const welcome = "welcome";
  static const readscreen = "readsScreen";
  static const goalDescription = "goalDescription";
  static const goal = "goal";

  @override
  static Map<String, Map<String, String>> get keys => {
    'ar': {
      goal: "الهدف",
      goalDescription:
          "✅ تحديد احتياجك بدقة\n"
          "💰 توفير المال بدون تضحية بالجودة\n"
          "🧠 اقتراحات ذكية ومخصصة\n"
          "🔍 الشفافية والمقارنة العادلة\n"
          "🛍️ سهولة الوصول لأفضل العروض",
      readscreen: "قراءة الشاشة",
      start: "ابدأ",
      appName: "WishCrafted",
      next: 'التالي',
      welcome: "مرحبا بك" + " في \nWishCrafted",
    },
    'en': {
      goal: "Goal",
      goalDescription:
          "✅ Define your needs precisely\n"
          "💰 Save money without compromising quality\n"
          "🧠 Smart and personalized suggestions\n"
          "🔍 Transparency and fair comparison\n"
          "🛍️ Easy access to the best deals",
      readscreen: "Screen Reader",
      appName: "WishCrafted",
      start: "Start",
      next: "Next",
      welcome: "Welcome" + " to \nWishCrafted",
    },
  };
}
