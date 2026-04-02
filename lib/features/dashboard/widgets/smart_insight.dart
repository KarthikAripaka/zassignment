// ─── lib/features/dashboard/widgets/smart_insight.dart ───
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/currency_formatter.dart';
import '../providers/dashboard_provider.dart';

class SmartInsight extends StatelessWidget {
  const SmartInsight({
    super.key,
    required this.data,
  });

  final DashboardData data;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final insight = _generateInsight();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [AppColors.primary.withOpacity(0.2), AppColors.accent.withOpacity(0.1)]
              : [AppColors.primary.withOpacity(0.08), AppColors.accent.withOpacity(0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              insight.icon,
              color: AppColors.primary,
              size: 22,
            ),
          ),
          const Gap(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  insight.title,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
                const Gap(4),
                Text(
                  insight.message,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _Insight _generateInsight() {
    // Insight 1: High savings rate
    if (data.savingsRate > 30) {
      return _Insight(
        icon: Icons.emoji_events,
        title: 'GREAT SAVER',
        message: 'You\'re saving ${data.savingsRate.toStringAsFixed(0)}% of income this month. Keep it up!',
      );
    }

    // Insight 2: Low savings warning
    if (data.monthIncome > 0 && data.savingsRate < 10) {
      final expensePercent = ((data.monthExpenses / data.monthIncome) * 100).clamp(0.0, 999.0);
      return _Insight(
        icon: Icons.warning_amber,
        title: 'SPENDING ALERT',
        message: 'You\'ve spent ${expensePercent.toStringAsFixed(0)}% of income. Consider cutting back.',
      );
    }

    // Insight 3: Top spending category
    if (data.topCategoryId != null && data.topCategoryAmount > 0) {
      return _Insight(
        icon: Icons.insights,
        title: 'TOP SPENDING',
        message: '${data.topCategoryId![0].toUpperCase()}${data.topCategoryId!.substring(1)} is your biggest expense at ${CurrencyFormatter.compact(data.topCategoryAmount)}.',
      );
    }

    // Insight 4: Active goals
    if (data.activeGoals.isNotEmpty) {
      return _Insight(
        icon: Icons.flag,
        title: 'GOAL FOCUS',
        message: 'You have ${data.activeGoals.length} active goal${data.activeGoals.length > 1 ? 's' : ''}. Stay on track!',
      );
    }

    // Default: Getting started
    return _Insight(
      icon: Icons.tips_and_updates,
      title: 'QUICK TIP',
      message: 'Track every expense to see where your money goes.',
    );
  }
}

class _Insight {
  const _Insight({
    required this.icon,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String message;
}
