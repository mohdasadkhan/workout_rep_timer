import 'package:app_lifecycle/core/theme/app_colors.dart';
import 'package:app_lifecycle/core/theme/app_text_styles.dart';
import 'package:app_lifecycle/features/rep_tracker/domain/entities/personal_record.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PersonalRecordCard extends StatelessWidget {
  final PersonalRecord pr;
  const PersonalRecordCard({super.key, required this.pr});

  String _formatWeight(double weight) {
    if (weight == 0) return '0 kg';
    return weight % 1 == 0
        ? '${weight.toInt()} kg'
        : '${weight.toStringAsFixed(1)} kg';
  }

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('d MMM yyyy').format(pr.achievedAt);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          // Trophy icon — tinted primary square
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(13),
              border: Border.all(color: AppColors.primary.withOpacity(0.18)),
            ),
            child: const Icon(
              Icons.emoji_events_rounded,
              color: AppColors.primary,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),

          // Exercise name + date
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pr.exerciseName,
                  style: AppTextStyles.titleMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Text(
                  dateStr,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textTertiary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),

          // Best weight + reps — right-aligned
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _formatWeight(pr.bestWeightKg),
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                  letterSpacing: -0.5,
                ),
              ),
              Text(
                '× ${pr.repsAtBestWeight} reps',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textTertiary,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
