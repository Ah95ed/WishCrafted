import 'package:flutter/material.dart';
import 'package:wishcrafted/Helper/Constants/Const.dart';
import 'package:wishcrafted/Helper/LogApp/LogApp.dart';
import 'package:wishcrafted/Models/dasshboardModel/dasshboardModel.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:wishcrafted/Models/chat_message.dart';
import 'package:wishcrafted/Models/chat_session.dart';
import 'package:wishcrafted/Helper/chat_storage_service.dart';

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

  // إدارة المحادثات
  List<ChatSession> chatSessions = [];
  ChatSession? currentSession;

  // تحميل المحادثات عند بدء التطبيق
  Future<void> loadChatSessions() async {
    chatSessions = await ChatStorageService.loadChatSessions();
    final currentSessionId = await ChatStorageService.getCurrentSessionId();

    if (currentSessionId != null) {
      currentSession = chatSessions.firstWhere(
        (session) => session.id == currentSessionId,
        orElse: () => _createNewSession(),
      );
      messages = List.from(currentSession!.messages);
    } else {
      _createNewSession();
    }

    notifyListeners();
  }

  // إنشاء محادثة جديدة
  ChatSession _createNewSession() {
    final now = DateTime.now();
    final newSession = ChatSession(
      id: 'chat_${now.millisecondsSinceEpoch}',
      title: 'محادثة جديدة',
      createdAt: now,
      lastUpdated: now,
      messages: [],
    );

    currentSession = newSession;
    messages = [];
    return newSession;
  }

  // بدء محادثة جديدة
  void startNewChat() {
    _createNewSession();
    notifyListeners();
  }

  // تحديد محادثة موجودة
  void selectChatSession(ChatSession session) {
    currentSession = session;
    messages = List.from(session.messages);
    ChatStorageService.setCurrentSessionId(session.id);
    notifyListeners();
  }

  // حفظ المحادثة الحالية
  Future<void> _saveCurrentSession() async {
    if (currentSession != null && messages.isNotEmpty) {
      final updatedSession = currentSession!.copyWith(
        title: ChatStorageService.generateChatTitle(messages),
        lastUpdated: DateTime.now(),
        messages: messages,
      );

      await ChatStorageService.saveChatSession(updatedSession);

      // تحديث المحادثة في القائمة
      final existingIndex = chatSessions.indexWhere(
        (s) => s.id == updatedSession.id,
      );
      if (existingIndex != -1) {
        chatSessions[existingIndex] = updatedSession;
      } else {
        chatSessions.add(updatedSession);
      }

      currentSession = updatedSession;
      notifyListeners();
    }
  }

  // حذف محادثة
  Future<void> deleteChatSession(String sessionId) async {
    await ChatStorageService.deleteChatSession(sessionId);
    chatSessions.removeWhere((session) => session.id == sessionId);

    if (currentSession?.id == sessionId) {
      startNewChat();
    }

    notifyListeners();
  }
String _safeLocale(String? l) =>
    (l == 'en' || l == 'ar') ? l! : 'ar';

int _clampClick(int click) =>
    click.clamp(1, 15);

String _buildSystemInstruction({
  required int click,
  required String locale,
}) {
  final idx = _clampClick(click);
  final p1 = prompts1[idx]?[locale]?.trim() ?? '';
  final p2 = prompts2[idx]?[locale]?.trim() ?? '';
  return [p1, p2].where((s) => s.isNotEmpty).join("\n\n");
}

