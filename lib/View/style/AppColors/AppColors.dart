
import 'package:flutter/material.dart';

class AppColors {
  static Color background(bool dark) => dark ? const Color(0xFF121212) : const Color(0xFFF7FAFC);
  static Color curveTop1(bool dark) => dark ? const Color(0xFF1E1E1E) : const Color(0xFFB2DFDB);
  static Color curveTop2(bool dark) => dark ? const Color(0xFF2C2C2C) : const Color(0xFFE0F7FA);
  static Color curveBottom1(bool dark) => dark ? const Color(0xFF1E1E1E) : const Color(0xFFE0F2F1);
  static Color curveBottom2(bool dark) => dark ? const Color(0xFF2C2C2C) : const Color(0xFFB2DFDB);
  static Color card(bool dark) => dark ? const Color(0xFF1F1F1F) : Colors.white;
  static Color shadow(bool dark) => dark ? Colors.tealAccent : Colors.teal;
  static Color accent(bool dark) => dark ? Colors.tealAccent : const Color(0xFF80CBC4);
  static Color textMain(bool dark) => dark ? Colors.white : const Color(0xFF455A64);
  static Color sliderActive(bool dark) => dark ? Colors.tealAccent : Colors.teal;
}
