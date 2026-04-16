import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import 'extension_on_appfeature.dart';

class DropdownOverlay extends StatelessWidget {
  final Offset anchorOffset;
  final Size anchorSize;
  final AppFeature currentFeature;
  final ValueChanged<AppFeature> onSelect;
  final VoidCallback onDismiss;

  const DropdownOverlay({
    super.key,
    required this.anchorOffset,
    required this.anchorSize,
    required this.currentFeature,
    required this.onSelect,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onDismiss,
      child: Material(
        color: Colors.transparent,
        child: Stack(
          children: [
            Positioned(
              left: anchorOffset.dx,
              top: anchorOffset.dy + anchorSize.height + 8,
              child: Material(
                elevation: 12,
                shadowColor: Colors.grey[900],
                color: Color(0xFF242424),
                borderRadius: BorderRadius.circular(16),
                child: IntrinsicWidth(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: AppFeature.values.map((feature) {
                      final isSelected = feature == currentFeature;
                      return InkWell(
                        onTap: () => onSelect(feature),
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 14,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                feature.icon,
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.textPrimary,
                                size: 22,
                              ),
                              const SizedBox(width: 16),
                              Text(
                                feature.label,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.w500,
                                  color: isSelected
                                      ? AppColors.primary
                                      : AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
