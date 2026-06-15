import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';
import 'theme_extensions.dart';

class AppTheme {
  static const TextTheme _baseTextTheme = TextTheme(
    headlineLarge: AppTextStyles.headlineLarge,
    headlineMedium: AppTextStyles.headlineMedium,
    titleLarge: AppTextStyles.titleLarge,
    titleMedium: AppTextStyles.titleMedium,
    bodyLarge: AppTextStyles.bodyLarge,
    bodyMedium: AppTextStyles.bodyMedium,
    labelLarge: AppTextStyles.labelLarge,
    labelSmall: AppTextStyles.labelSmall,
  );

  static ThemeData get lightTheme {
    final baseTheme = ThemeData.light(useMaterial3: true);
    final colorScheme = const ColorScheme.light(
      primary: AppColors.primary,
      primaryContainer: AppColors.primaryLight,
      secondary: AppColors.primary,
      surface: Colors.white,
      surfaceContainerHighest: Color(0xFFF5F5F5),
      onSurface: Color(0xFF1F1F1F),
      onSurfaceVariant: Color(0xFF5F5F5F),
      outline: Color(0xFFE0E0E0),
      error: AppColors.error,
      onPrimary: Colors.white,
    );

    return baseTheme.copyWith(
      brightness: Brightness.light,
      scaffoldBackgroundColor: const Color(0xFFF8F9FA),
      colorScheme: colorScheme,
      extensions: [
        const AppColorsExtension(
          phaseWork: AppColors.workLight,
          phaseRest: AppColors.restLight,
          phaseRestBetweenSets: AppColors.restBetweenSets,
          phasePrepare: AppColors.prepareLight,
          phaseCoolDown: AppColors.coolDownLight,
          cardBorder: Color(0xFFE0E0E0),
          chipBackground: Color(0xFFF5F5F5),
          chipText: Color(0xFF1F1F1F),
        ),
      ],
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFFF8F9FA),
        elevation: 0,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Color(0xFF1F1F1F),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF1F1F1F)),
      ),

      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: colorScheme.primary.withOpacity(0.15)),
        ),
        margin: const EdgeInsets.only(bottom: 12),
      ),
      textTheme: _baseTextTheme,
      primaryTextTheme: _baseTextTheme,
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          minimumSize: const Size(double.infinity, 56),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.onSurface,
          side: BorderSide(color: colorScheme.outline),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    final baseTheme = ThemeData.dark(useMaterial3: true);
    final colorScheme = const ColorScheme.dark(
      primary: AppColors.primary,
      primaryContainer: AppColors.primaryDark,
      secondary: AppColors.primary,
      surface: AppColors.surface,
      surfaceContainerHighest: Color(0xFF2A2A35),
      onSurface: AppColors.textPrimary,
      onSurfaceVariant: AppColors.textSecondary,
      outline: Color(0x33FFFFFF),
      error: AppColors.error,
      onPrimary: Colors.white,
    );

    return baseTheme.copyWith(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: colorScheme,
      extensions: [
        const AppColorsExtension(
          phaseWork: AppColors.work,
          phaseRest: AppColors.rest,
          phaseRestBetweenSets: AppColors.restBetweenSets,
          phasePrepare: AppColors.prepare,
          phaseCoolDown: AppColors.coolDown,
          cardBorder: Color(0x33FFFFFF),
          chipBackground: Color(0xFF2A2A35),
          chipText: AppColors.textPrimary,
        ),
      ],
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      cardTheme: CardThemeData(
        color: AppColors.card,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: colorScheme.outline.withOpacity(0.3)),
        ),
        margin: const EdgeInsets.only(bottom: 12),
      ),
      textTheme: _baseTextTheme,
      primaryTextTheme: _baseTextTheme,
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 4,
          shadowColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          minimumSize: const Size(double.infinity, 60),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.onSurfaceVariant,
          side: BorderSide(color: colorScheme.outline),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          minimumSize: const Size(double.infinity, 50),
        ),
      ),
      iconTheme: const IconThemeData(color: AppColors.textPrimary),
    );
  }

  static ThemeData getTheme(ThemeMode mode, [Brightness? platformBrightness]) {
    switch (mode) {
      case ThemeMode.light:
        return lightTheme;
      case ThemeMode.dark:
        return darkTheme;
      case ThemeMode.system:
      default:
        return platformBrightness == Brightness.light ? lightTheme : darkTheme;
    }
  }
}
