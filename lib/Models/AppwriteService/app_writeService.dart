import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';

import 'package:wishcrafted/Helper/LogApp/LogApp.dart';

class AppwriteService {
  static const String appwriteProjectId = '68bd6f73002b686be1f3';
  static const String appwriteProjectName = 'wishcrafted-fbf54';
  static const String appwritePublicEndpoint =
      'https://fra.cloud.appwrite.io/v1';

  late Client client;

  AppwriteService() {
    client = Client()
        .setEndpoint(appwritePublicEndpoint)
        .setProject(appwriteProjectId);
  }

  Future createAccount(
    String email,
    String password,
    String phoneNumber,
    String userName,
  ) async {
    final account = Account(client);
    try {
      await account.create(
        userId: phoneNumber,
        email: email,
        password: password,
        name: userName, // إضافة اسم المستخدم
      );
      return true;
    } catch (e) {
      rethrow; // Re-throw to preserve error details
    }
  }

  Future<bool> login(String email, String password) async {
    final account = Account(client);
    try {
      await account.createEmailPasswordSession(
        email: email,
        password: password,
      );
      return true;
    } catch (e) {
      rethrow; // Re-throw to preserve error details
    }
  }

  Future<bool> logout() async {
    final account = Account(client);
    try {
      print('🔐 محاولة حذف الجلسة الحالية...');

      // التحقق من وجود جلسة نشطة أولاً
      try {
        User currentUser = await account.get();

        logSuccess('message المرئية: ${currentUser.phone}');

        // إذا كانت هناك جلسة نشطة، احذفها
        await account.deleteSession(sessionId: 'current');
        print('✅ تم حذف الجلسة بنجاح');
      } catch (e) {
        // إذا لم تكن هناك جلسة نشطة، فالمستخدم غير مسجل دخول بالفعل
        print('ℹ️ لا توجد جلسة نشطة أو المستخدم غير مسجل دخول بالفعل');
      }

      return true;
    } catch (e) {
      print('❌ خطأ في حذف الجلسة: $e');
      return false;
    }
  }

  Future<bool> isLoggedIn() async {
    final account = Account(client);
    try {
      final user = await account.get();
      // التحقق من أن المستخدم ليس guest
      return user.$id.isNotEmpty && !user.$id.startsWith('guest');
    } catch (e) {
      print('المستخدم غير مسجل دخول: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>?> getCurrentUser() async {
    final account = Account(client);
    try {
      final user = await account.get();
      return {
        'id': user.$id,
        'name': user.name,
        'email': user.email,
        'phone': user.phone,
        'createdAt': user.$createdAt,
      };
    } catch (e) {
      print('خطأ في الحصول على بيانات المستخدم: $e');
      return null;
    }
  }

  Future<bool> resetPassword(String email) async {
    final account = Account(client);
    try {
      await account.createRecovery(
        email: email,
        url:
            'https://yourdomain.com/reset-password', // يجب أن يكون رابط صفحة حقيقية تستقبل رمز إعادة التعيين
      );
      return true;
    } catch (e) {
      print('خطأ في إرسال رابط إعادة تعيين كلمة المرور: $e');
      return false;
    }
  }

  Future<bool> deleteAccount() async {
    final account = Account(client);
    try {
      print('🗑️ محاولة حذف جميع الجلسات...');

      // التحقق من وجود جلسة نشطة أولاً
      try {
        await account.get();
        // في Appwrite، نحذف جميع الجلسات كنوع من "حذف الحساب"
        // حيث أن حذف الحساب الفعلي يتطلب صلاحيات خاصة
        await account.deleteSessions();
        print('✅ تم حذف جميع الجلسات بنجاح');
      } catch (e) {
        print('ℹ️ لا توجد جلسة نشطة أو المستخدم غير مسجل دخول بالفعل');
      }

      return true;
    } catch (e) {
      print('❌ خطأ في حذف الحساب: $e');
      rethrow; // Re-throw to preserve error details
    }
  }
}
