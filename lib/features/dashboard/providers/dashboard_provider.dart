// ─── lib/features/dashboard/providers/dashboard_provider.dart ───
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/transaction.dart';
import '../../transactions/providers/transactions_provider.dart';
import '../../goals/providers/goals_provider.dart';
import '../../../core/providers/settings_provider.dart';

final dashboardDataProvider = Provider<DashboardData>((ref) {
  final transactions = ref.watch(transactionsProvider);
  final goals = ref.watch(goalsProvider);
  final settings = ref.watch(settingsProvider);

  final now = DateTime.now();
  final startOfMonth = DateTime(now.year, now.month, 1);

  final monthTransactions =
      transactions.where((t) => t.date.isAfter(startOfMonth)).toList();

  final monthIncome = monthTransactions
      .where((t) => t.type == TransactionType.income)
      .fold(0.0, (sum, t) => sum + t.amount);

  final monthExpenses = monthTransactions
      .where((t) => t.type == TransactionType.expense)
      .fold(0.0, (sum, t) => sum + t.amount);

  // Use balance from settings which is properly managed
  final totalBalance = settings.balance;

  final savingsRate = monthIncome > 0
      ? ((monthIncome - monthExpenses) / monthIncome * 100).clamp(0.0, 100.0)
      : 0.0;

  // Top spending category this month
  final expenseByCategory = <String, double>{};
  for (final t in monthTransactions.where(
    (t) => t.type == TransactionType.expense,
  )) {
    expenseByCategory[t.categoryId] =
        (expenseByCategory[t.categoryId] ?? 0) + t.amount;
  }

  String? topCategoryId;
  double topCategoryAmount = 0;
  expenseByCategory.forEach((id, amount) {
    if (amount > topCategoryAmount) {
      topCategoryId = id;
      topCategoryAmount = amount;
    }
  });

  // Last 7 days spending
  final last7Days = <DailySpending>[];
  for (int i = 6; i >= 0; i--) {
    final day = DateTime(now.year, now.month, now.day - i);
    final nextDay = day.add(const Duration(days: 1));
    final dayExpense = transactions
        .where((t) =>
            t.type == TransactionType.expense &&
            t.date.isAfter(day) &&
            t.date.isBefore(nextDay))
        .fold(0.0, (sum, t) => sum + t.amount);
    last7Days.add(DailySpending(date: day, amount: dayExpense));
  }

  final recentTransactions = List<Transaction>.from(transactions)
    ..sort((a, b) => b.date.compareTo(a.date));

  return DashboardData(
    totalBalance: totalBalance,
    monthIncome: monthIncome,
    monthExpenses: monthExpenses,
    savingsRate: savingsRate,
    topCategoryId: topCategoryId,
    topCategoryAmount: topCategoryAmount,
    last7Days: last7Days,
    recentTransactions: recentTransactions.take(5).toList(),
    activeGoals: goals.where((g) => !g.isCompleted).take(3).toList(),
  );
});

class DashboardData {
  const DashboardData({
    required this.totalBalance,
    required this.monthIncome,
    required this.monthExpenses,
    required this.savingsRate,
    this.topCategoryId,
    required this.topCategoryAmount,
    required this.last7Days,
    required this.recentTransactions,
    required this.activeGoals,
  });

  final double totalBalance;
  final double monthIncome;
  final double monthExpenses;
  final double savingsRate;
  final String? topCategoryId;
  final double topCategoryAmount;
  final List<DailySpending> last7Days;
  final List<Transaction> recentTransactions;
  final List<dynamic> activeGoals;
}

class DailySpending {
  const DailySpending({required this.date, required this.amount});

  final DateTime date;
  final double amount;
}
