import 'package:flutter/material.dart';
import 'package:wishcrafted/View/SpecialNeedsScreen.dart';
import 'package:wishcrafted/View/SplashScreen/SplashScreen.dart';
import 'package:wishcrafted/View/onBorder/onBorderScreen.dart';


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
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
