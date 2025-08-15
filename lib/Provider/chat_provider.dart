import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wishcrafted/Models/chat_message.dart';

class ChatProvider extends ChangeNotifier {
  List<ChatMessage> messages = [];
  bool isLoading = false;

  Future<void> sendMessage(String prompt) async {
    messages.add(ChatMessage(text: prompt, isUser: true));
    isLoading = true;
    notifyListeners();

    final apiKey = 'YOUR_OPENAI_API_KEY'; // ضع مفتاحك هنا
    final url = Uri.parse('https://api.openai.com/v1/chat/completions');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey',
    };
    final body = jsonEncode({
      "model": "gpt-3.5-turbo",
      "messages": [
        {"role": "user", "content": prompt},
      ],
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final reply = data['choices'][0]['message']['content'];
        messages.add(ChatMessage(text: reply, isUser: false));
      } else {
        messages.add(
          ChatMessage(
            text: "حدث خطأ في الاتصال بالذكاء الاصطناعي.",
            isUser: false,
          ),
        );
      }
    } catch (e) {
      messages.add(ChatMessage(text: "تعذر الاتصال بالخادم.", isUser: false));
    }

    isLoading = false;
    notifyListeners();
  }
}
