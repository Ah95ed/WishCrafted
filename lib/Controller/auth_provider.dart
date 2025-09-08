import 'package:flutter/material.dart';
import 'package:wishcrafted/Models/AppwriteService/app_writeService.dart';

class AuthProvider extends ChangeNotifier {
  final AppwriteService _service = AppwriteService();

  bool isLoading = false;
  bool isSuccess = false;
  String? error;
  bool isLoggedIn = false;

  /// Register a new user using AppwriteService
  Future<bool> register(
    String email,
    String password,
    String phoneNumber,
  ) async {
    isLoading = true;
    error = null;
    isSuccess = false;
    notifyListeners();

    try {
      final res = await _service.createAccount(email, password, phoneNumber);
      if (res == true) {
        isSuccess = true;
        isLoggedIn = true;
        isLoading = false;
        notifyListeners();
        return true;
      } else {
        error =
            'فشل إنشاء الحساب. يرجى التأكد من صحة البيانات والمحاولة مرة أخرى';
        isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      isLoading = false;

      // Handle specific Appwrite errors
      String errorMessage = 'حدث خطأ غير متوقع';
      if (e.toString().contains('user_already_exists')) {
        errorMessage = 'رقم الهاتف أو البريد الإلكتروني مستخدم مسبقاً';
      } else if (e.toString().contains('password')) {
        errorMessage = 'كلمة المرور ضعيفة جداً';
      } else if (e.toString().contains('email')) {
        errorMessage = 'البريد الإلكتروني غير صحيح';
      } else if (e.toString().contains('network')) {
        errorMessage = 'تعذر الاتصال بالشبكة';
      }

      error = errorMessage;
      notifyListeners();
      return false;
    }
  }

  /// Login user using AppwriteService
  Future<bool> login(String email, String password) async {
    isLoading = true;
    error = null;
    isSuccess = false;
    notifyListeners();

    try {
      final res = await _service.login(email, password);
      if (res == true) {
        isSuccess = true;
        isLoggedIn = true;
        isLoading = false;
        notifyListeners();
        return true;
      } else {
        error = 'فشل تسجيل الدخول. يرجى التأكد من صحة البيانات';
        isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      isLoading = false;

      // Handle specific login errors
      String errorMessage = 'حدث خطأ غير متوقع';
      if (e.toString().contains('user_invalid_credentials')) {
        errorMessage = 'البريد الإلكتروني أو كلمة المرور غير صحيحة';
      } else if (e.toString().contains('user_not_found')) {
        errorMessage = 'المستخدم غير موجود';
      } else if (e.toString().contains('network')) {
        errorMessage = 'تعذر الاتصال بالشبكة';
      }

      error = errorMessage;
      notifyListeners();
      return false;
    }
  }

  /// Logout user
  Future<bool> logout() async {
    isLoading = true;
    notifyListeners();

    try {
      final res = await _service.logout();
      isLoggedIn = false;
      isSuccess = false;
      error = null;
      isLoading = false;
      notifyListeners();
      return res;
    } catch (e) {
      isLoading = false;
      error = 'فشل تسجيل الخروج';
      notifyListeners();
      return false;
    }
  }

  /// Check if user is logged in
  Future<void> checkLoginStatus() async {
    try {
      isLoggedIn = await _service.isLoggedIn();
      notifyListeners();
    } catch (e) {
      isLoggedIn = false;
      notifyListeners();
    }
  }

  /// Reset password using email
  Future<bool> resetPassword(String email) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final res = await _service.resetPassword(email);
      if (res == true) {
        isLoading = false;
        notifyListeners();
        return true;
      } else {
        error = 'فشل في إرسال رابط إعادة تعيين كلمة المرور';
        isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      isLoading = false;

      // Handle specific reset password errors
      String errorMessage = 'حدث خطأ غير متوقع';
      if (e.toString().contains('user_not_found')) {
        errorMessage = 'البريد الإلكتروني غير مسجل';
      } else if (e.toString().contains('email')) {
        errorMessage = 'البريد الإلكتروني غير صحيح';
      } else if (e.toString().contains('network')) {
        errorMessage = 'تعذر الاتصال بالشبكة';
      }

      error = errorMessage;
      notifyListeners();
      return false;
    }
  }

  /// Delete user account
  Future<bool> deleteAccount() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final res = await _service.deleteAccount();
      if (res) {
        isLoggedIn = false;
        isSuccess = false;
        error = null;
        isLoading = false;
        notifyListeners();
        return true;
      } else {
        error = 'فشل حذف الحساب. يرجى المحاولة مرة أخرى';
        isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      isLoading = false;

      // Handle specific delete account errors
      String errorMessage = 'حدث خطأ غير متوقع';
      if (e.toString().contains('user_unauthorized')) {
        errorMessage = 'ليس لديك صلاحية لحذف هذا الحساب';
      } else if (e.toString().contains('network')) {
        errorMessage = 'تعذر الاتصال بالشبكة';
      } else {
        errorMessage = 'فشل حذف الحساب';
      }

      error = errorMessage;
      notifyListeners();
      return false;
    }
  }
}
