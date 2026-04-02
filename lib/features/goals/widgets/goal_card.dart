// ─── lib/features/goals/widgets/goal_card.dart ───
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/date_utils.dart' as app_dates;
import '../../../data/models/goal.dart';

class GoalCard extends StatelessWidget {
  const GoalCard({
    super.key,
    required this.goal,
    this.onAddMoney,
    this.onComplete,
    this.onCheckIn,
    this.isCompleted = false,
    this.contributionStreak = 0,
  });

  final Goal goal;
  final VoidCallback? onAddMoney;
  final VoidCallback? onComplete;
  final VoidCallback? onCheckIn;
  final bool isCompleted;
  final int contributionStreak;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final progress = goal.progress.clamp(0.0, 1.0);
    final progressColor = progress < 0.5
        ? AppColors.accent
        : progress < 1.0
            ? AppColors.primary
            : AppColors.success;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCompleted
              ? AppColors.success.withOpacity(0.3)
              : (isDark ? Colors.white10 : AppColors.border.withOpacity(0.5)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: progressColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  goal.type.icon,
                  color: progressColor,
                  size: 22,
                ),
              ),
              const Gap(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      goal.title,
                      style: AppTextStyles.headlineSmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Gap(2),
                    Text(
                      goal.type.displayName,
                      style: AppTextStyles.bodySmall,
                    ),
                  ],
                ),
              ),
              if (isCompleted)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Done!',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.success,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              if (!isCompleted)
                Row(
                  children: [
                    Icon(
                      Icons.local_fire_department,
                      size: 18,
                      color: contributionStreak > 0 ? Colors.orange : (isDark ? Colors.white24 : Colors.black26),
                    ),
                    const Gap(2),
                    Text(
                      '$contributionStreak',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: contributionStreak > 0 ? Colors.orange : (isDark ? Colors.white54 : Colors.black54),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
            ],
          ),
          const Gap(16),

          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: progress),
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOutCubic,
              builder: (context, value, _) => LinearProgressIndicator(
                value: value,
                backgroundColor: progressColor.withOpacity(0.15),
                valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                minHeight: 8,
              ),
            ),
          ),
          const Gap(12),

          // Amount info
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                CurrencyFormatter.display(goal.currentAmount),
                style: AppTextStyles.amountSmall.copyWith(
                  color: progressColor,
                ),
              ),
              Text(
                'of ${CurrencyFormatter.display(goal.targetAmount)}',
                style: AppTextStyles.bodySmall,
              ),
            ],
          ),

          // Deadline and streak
          if (goal.deadline != null || goal.streakDays > 0) ...[
            const Gap(12),
            Row(
              children: [
                if (goal.deadline != null) ...[
                  Icon(
                    Icons.schedule,
                    size: 14,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.textSecondary,
                  ),
                  const Gap(4),
                  Text(
                    app_dates.AppDateUtils.daysRemaining(goal.deadline!),
                    style: AppTextStyles.bodySmall,
                  ),
                ],
                if (goal.deadline != null && goal.streakDays > 0)
                  const SizedBox(width: 16),
                if (goal.streakDays > 0) ...[
                  const Icon(
                    Icons.local_fire_department,
                    size: 14,
                    color: AppColors.accent,
                  ),
                  const Gap(4),
                  Text(
                    '${goal.streakDays} day streak',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.accent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ],

          // Action buttons
          if (!isCompleted) ...[
            const Gap(16),
            Row(
              children: [
                if (goal.type == GoalType.savings && onAddMoney != null)
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onAddMoney,
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('Add Money'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: BorderSide(
                          color: AppColors.primary.withOpacity(0.5),
                        ),
                      ),
                    ),
                  ),
                if (goal.type == GoalType.noSpend && onCheckIn != null)
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onCheckIn,
                      icon: const Icon(Icons.check_circle_outline, size: 18),
                      label: const Text('Check In Today'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.accent,
                        side: BorderSide(
                          color: AppColors.accent.withOpacity(0.5),
                        ),
                      ),
                    ),
                  ),
                if (goal.type == GoalType.budget) ...[
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onAddMoney,
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('Track Spending'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.accent,
                        side: BorderSide(
                          color: AppColors.accent.withOpacity(0.5),
                        ),
                      ),
                    ),
                  ),
                ],
                if (onComplete != null) ...[
                  const Gap(8),
                  IconButton(
                    onPressed: onComplete,
                    icon: const Icon(Icons.check_circle_outline),
                    color: AppColors.success,
                    tooltip: 'Mark complete',
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }
}
