import 'package:flutter/material.dart';
import 'package:wishcrafted/View/AccessibleHomePage.dart';
import 'package:wishcrafted/View/AuthGoogle.dart';
import 'package:wishcrafted/View/LoginScreen.dart';
import 'package:wishcrafted/View/SpecialNeedsScreen.dart';

void main() {
  runApp(const WishCraftedApp());
}

class WishCraftedApp extends StatelessWidget {
  const WishCraftedApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WishCrafted Login',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        brightness: Brightness.light,
      ),
      home: AccessibleHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
