import 'package:flutter/material.dart';
import 'package:wishcrafted/Helper/LogApp/LogApp.dart';
import 'package:wishcrafted/Models/dasshboardModel/dasshboardModel.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:wishcrafted/Models/chat_message.dart';

class DashboardController extends ChangeNotifier {
  List<DashboardModel> intents = [
    DashboardModel(
      title: "ترفيه وتجارب غامرة",
      description:
          "الهروب من الواقع، مكافحة الوحدة، بناء هويات رقمية، الشعور بالحضور والانتماء",
    ),
    DashboardModel(
      title: "تعليم وتطوير مستمر",
      description:
          "الإنجاز السريع، مواكبة السوق، تجاوز التعليم التقليدي، البحث عن الإرشاد",
    ),
    DashboardModel(
      title: "صحة وعافية شاملة",
      description:
          "السيطرة على الصحة، تحقيق التوازن الشامل، السيادة على البيانات الصحية، الدعم الآمن",
    ),
    DashboardModel(
      title: "تجارة واقتصاد قيمي",
      description:
          "التعبير عن الهوية، أثر الشراء، الأصالة والشفافية، الانتماء لمجتمع قيمي",
    ),
    DashboardModel(
      title: "إنتاجية وإبداع معزز",
      description:
          "كسر الحصار الإبداعي، تحويل الأفكار لواقع، الاستقلال المالي، المساهمة في بناء الويب",
    ),
    DashboardModel(
      title: "خدمات يومية متقدمة",
      description:
          "الأمان، الوقت مقابل المال، التغلب على البيروقراطية، بناء سجل مالي وسمعة ذكية",
    ),
    DashboardModel(
      title: "تواصل اجتماعي هادف",
      description:
          "تأكيد الهوية، كسر الوحدة، نشر القيم، الانخراط بحركات اجتماعية فعالة",
    ),
    DashboardModel(
      title: "تجارب مستقبلية/تخطيط",
      description:
          "تقليل القلق من المستقبل، التحكم في المصير، البحث عن نسخة أفضل من الذات",
    ),
    DashboardModel(
      title: "اكتشاف ذاتي/استكشاف",
      description:
          "الحاجة للإلهام، اختبار حدود الشخصية، استكشاف قيم أو أنماط حياة جديدة",
    ),
    DashboardModel(
      title: "مبادرات/مشاريع جماعية",
      description:
          "الرغبة في التأثير، التنظيم الذاتي، القيادة، تطوير الحراك المجتمعي",
    ),
  ];

  DashboardModel? selectedIntent;

  // ChatGPT logic
  List<ChatMessage> messages = [];
  bool isLoading = false;

  // تحديث النية المختارة
  void setSelectedIntent(DashboardModel? intent) {
    selectedIntent = intent;
    logInfo("تم تحديث النية المختارة:  ${intent?.description}");
    notifyListeners();
  }

  Future<void> sendMessage(String message) async {
    messages.add(ChatMessage(text: message, isUser: true));
    isLoading = true;
    notifyListeners();
    final url = Uri.parse(
      "https://api-inference.huggingface.co/models/gpt2",
    );
    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({"inputs": message}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      messages.add(ChatMessage(text: data[0]['generated_text'], isUser: false));
      isLoading = false;
    } else {
      messages.add(
        ChatMessage(
          text: "حدث خطأ في الاتصال بالذكاء الاصطناعي.",
          isUser: false,
        ),
      );
      isLoading = false;
      logError("Error ${response.statusCode}: ${response.body}");
    }
    isLoading = false;
    notifyListeners();
  }
  // Future<void> sendMessage(String prompt) async {
  //   messages.add(ChatMessage(text: prompt, isUser: true));
  //   isLoading = true;
  //   notifyListeners();
//  final url = Uri.parse('https://api.openai.com/v1/chat/completions');
  //   final headers = {
  //     'Content-Type': 'application/json',
  //     'Authorization': 'Bearer $apiKey',
  //   };
  //   final body = jsonEncode({
  //     "model": "gpt-3.5-turbo",
  //     "messages": [
  //       {"role": "user", "content": prompt},
  //     ],
  //   });

  //   try {
  //     final response = await http.post(url, headers: headers, body: body);
  //     if (response.statusCode == 200) {
  //       final data = jsonDecode(response.body);
  //       final reply = data['choices'][0]['message']['content'];
  //       messages.add(ChatMessage(text: reply, isUser: false));
  //     } else {
  //       logError("  ${response.statusCode}");
  //       messages.add(
  //         ChatMessage(
  //           text: "حدث خطأ في الاتصال بالذكاء الاصطناعي.",
  //           isUser: true,
  //         ),
  //       );
  //     }
  //   } catch (e) {
  //     logError("____ ${e} ____");
  //     messages.add(ChatMessage(text: "تعذر الاتصال بالخادم.", isUser: false));
  //   }

  //   isLoading = false;
  //   notifyListeners();
  // }
}
