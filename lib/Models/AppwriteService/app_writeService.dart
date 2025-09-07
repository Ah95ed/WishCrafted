import 'package:appwrite/appwrite.dart';

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
  ) async {
    final account = Account(client);
    try {
      await account.create(
        userId: phoneNumber,
        email: email,
        password: password,
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
      await account.deleteSession(sessionId: 'current');
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> isLoggedIn() async {
    final account = Account(client);
    try {
      await account.get();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> resetPassword(String email) async {
    final account = Account(client);
    try {
      await account.createRecovery(
        email: email,
        url:
            'https://wishcrafted.app/reset-password', // Replace with your app's reset URL
      );
      return true;
    } catch (e) {
      rethrow; // Re-throw to preserve error details
    }
  }
}
