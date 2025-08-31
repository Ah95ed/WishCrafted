import 'package:flutter/material.dart';
import 'package:wishcrafted/Helper/Constants/Const.dart';
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

  String apiKey = "AIzaSyCJ6zpgO4xwm3zLHnbuByjX11shBLwH6eo";
  List points = [];
  int click = 1;
  late String finalText;
  Future<void> askGemini(String intent) async {
    messages.add(ChatMessage(text: intent, isUser: true));
    // if(click == 0) {
    finalText = intent + (prompts1[click]! + prompts2[click]!);
    // }
    // finalText = prompt;
    logSuccess("message == ${prompts1[click]! + prompts2[click]!}");

    isLoading = true;
    notifyListeners();
    final url = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$apiKey',
    );

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},

      body: jsonEncode({
        "contents": [
          {
            "parts": [
              {
                "text": '$finalText',
                // "text":
                //     '$prompt \n اعطي اهم 5 متعلقات بهذه النية بما لا يزيد عن خمسين كلمة تقود المستخدم لاتخاذ القرار المنطقي لحفظ الوقت والمال والجهد وتقليل الالم والندم',
              },
            ],
          },
        ],
      }),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      data['candidates'][0]['content']['parts'][0]['text'] ?? 'No response';

      //  final lines = data.split("\n");
      logSuccess("message = ${data}");

      // نحتفظ بس السطور اللي تبدي بأرقام
      messages.add(
        ChatMessage(
          text: data['candidates'][0]['content']['parts'][0]['text'].toString(),
          isUser: false,
        ),
      );
      click++;
      isLoading = false;
      intent = '';
      data = '';
      notifyListeners();
    } else {
      messages.add(
        ChatMessage(
          text: "خطأ: ${response.statusCode} → ${response.body}",
          isUser: false,
        ),
      );
      isLoading = false;
      notifyListeners();
      logError("message : ${response.statusCode} - ${response.body}");
      throw Exception('فشل الطلب: ${response.statusCode} - ${response.body}');
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> sendLangSmithRun({
    required String name,
    required String runType,
    String? organizationId,
  }) async {
    messages.add(ChatMessage(text: name, isUser: true));
    isLoading = true;
    notifyListeners();
    final apiKey =
        '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'; // تأكد أنه مفتاح LangSmith الصحيح
    final url = Uri.parse('https://api.smith.langchain.com/runs');

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey',
      // أضف السطر التالي إذا كان مطلوباً:
      // 'X-Organization-ID': organizationId,
    };

    final body = jsonEncode({
      'name': name,
      'run_type': runType,
      // إضافة session_id أو بيانات إضافية حسب الحاجة
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('نجحت العملية: ${response.body}');
      messages.add(ChatMessage(text: response.body, isUser: false));
    } else {
      messages.add(
        ChatMessage(
          text: "خطأ: ${response.statusCode} → ${response.body}",
          isUser: false,
        ),
      );
      logError(" Error ______ ${response.statusCode}  : ${response.body}");
    }
    isLoading = false;
    notifyListeners();
  }

  // Future<void> sendMessage(String message) async {
  //   messages.add(ChatMessage(text: message, isUser: true));
  //   isLoading = true;
  //   notifyListeners();

  //   const apiKey =
  //       'sk-1ba2a293eeab42d8baed484e863f97db';
  //   final url = Uri.parse('https://api.deepseek.com/v1/chat/completions');
  //   final headers = {
  //     'Content-Type': 'application/json',
  //     'Authorization': 'Bearer $apiKey',
  //   };
  //   final body = jsonEncode({
  //     "model": "deepseek-chat",
  //     "messages": [
  //       {"role": "user", "content": message},
  //     ],
  //   });

  //   try {
  //     final response = await http.post(url, headers: headers, body: body);
  //     if (response.statusCode == 200) {
  //       final data = jsonDecode(response.body);
  //       final reply = data['choices'][0]['message']['content'];
  //       messages.add(ChatMessage(text: reply, isUser: false));
  //     } else {
  //       messages.add(
  //         ChatMessage(
  //           text: "خطأ: ${response.statusCode} → ${response.body}",
  //           isUser: false,
  //         ),
  //       );
  //       logError("DeepSeek Error ${response.statusCode}: ${response.body}");
  //     }
  //   } catch (e) {
  //     messages.add(
  //       ChatMessage(text: "تعذر الاتصال بخدمة DeepSeek. $e", isUser: false),
  //     );
  //     logError("DeepSeek Exception: $e");
  //   }

  //   isLoading = false;
  //   notifyListeners();
  // }

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
