import 'package:flutter/material.dart';

class AppColors {
  // Background & Surface
  static const Color background = Color(0xFF0A0A0F);
  static const Color surface = Color(0xFF12121A);
  static const Color card = Color(0xFF1A1A24);

  // Primary Brand
  // static const Color primary = Color(0xFF00E5A0); // Teal accent used heavily, grok
  static const Color primary = Color(
    0xFF009688,
  ); // Teal accent used heavily, gemini
  // static const Color primary = Colors.teal;

  // Phase Colors (Timer specific)
  static const Color work = Color(0xFF00E5A0);
  static const Color rest = Color(0xFF4FC3F7);
  static const Color prepare = Color(0xFFFFD54F);
  static const Color coolDown = Color(0xFFCE93D8);

  // Text
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFFAAAAAA);
  static const Color textTertiary = Color(0xFF777777);

  // Actions & Status
  static const Color error = Color(0xFFFF4757);
  static const Color success = Color(0xFF00E5A0);
  static const Color warning = Color(0xFFFFD54F);

  // Glass / Border effects
  static const Color glass = Color(0xFFFFFFFF);
  static const Color glassBorder = Color(0xFFFFFFFF);

  // Neutral
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color grey = Colors.grey;
}
