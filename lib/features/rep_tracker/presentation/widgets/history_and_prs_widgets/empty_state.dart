import 'package:app_lifecycle/core/theme/app_colors.dart';
import 'package:app_lifecycle/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String message;
  const EmptyState({super.key, required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withOpacity(0.07),
              ),
              child: Icon(icon, size: 36, color: AppColors.textTertiary),
            ),
            const SizedBox(height: 20),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textTertiary,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
