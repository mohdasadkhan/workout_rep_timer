import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:fitflow/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

import 'app_snackbar_type.dart';

class AppSnackbar {
  static void show({
    required BuildContext context,
    required String title,
    required String message,
    required AppSnackbarType type,
    Duration duration = const Duration(seconds: 3),
  }) {
    final messenger = ScaffoldMessenger.of(context);

    messenger.hideCurrentSnackBar();

    final contentType = switch (type) {
      AppSnackbarType.success => ContentType.success,
      AppSnackbarType.error => ContentType.failure,
      AppSnackbarType.warning => ContentType.warning,
      AppSnackbarType.info => ContentType.help,
    };

    messenger.showSnackBar(
      SnackBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        behavior: SnackBarBehavior.floating,
        duration: duration,
        margin: const EdgeInsets.all(16),
        content: AwesomeSnackbarContent(
          title: title,
          message: message,
          contentType: contentType,
        ),
      ),
    );
  }

  static void showUndo({
    required BuildContext context,
    required String message,
    required VoidCallback onUndo,
    Duration duration = const Duration(seconds: 5),
  }) {
    final messenger = ScaffoldMessenger.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    messenger.hideCurrentSnackBar();

    messenger.showSnackBar(
      SnackBar(
        duration: duration,
        behavior: SnackBarBehavior.floating,
        elevation: 0,
        backgroundColor: Colors.transparent,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),

        content: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: isDark ? AppColors.card : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark
                  ? Colors.white.withOpacity(0.08)
                  : Colors.black.withOpacity(0.06),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.20 : 0.08),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),

          child: Row(
            children: [
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.delete_outline_rounded,
                  color: AppColors.error,
                  size: 22,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Text(
                  message,
                  style: TextStyle(
                    color: isDark
                        ? AppColors.textPrimary
                        : const Color(0xFF1F1F1F),
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              TextButton(
                onPressed: () {
                  messenger.hideCurrentSnackBar();
                  onUndo();
                },
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                ),
                child: const Text(
                  'UNDO',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
