import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wishcrafted/Helper/Service/auth_service.dart';
import 'package:wishcrafted/Provider/auth_provider.dart';
import 'package:wishcrafted/View/DashBoardScreen/DashboardScreen.dart';
import 'package:wishcrafted/View/LoginScreen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        switch (authProvider.authStatus) {
          case AuthStatus.unknown:
          case AuthStatus.loading:
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          case AuthStatus.authenticated:
            return DashboardScreen();
          case AuthStatus.unauthenticated:
          default:
            return LoginScreen();
        }
      },
    );
  }
}
