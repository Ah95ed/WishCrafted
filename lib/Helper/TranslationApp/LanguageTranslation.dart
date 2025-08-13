class Words {
  static const start = "start";
  static const appName = 'appName';
  static const next = "next";
  static const welcome = "welcome";
  static const readscreen = "readsScreen";
  static const goalDescription = "goalDescription";
  static const goal = "goal";
  static const language = "language";
  static const back = "back";
  static const fontSize = "fontSize";
  static const mode = "mode";
  static const goalDescription2 = "goalDescription2";

  @override
  static Map<String, Map<String, String>> get keys => {
    'ar': {
      mode: "الوضع النهاري / الليلي",

      goal: "الهدف",
      language: "اختيار اللغة",
      goalDescription:
          " 👋 أهلًا بك في منصتك—احتياجاتك وأهدافك أولويتنا.\n"
          "🤝 نفهمك أولًا، ثم نرشدك بتعاطف وشفافية.\n"
          "💙 وقتك وقيمك وراحتك أهم من أي شيء آخر.\n",
      goalDescription2:
          "🚀 رحلتنا تبدأ بفهمك قبل أي عملية.\n"
          "🌟 أنت هنا لهدف، ونحن هنا لمساعدتك دون المساس بقيمك أو مواردك.\n"
          "✨ كل تفاعل معنا يجب أن يضيف قيمة حقيقية لحياتك، لا أن يضيع وقتك.\n"
          "🤝 منصتنا مبنية على الثقة، ونقدم الأفضل دائمًا بشفافية وتعاطف.\n",
      readscreen: "قراءة الشاشة",
      start: "ابدأ",
      appName: "WishCrafted",
      next: 'التالي',
      welcome: "مرحبا بك" + " في \nWishCrafted",
      back: "العودة",
      fontSize: "حجم الخط",
    },
    'en': {
      mode: "Light/Dark Mode",
      goal: "Goal",
      language: "Select Language",
      goalDescription:
          "👋 Welcome to your platform—where your needs and goals are our top priority."
          "🤝 We understand you first, then guide you with empathy and transparency."
          "💙 Your time, values, and comfort come before anything else.",
      goalDescription2:
          "🚀 Our journey starts by understanding you before selling anything."
          " 🌟 You have a goal, and we’re here to help—without compromising your values or resources."
          "✨ Every interaction should add real value to your life, not waste your time."
          "🤝 Our platform is built on trust—offering the best with transparency and empathy.",
      readscreen: "Screen Reader",
      appName: "WishCrafted",
      start: "Start",
      next: "Next",
      welcome: "Welcome" + " to \nWishCrafted",
      back: "Back",
      fontSize: "Font Size",
    },
  };
}
