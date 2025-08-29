import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wishcrafted/Models/chat_message.dart';
import 'package:wishcrafted/Models/conversation.dart';
import 'package:uuid/uuid.dart';

class ChatProvider extends ChangeNotifier {
  static const String _prefsKey = 'chat_conversations_v1';

  final _uuid = const Uuid();

  List<Conversation> conversations = [];
  String? currentId;
  bool isLoading = false;

  ChatProvider() {
    _loadConversations();
  }

  Conversation _ensureCurrent() {
    if (currentId == null || !conversations.any((c) => c.id == currentId)) {
      final id = _uuid.v4();
      final conv = Conversation(
        id: id,
        title: 'محادثة جديدة',
        messages: [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      conversations.insert(0, conv);
      currentId = id;
    }
    return conversations.firstWhere((c) => c.id == currentId);
  }

  List<ChatMessage> get currentMessages => _ensureCurrent().messages;

  Future<void> _loadConversations() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_prefsKey);
      if (raw != null && raw.isNotEmpty) {
        final list = (jsonDecode(raw) as List)
            .map((e) => Conversation.fromJson(e as Map<String, dynamic>))
            .toList();
        conversations = list;
        if (conversations.isNotEmpty) {
          currentId = conversations.first.id;
        }
        notifyListeners();
      } else {
        _ensureCurrent();
        await _saveConversations();
      }
    } catch (_) {
      _ensureCurrent();
    }
  }

  Future<void> _saveConversations() async {
    final prefs = await SharedPreferences.getInstance();
    final data = jsonEncode(conversations.map((c) => c.toJson()).toList());
    await prefs.setString(_prefsKey, data);
  }

  Future<void> startNewConversation({String title = 'محادثة جديدة'}) async {
    final id = _uuid.v4();
    final conv = Conversation(
      id: id,
      title: title,
      messages: [],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    conversations.insert(0, conv);
    currentId = id;
    notifyListeners();
    await _saveConversations();
  }

  Future<void> switchConversation(String id) async {
    if (conversations.any((c) => c.id == id)) {
      currentId = id;
      notifyListeners();
    }
  }

  Future<void> renameConversation(String id, String newTitle) async {
    final i = conversations.indexWhere((c) => c.id == id);
    if (i != -1) {
      conversations[i].title = newTitle.trim().isEmpty ? 'محادثة' : newTitle;
      conversations[i].updatedAt = DateTime.now();
      notifyListeners();
      await _saveConversations();
    }
  }

  Future<void> deleteConversation(String id) async {
    conversations.removeWhere((c) => c.id == id);
    if (currentId == id) {
      currentId = conversations.isNotEmpty ? conversations.first.id : null;
      _ensureCurrent();
    }
    notifyListeners();
    await _saveConversations();
  }

  // إرسال رسالة (يضيف للمحادثة الحالية)
  Future<void> sendMessage(String prompt) async {
    final conv = _ensureCurrent();
    conv.messages.add(ChatMessage(text: prompt, isUser: true));
    conv.updatedAt = DateTime.now();
    isLoading = true;
    notifyListeners();
    await _saveConversations();

    // ——— API (اختياري) ———
    final apiKey = 'YOUR_OPENAI_API_KEY';
    final url = Uri.parse('https://api.openai.com/v1/chat/completions');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey',
    };
    final body = jsonEncode({
      'model': 'gpt-3.5-turbo',
      'messages': [
        {'role': 'user', 'content': prompt},
      ],
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final reply = data['choices'][0]['message']['content'] as String;
        conv.messages.add(
          ChatMessage(text: reply, isUser: false, animate: true),
        );
      } else {
        conv.messages.add(
          ChatMessage(
            text: 'حدث خطأ في الاتصال بالذكاء الاصطناعي.',
            isUser: false,
          ),
        );
      }
    } catch (e) {
      conv.messages.add(
        ChatMessage(text: 'تعذر الاتصال بالخادم.', isUser: false),
      );
    }

    conv.updatedAt = DateTime.now();
    isLoading = false;
    notifyListeners();

    // أوقف الأنميشن بعد أول عرض حتى لا يظهر عند الرجوع للمحادثة
    Future.microtask(() {
      final last = conv.messages.isNotEmpty ? conv.messages.last : null;
      if (last != null && !last.isUser && last.animate) {
        last.animate = false;
        notifyListeners();
      }
    });

    await _saveConversations();
  }

  // مسح رسائل المحادثة الحالية فقط
  Future<void> clearCurrentMessages() async {
    final conv = _ensureCurrent();
    conv.messages = [];
    conv.updatedAt = DateTime.now();
    notifyListeners();
    await _saveConversations();
  }
}
