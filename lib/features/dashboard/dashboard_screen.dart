// ─── lib/features/dashboard/dashboard_screen.dart ───
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/loading_shimmer.dart';
import '../../core/providers/settings_provider.dart';
import '../transactions/providers/transactions_provider.dart';
import '../transactions/add_edit_transaction_screen.dart';
import 'providers/dashboard_provider.dart';
import 'widgets/balance_card.dart';
import 'widgets/spending_chart.dart';
import 'widgets/recent_transactions_list.dart';
import 'widgets/goals_preview.dart';
import 'widgets/smart_insight.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final transactionsBox = ref.watch(transactionsBoxProvider);
    final dashboardData = ref.watch(dashboardDataProvider);

    return transactionsBox.when(
      loading: () => const Scaffold(body: DashboardShimmer()),
      error: (e, _) => Scaffold(
        body: Center(child: Text('Error: $e')),
      ),
      data: (_) {
        final hour = DateTime.now().hour;
        final greeting = hour < 12
            ? 'Good morning'
            : hour < 17
                ? 'Good afternoon'
                : 'Good evening';

        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Gap(16),

                  // Header: Greeting + Theme Toggle
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '$greeting,',
                              style: AppTextStyles.bodyMedium,
                            ),
                            const Gap(2),
                            Text(
                              settings.userName,
                              style: AppTextStyles.headlineLarge,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => _showThemeDialog(context, ref),
                        icon: Icon(
                          Theme.of(context).brightness == Brightness.dark
                              ? Icons.light_mode
                              : Icons.dark_mode,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        tooltip: 'Toggle theme',
                      ),
                    ],
                  ).animate().fadeIn(duration: 400.ms),

                  const Gap(20),

                  // Total Balance + Income/Expense Card
                  BalanceCard(
                    totalBalance: dashboardData.totalBalance,
                    monthIncome: dashboardData.monthIncome,
                    monthExpenses: dashboardData.monthExpenses,
                  )
                      .animate()
                      .fadeIn(delay: 100.ms, duration: 400.ms)
                      .slideY(begin: 0.1),

                  const Gap(16),

                  // Smart Insight
                  if (dashboardData.monthIncome > 0 ||
                      dashboardData.recentTransactions.isNotEmpty)
                    SmartInsight(data: dashboardData)
                        .animate()
                        .fadeIn(delay: 150.ms, duration: 400.ms),

                  const Gap(20),

                  // Weekly Spending Chart
                  if (dashboardData.last7Days.any((d) => d.amount > 0)) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'This Week',
                          style: AppTextStyles.headlineSmall,
                        ),
                        Text(
                          '${CurrencyFormatter.compact(dashboardData.last7Days.fold(0.0, (sum, d) => sum + d.amount))} spent',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.danger,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const Gap(12),
                    SpendingChart(dailySpending: dashboardData.last7Days)
                        .animate()
                        .fadeIn(delay: 200.ms, duration: 400.ms),
                    const Gap(20),
                  ],

                  // Summary Chips (Savings Rate + Top Category)
                  _buildSummaryChips(context, dashboardData),

                  // Recent Transactions
                  RecentTransactionsList(
                    transactions: dashboardData.recentTransactions,
                  ).animate().fadeIn(delay: 300.ms, duration: 400.ms),

                  const Gap(20),

                  // Active Goals Preview
                  if (dashboardData.activeGoals.isNotEmpty) ...[
                    const Text(
                      'Active Goals',
                      style: AppTextStyles.headlineSmall,
                    ),
                    const Gap(12),
                    GoalsPreview(goals: dashboardData.activeGoals)
                        .animate()
                        .fadeIn(delay: 400.ms, duration: 400.ms),
                    const Gap(24),
                  ],

                  // Empty State
                  if (dashboardData.recentTransactions.isEmpty)
                    EmptyState(
                      icon: Icons.account_balance_wallet_outlined,
                      title: 'Start tracking',
                      subtitle:
                          'Add your first transaction to see your financial overview',
                      actionLabel: 'Add Transaction',
                      onAction: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const AddEditTransactionScreen(),
                          ),
                        );
                      },
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

  Widget _buildSummaryChips(BuildContext context, DashboardData data) {
    if (data.monthIncome <= 0) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          // Savings Rate Chip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: data.savingsRate >= 20
                  ? AppColors.success.withOpacity(0.1)
                  : AppColors.accent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  data.savingsRate >= 20 ? Icons.savings : Icons.trending_down,
                  size: 16,
                  color: data.savingsRate >= 20
                      ? AppColors.success
                      : AppColors.accent,
                ),
                const Gap(6),
                Text(
                  '${data.savingsRate.toStringAsFixed(0)}% saved',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: data.savingsRate >= 20
                        ? AppColors.success
                        : AppColors.accent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          // Top Category Chip
          if (data.topCategoryId != null) ...[
            const Gap(12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.category,
                      size: 16, color: AppColors.primary),
                  const Gap(6),
                  Text(
                    '${data.topCategoryId![0].toUpperCase()}${data.topCategoryId!.substring(1)}: ${CurrencyFormatter.compact(data.topCategoryAmount)}',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    ).animate().fadeIn(delay: 250.ms, duration: 300.ms);
  }

  void _showThemeDialog(BuildContext context, WidgetRef ref) {
    final currentMode = ref.read(settingsProvider).themeMode;

    showDialog<void>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text('Theme'),
        children: [
          _ThemeOption(
            icon: Icons.brightness_auto,
            label: 'System',
            isSelected: currentMode == ThemeMode.system,
            onTap: () {
              ref
                  .read(settingsProvider.notifier)
                  .setThemeMode(ThemeMode.system);
              Navigator.pop(ctx);
            },
          ),
          _ThemeOption(
            icon: Icons.light_mode,
            label: 'Light',
            isSelected: currentMode == ThemeMode.light,
            onTap: () {
              ref.read(settingsProvider.notifier).setThemeMode(ThemeMode.light);
              Navigator.pop(ctx);
            },
          ),
          _ThemeOption(
            icon: Icons.dark_mode,
            label: 'Dark',
            isSelected: currentMode == ThemeMode.dark,
            onTap: () {
              ref.read(settingsProvider.notifier).setThemeMode(ThemeMode.dark);
              Navigator.pop(ctx);
            },
          ),
        ],
      ),
    );
  }
}

class _ThemeOption extends StatelessWidget {
  const _ThemeOption({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SimpleDialogOption(
      onPressed: onTap,
      child: Row(
        children: [
          Icon(
            icon,
            color: isSelected ? Theme.of(context).colorScheme.primary : null,
          ),
          const Gap(12),
          Text(
            label,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              color: isSelected ? Theme.of(context).colorScheme.primary : null,
            ),
          ),
          const Spacer(),
          if (isSelected)
            Icon(
              Icons.check,
              color: Theme.of(context).colorScheme.primary,
              size: 20,
            ),
        ],
      ),
    );
  }
}
