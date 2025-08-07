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
      goalDescription:
          "\n👋 أهلًا وسهلًا بك في منصتك\n – حيث احتياجاتك وأهدافك ليست مجرد بيانات، بل أولوية نعتني بها كأنها قصتنا الشخصية."
          "نحن هنا لنفهمك أولًا، ونرافقك في اختيار الأنسب لك بكل تعاطف وشفافية 🤝"
          "ثق تمامًا أن وقتك وقيمك وراحتك أهم من أي شيء آخر بالنسبة لنا 💙\n",
      goalDescription2:"🚀 رحلتنا تبدأ بفهمك، لا بمبيعاتنا.\n"

"🌟 أنت هنا لأن لديك هدفًا أو رغبة، ونحن هنا لنساعدك في تحقيقها دون تنازلات عن قيمك أو مواردك 💡💛\n"

"✨ نؤمن أن كل تجربة استخدام يجب أن تُضيف إلى حياتك معنى وفائدة حقيقية، لا أن تستهلك وقتك وطاقتك سُدى.\n"

"🤝 نلتزم بأن تكون منصتنا مساحة ثقة، وفريقنا يعمل دائمًا لتقديم الأفضل — بشفافية 🪞، تعاطف ❤️، وعدالة ⚖️\n"

"هل تحب أن أجهّ",
      // goalDescription:
      //     "✅ تحديد احتياجك بدقة\n"
      //     "💰 توفير المال بدون تضحية بالجودة\n"
      //     "🧠 اقتراحات ذكية ومخصصة\n"
      //     "🔍 الشفافية والمقارنة العادلة\n"
      //     "🛍️ سهولة الوصول لأفضل العروض",
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
      // goalDescription:
      // "✅ Define your needs precisely\n"
      // "💰 Save money without compromising quality\n"
      // "🧠 Smart and personalized suggestions\n"
      // "🔍 Transparency and fair comparison\n"
      // "🛍️ Easy access to the best deals",
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
