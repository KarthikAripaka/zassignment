// ─── lib/data/services/seed_data_service.dart ───
import 'package:hive_flutter/hive_flutter.dart';
import '../models/transaction.dart';
import '../models/goal.dart';

class SeedDataService {
  static Future<void> seedIfEmpty() async {
    final transactionBox = Hive.box<Transaction>('transactions');
    final goalsBox = Hive.box<Goal>('goals');

    if (transactionBox.isEmpty) {
      await _seedTransactions(transactionBox);
    }

    if (goalsBox.isEmpty) {
      await _seedGoals(goalsBox);
    }

    await transactionBox.close();
    await goalsBox.close();
  }

  static Future<void> _seedTransactions(Box<Transaction> box) async {
    final transactions = [
      Transaction(
        id: 'seed_1',
        amount: 5000,
        type: TransactionType.expense,
        categoryId: 'health',
        title: 'Salary',
        notes: 'Monthly salary',
        date: DateTime.now().subtract(const Duration(days: 2)),
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      Transaction(
        id: 'seed_2',
        amount: 1500,
        type: TransactionType.expense,
        categoryId: 'food',
        title: 'Grocery Shopping',
        notes: 'Weekly groceries',
        date: DateTime.now().subtract(const Duration(days: 1)),
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      Transaction(
        id: 'seed_3',
        amount: 800,
        type: TransactionType.expense,
        categoryId: 'transport',
        title: 'Fuel',
        notes: 'Petrol',
        date: DateTime.now(),
        createdAt: DateTime.now(),
      ),
      Transaction(
        id: 'seed_4',
        amount: 2500,
        type: TransactionType.expense,
        categoryId: 'food',
        title: 'Rent Payment',
        notes: 'Monthly rent',
        date: DateTime.now().subtract(const Duration(days: 3)),
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
      ),
      Transaction(
        id: 'seed_5',
        amount: 300,
        type: TransactionType.expense,
        categoryId: 'entertainment',
        title: 'Movie',
        notes: 'Weekend movie',
        date: DateTime.now().subtract(const Duration(days: 4)),
        createdAt: DateTime.now().subtract(const Duration(days: 4)),
      ),
    ];

    for (final t in transactions) {
      await box.add(t);
    }
  }

  static Future<void> _seedGoals(Box<Goal> box) async {
    final now = DateTime.now();

    final goals = [
      Goal(
        id: 'seed_goal_1',
        title: 'Emergency Fund',
        targetAmount: 50000,
        currentAmount: 15000,
        type: GoalType.savings,
        deadline: now.add(const Duration(days: 90)),
        createdAt: now.subtract(const Duration(days: 30)),
        contributionStreak: 5,
        lastContribution: now.subtract(const Duration(days: 1)),
      ),
      Goal(
        id: 'seed_goal_2',
        title: 'New Phone',
        targetAmount: 25000,
        currentAmount: 8000,
        type: GoalType.savings,
        deadline: now.add(const Duration(days: 60)),
        createdAt: now.subtract(const Duration(days: 20)),
        contributionStreak: 3,
        lastContribution: now.subtract(const Duration(days: 2)),
      ),
      Goal(
        id: 'seed_goal_3',
        title: 'Vacation Trip',
        targetAmount: 100000,
        currentAmount: 0,
        type: GoalType.savings,
        deadline: now.add(const Duration(days: 180)),
        createdAt: now.subtract(const Duration(days: 10)),
        contributionStreak: 0,
        lastContribution: null,
      ),
    ];

    for (final g in goals) {
      await box.add(g);
    }
  }
}
