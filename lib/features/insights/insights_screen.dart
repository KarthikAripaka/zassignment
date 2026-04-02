// ─── lib/features/insights/insights_screen.dart ───
import 'dart:math' as math;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/loading_shimmer.dart';
import '../../data/models/transaction.dart';
import '../../data/models/category.dart';
import '../transactions/providers/transactions_provider.dart';
import 'providers/insights_provider.dart';

class InsightsScreen extends ConsumerWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsBox = ref.watch(transactionsBoxProvider);
    final insightsData = ref.watch(insightsDataProvider);
    final selectedPeriod = ref.watch(insightPeriodProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return transactionsBox.when(
      loading: () => const Scaffold(body: DashboardShimmer()),
      error: (e, _) => Scaffold(body: Center(child: Text('Error: $e'))),
      data: (_) {
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Gap(16),
                  const Text(
                    'Insights',
                    style: AppTextStyles.headlineLarge,
                  ).animate().fadeIn(duration: 400.ms),
                  const Gap(16),

                  // Period selector
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: InsightPeriod.values.map((period) {
                        final isSelected = period == selectedPeriod;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: GestureDetector(
                            onTap: () => ref
                                .read(insightPeriodProvider.notifier)
                                .state = period,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.primary
                                    : (isDark
                                        ? AppColors.darkSurface
                                        : AppColors.surface),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.primary
                                      : AppColors.border.withOpacity(0.5),
                                ),
                              ),
                              child: Text(
                                _periodLabel(period),
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: isSelected
                                      ? Colors.white
                                      : (isDark
                                          ? AppColors.darkTextPrimary
                                          : AppColors.textPrimary),
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const Gap(24),

                  // Category breakdown
                  if (insightsData.categoryBreakdowns.isNotEmpty) ...[
                    const Text(
                      'Spending by Category',
                      style: AppTextStyles.headlineSmall,
                    ),
                    const Gap(12),
                    _CategoryBreakdownChart(
                      breakdowns: insightsData.categoryBreakdowns,
                    ).animate().fadeIn(delay: 100.ms, duration: 400.ms),
                    const Gap(24),
                  ],

                  // Weekly comparison
                  if (insightsData.weeklyComparison.isNotEmpty &&
                      insightsData.weeklyComparison.any(
                        (w) => w.income > 0 || w.expenses > 0,
                      )) ...[
                    const Text(
                      'Income vs Expenses',
                      style: AppTextStyles.headlineSmall,
                    ),
                    const Gap(12),
                    _WeeklyComparisonChart(
                      weeklyData: insightsData.weeklyComparison,
                    ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
                    const Gap(24),
                  ],

                  // Smart insights
                  if (insightsData.insights.isNotEmpty) ...[
                    const Text(
                      'Smart Insights',
                      style: AppTextStyles.headlineSmall,
                    ),
                    const Gap(12),
                    ...insightsData.insights.map(
                      (insight) => _InsightCard(insight: insight)
                          .animate()
                          .fadeIn(delay: 300.ms, duration: 400.ms),
                    ),
                    const Gap(24),
                  ],

                  // Top transactions
                  if (insightsData.topTransactions.isNotEmpty) ...[
                    const Text(
                      'Top Transactions',
                      style: AppTextStyles.headlineSmall,
                    ),
                    const Gap(12),
                    ...insightsData.topTransactions.map(
                      (t) => _TopTransactionItem(transaction: t),
                    ),
                  ],

                  if (insightsData.categoryBreakdowns.isEmpty &&
                      insightsData.insights.isEmpty)
                    const EmptyState(
                      icon: Icons.analytics_outlined,
                      title: 'No data yet',
                      subtitle:
                          'Add transactions to see your spending insights',
                    ),

                  const Gap(32),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _periodLabel(InsightPeriod period) {
    return switch (period) {
      InsightPeriod.thisWeek => 'This Week',
      InsightPeriod.thisMonth => 'This Month',
      InsightPeriod.lastMonth => 'Last Month',
      InsightPeriod.custom => 'Custom',
    };
  }
}

class _CategoryBreakdownChart extends StatefulWidget {
  const _CategoryBreakdownChart({required this.breakdowns});

  final List<CategoryBreakdown> breakdowns;

  @override
  State<_CategoryBreakdownChart> createState() =>
      _CategoryBreakdownChartState();
}

class _CategoryBreakdownChartState extends State<_CategoryBreakdownChart> {
  int _touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final total = widget.breakdowns.fold(0.0, (sum, b) => sum + b.amount);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.white10 : AppColors.border.withOpacity(0.5),
        ),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 180,
            child: PieChart(
              PieChartData(
                sectionsSpace: 3,
                centerSpaceRadius: 40,
                pieTouchData: PieTouchData(
                  touchCallback: (event, response) {
                    setState(() {
                      if (!event.isInterestedForInteractions ||
                          response == null ||
                          response.touchedSection == null) {
                        _touchedIndex = -1;
                      } else {
                        _touchedIndex =
                            response.touchedSection!.touchedSectionIndex;
                      }
                    });
                  },
                ),
                sections: widget.breakdowns.asMap().entries.map((entry) {
                  final index = entry.key;
                  final breakdown = entry.value;
                  final isTouched = index == _touchedIndex;

                  return PieChartSectionData(
                    color: breakdown.category.color,
                    value: breakdown.amount,
                    title:
                        '${(breakdown.percentage * 100).toStringAsFixed(0)}%',
                    radius: isTouched ? 55 : 45,
                    titleStyle: AppTextStyles.bodySmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: isTouched ? 12 : 10,
                    ),
                  );
                }).toList(),
              ),
              swapAnimationDuration: const Duration(milliseconds: 500),
            ),
          ),
          const Gap(16),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: widget.breakdowns.map((b) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: b.category.color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const Gap(6),
                  Text(
                    '${b.category.label} (${CurrencyFormatter.compact(b.amount)})',
                    style: AppTextStyles.bodySmall,
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _WeeklyComparisonChart extends StatelessWidget {
  const _WeeklyComparisonChart({required this.weeklyData});

  final List<WeeklyData> weeklyData;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final maxVal = weeklyData.fold(
      0.0,
      (max, w) => math.max(max, math.max(w.income, w.expenses)),
    );

    return Container(
      height: 200,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.white10 : AppColors.border.withOpacity(0.5),
        ),
      ),
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index < 0 || index >= weeklyData.length) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      weeklyData[index].weekLabel,
                      style: AppTextStyles.bodySmall.copyWith(fontSize: 10),
                    ),
                  );
                },
                reservedSize: 28,
              ),
            ),
            leftTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: weeklyData.asMap().entries.map((e) {
                return FlSpot(e.key.toDouble(), e.value.income);
              }).toList(),
              isCurved: true,
              color: AppColors.success,
              barWidth: 3,
              dotData: const FlDotData(show: true),
              belowBarData: BarAreaData(
                show: true,
                color: AppColors.success.withOpacity(0.1),
              ),
            ),
            LineChartBarData(
              spots: weeklyData.asMap().entries.map((e) {
                return FlSpot(e.key.toDouble(), e.value.expenses);
              }).toList(),
              isCurved: true,
              color: AppColors.danger,
              barWidth: 3,
              dotData: const FlDotData(show: true),
              belowBarData: BarAreaData(
                show: true,
                color: AppColors.danger.withOpacity(0.1),
              ),
            ),
          ],
          minY: 0,
          maxY: maxVal > 0 ? maxVal * 1.3 : 100,
        ),
      ),
    );
  }
}

class _InsightCard extends StatelessWidget {
  const _InsightCard({required this.insight});

  final SmartInsight insight;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: insight.color.withOpacity(isDark ? 0.08 : 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: insight.color.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: insight.color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(insight.icon, color: insight.color, size: 20),
          ),
          const Gap(12),
          Expanded(
            child: Text(
              insight.text,
              style: AppTextStyles.bodyMedium.copyWith(
                color:
                    isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TopTransactionItem extends StatelessWidget {
  const _TopTransactionItem({required this.transaction});

  final Transaction transaction;

  @override
  Widget build(BuildContext context) {
    final category = Category.fromId(transaction.categoryId);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.white10 : AppColors.border.withOpacity(0.5),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: category.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(category.icon, color: category.color, size: 18),
          ),
          const Gap(12),
          Expanded(
            child: Text(
              transaction.title,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            '-${CurrencyFormatter.display(transaction.amount)}',
            style: AppTextStyles.amountSmall.copyWith(
              color: AppColors.danger,
            ),
          ),
        ],
      ),
    );
  }
}
