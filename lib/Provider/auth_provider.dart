import 'package:flutter/material.dart';
import 'package:wishcrafted/Controller/AuthController/auth_controller.dart';
import 'package:wishcrafted/Helper/Service/auth_service.dart';
import 'package:wishcrafted/Models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  final AuthController _authController = AuthController();

  // Getters that delegate to the controller
  AuthStatus get authStatus => _authController.status;
  UserModel? get currentUser => _authController.currentUser;
  String? get errorMessage => _authController.errorMessage;
  bool get isLoading => _authController.isLoading;
  bool get isAuthenticated => _authController.isAuthenticated;

  AuthProvider() {
    // Listen to controller changes
    _authController.addListener(_onAuthControllerChanged);
  }

  void _onAuthControllerChanged() {
    notifyListeners();
  }

  // Sign in with Google
  Future<bool> signInWithGoogle() async {
    final result = await _authController.signInWithGoogle();
    notifyListeners();
    return result;
  }

  // Sign out
  Future<void> signOut() async {
    await _authController.signOut();
    notifyListeners();
  }

  // Delete account
  Future<bool> deleteAccount() async {
    final result = await _authController.deleteAccount();
    notifyListeners();
    return result;
  }

  // Reload user data
  Future<void> reloadUser() async {
    await _authController.reloadUser();
    notifyListeners();
  }

  // Clear error message
  void clearError() {
    // This would require adding a clearError method to the controller
    notifyListeners();
  }

  @override
  void dispose() {
    _authController.removeListener(_onAuthControllerChanged);
    _authController.dispose();
    super.dispose();
  }
}
