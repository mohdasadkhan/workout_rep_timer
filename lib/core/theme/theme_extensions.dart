// In core/theme/theme_extensions.dart
import 'package:app_lifecycle/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

extension ThemeExtension on BuildContext {
  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colors => Theme.of(this).colorScheme;

  Color get primary => AppColors.primary;
  Color get workColor => AppColors.work;
  // ...
}
