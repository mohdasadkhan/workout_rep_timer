import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  // Headings
  static const TextStyle headlineLarge = TextStyle(
    fontSize: 34,
    fontWeight: FontWeight.w900,
    letterSpacing: -0.5,
    color: AppColors.textPrimary,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  // Titles
  static const TextStyle titleLarge = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle titleMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  // Body
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  // Labels & Small
  static const TextStyle labelLarge = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.5,
    color: AppColors.textPrimary,
  );

  static const TextStyle labelSmall = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w700,
    letterSpacing: 2.5,
    color: AppColors.textTertiary,
  );

  // Timer Specific
  static const TextStyle timerDisplay = TextStyle(
    fontSize: 72,
    fontWeight: FontWeight.w900,
    letterSpacing: -2,
    color: AppColors.textPrimary,
  );

  static const TextStyle phaseBadge = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w800,
    letterSpacing: 2.5,
  );

  static const TextStyle sequenceItem = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );
}
