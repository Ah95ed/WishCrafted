import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wishcrafted/Helper/Service/initService.dart';
import 'package:wishcrafted/Models/chat_session.dart';
import 'package:wishcrafted/Models/chat_message.dart';

class ChatStorageService {
  static const String _chatSessionsKey = 'chat_sessions';
  static const String _currentSessionKey = 'current_session_id';

  /// حفظ جميع المحادثات
  static Future<void> saveChatSessions(List<ChatSession> sessions) async {
    final sessionJsonList = sessions
        .map((session) => session.toJson())
        .toList();
    await shared.setString(_chatSessionsKey, jsonEncode(sessionJsonList));
  }

  /// تحميل جميع المحادثات
  static Future<List<ChatSession>> loadChatSessions() async {

    final sessionsJson = shared.getString(_chatSessionsKey);

    if (sessionsJson == null) {
      return [];
    }

    try {
      final List<dynamic> sessionList = jsonDecode(sessionsJson);
      return sessionList
          .map((sessionJson) => ChatSession.fromJson(sessionJson))
          .toList();
    } catch (e) {
      print('خطأ في تحميل المحادثات: $e');
      return [];
    }
  }

  /// حفظ محادثة واحدة
  static Future<void> saveChatSession(ChatSession session) async {
    final sessions = await loadChatSessions();
    final existingIndex = sessions.indexWhere((s) => s.id == session.id);

    if (existingIndex != -1) {
      sessions[existingIndex] = session;
    } else {
      sessions.add(session);
    }

    await saveChatSessions(sessions);
  }

  /// حذف محادثة
  static Future<void> deleteChatSession(String sessionId) async {
    final sessions = await loadChatSessions();
    sessions.removeWhere((session) => session.id == sessionId);
    await saveChatSessions(sessions);
  }

  /// حفظ معرف المحادثة الحالية
  static Future<void> setCurrentSessionId(String sessionId) async {
    final shared = await SharedPreferences.getInstance();
    await shared.setString(_currentSessionKey, sessionId);
  }

  /// تحميل معرف المحادثة الحالية
  static Future<String?> getCurrentSessionId() async {
    final shared = await SharedPreferences.getInstance();
    return shared.getString(_currentSessionKey);
  }

  /// إنشاء عنوان تلقائي للمحادثة بناءً على أول رسالة
  static String generateChatTitle(List<ChatMessage> messages) {
    if (messages.isEmpty) {
      return 'محادثة جديدة';
    }

    final firstUserMessage = messages.firstWhere(
      (msg) => msg.isUser,
      orElse: () => ChatMessage(text: '', isUser: true),
    );

    if (firstUserMessage.text.isEmpty) {
      return 'محادثة جديدة';
    }

    // أخذ أول 30 حرف من الرسالة
    String title = firstUserMessage.text.trim();
    if (title.length > 30) {
      title = '${title.substring(0, 30)}...';
    }

    return title;
  }

  /// تنظيف البيانات القديمة (اختياري)
  static Future<void> clearAllSessions() async {
    final shared = await SharedPreferences.getInstance();
    await shared.remove(_chatSessionsKey);
    await shared.remove(_currentSessionKey);
  }
}