// استخراج آمن لنص الاستجابة من Gemini
String _extractGeminiText(dynamic data) {
  try {
    final cands = data['candidates'];
    if (cands is List && cands.isNotEmpty) {
      final parts = cands[0]?['content']?['parts'];
      if (parts is List && parts.isNotEmpty) {
        final text = parts[0]?['text'];
        if (text is String && text.trim().isNotEmpty) {
          return text;
        }
      }
    }
  } catch (_) {}
  return 'No response';
}

  // مسح جميع المحادثات
  Future<void> clearAllChatSessions() async {
    await ChatStorageService.clearAllSessions();
    chatSessions.clear();
    startNewChat();
    notifyListeners();
  } // تحديث النية المختارة

  void setSelectedIntent(DashboardModel? intent) {
    selectedIntent = intent;
    logInfo("تم تحديث النية المختارة:  ${intent?.description}");
    notifyListeners();
  }

  String apiKey = "AIzaSyCJ6zpgO4xwm3zLHnbuByjX11shBLwH6eo";
  List points = [];
  int click = 1;
  late String finalText;


  Future<void> askGemini(
  String intent, {
  String? locale,        // "ar" أو "en"
  double temperature = 0.6,
  int maxOutputTokens = 512,
}) async {
  final lang = _safeLocale(locale);
  final step = _clampClick(click);

  // 1) أضِف رسالة المستخدم إلى واجهتك
  messages.add(ChatMessage(text: intent, isUser: true));

  // 2) ابنِ System Instruction من البري-برومبت المناسب
  final systemInstruction = _buildSystemInstruction(click: step, locale: lang);

  isLoading = true;
  notifyListeners();

  final url = Uri.parse(
    'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$apiKey'
  );

  // 3) تهيئة الطلب (نرسل البري-برومبت كـ system_instruction وليس ضمن نص المستخدم)
  // final body = {
  //   "system_instruction": {
  //     "parts": [
  //       {"text": systemInstruction}
  //     ]
  //   },
  //   "contents": [
  //     {
  //       "role": "user",
  //       "parts": [
  //         {"text": intent}
  //       ]
  //     }
  //   ],
  //   "generationConfig": {
  //     "temperature": temperature,
  //     "topK": 32,
  //     "topP": 0.9,
  //     "maxOutputTokens": maxOutputTokens,
  //     "stopSequences": [] // لا نوقف مبكرًا
  //   },
  //   // إعدادات أمان خفيفة (اختياري)
  //   "safetySettings": [
  //     {"category": "HARM_CATEGORY_HATE_SPEECH", "threshold": "BLOCK_NONE"},
  //     {"category": "HARM_CATEGORY_HARASSMENT", "threshold": "BLOCK_NONE"},
  //     {"category": "HARM_CATEGORY_SEXUAL", "threshold": "BLOCK_NONE"},
  //     {"category": "HARM_CATEGORY_DANGEROUS_CONTENT", "threshold": "BLOCK_NONE"}
  //   ]
  // };


final body = {
  "system_instruction": {
    "parts": [
      {"text": systemInstruction}
    ]
  },
  "contents": [
    {
      "role": "user",
      "parts": [{"text": intent}]
    }
  ],
  "generationConfig": {
    "temperature": temperature,
    "topK": 32,
    "topP": 0.9,
    "maxOutputTokens": maxOutputTokens,
    "stopSequences": []
  },
  "safetySettings": [
    {"category": "HARM_CATEGORY_HATE_SPEECH", "threshold": "BLOCK_NONE"},
    {"category": "HARM_CATEGORY_HARASSMENT", "threshold": "BLOCK_NONE"},
    {"category": "HARM_CATEGORY_SEXUALLY_EXPLICIT", "threshold": "BLOCK_NONE"},
    {"category": "HARM_CATEGORY_DANGEROUS_CONTENT", "threshold": "BLOCK_NONE"}
    // {"category": "HARM_CATEGORY_CIVIC_INTEGRITY", "threshold": "BLOCK_NONE"}, // اختياري
  ]
};




  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      final reply = _extractGeminiText(data);
      logSuccess("Gemini reply = ${reply.substring(0, reply.length.clamp(0, 500))}");

      // 4) أضِف رد النموذج
      messages.add(ChatMessage(text: reply, isUser: false));

      // 5) تقدّم للخطوة التالية
      click = (step < 15) ? step + 1 : 15;

      // 6) صيانة الحالة
      isLoading = false;

      // حفظ الجلسة
      await _saveCurrentSession();
      notifyListeners();
    } else {
      final err = "خطأ: ${response.statusCode} → ${response.body}";
      messages.add(ChatMessage(text: err, isUser: false));
      isLoading = false;
      await _saveCurrentSession();
      notifyListeners();
      logError("Gemini Error : ${response.statusCode} - ${response.body}");
      throw Exception('فشل الطلب: ${response.statusCode} - ${response.body}');
    }
  } catch (e, st) {
    isLoading = false;
    messages.add(ChatMessage(text: "استثناء: $e", isUser: false));
    await _saveCurrentSession();
    notifyListeners();
    logError("Exception: $e\n$st");
    rethrow;
  }
}

  // Future<void> askGemini(String intent) async {
  //   messages.add(ChatMessage(text: intent, isUser: true));
    
   
  //   // finalText = intent + (prompts1[click]! + prompts2[click]!);
  
  //   isLoading = true;
  //   notifyListeners();
  //   final url = Uri.parse(
  //     'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$apiKey',
  //   );

  //   final response = await http.post(
  //     url,
  //     headers: {'Content-Type': 'application/json'},

  //     body: jsonEncode({
  //       "contents": [
  //         {
  //           "parts": [
  //             {"text": '$intent'}
  //           ],
  //         },
  //       ],
  //     }),
  //   );

  //   if (response.statusCode == 200) {
  //     var data = jsonDecode(response.body);
  //     data['candidates'][0]['content']['parts'][0]['text'] ?? 'No response';

  //     //  final lines = data.split("\n");
  //     logSuccess("message = ${data}");

  //     // نحتفظ بس السطور اللي تبدي بأرقام
  //     messages.add(
  //       ChatMessage(
  //         text: data['candidates'][0]['content']['parts'][0]['text'].toString(),
  //         isUser: false,
  //       ),
  //     );
  //     click++;
  //     isLoading = false;
  //     intent = '';
  //     data = '';

  //     // حفظ المحادثة تلقائياً
  //     await _saveCurrentSession();

  //     notifyListeners();
  //   } else {
  //     messages.add(
  //       ChatMessage(
  //         text: "خطأ: ${response.statusCode} → ${response.body}",
  //         isUser: false,
  //       ),
  //     );
  //     isLoading = false;

  //     // حفظ المحادثة حتى لو كان هناك خطأ
  //     await _saveCurrentSession();

  //     notifyListeners();
  //     logError("message : ${response.statusCode} - ${response.body}");
  //     throw Exception('فشل الطلب: ${response.statusCode} - ${response.body}');
  //   }
  //   isLoading = false;
  //   notifyListeners();
  // }

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
