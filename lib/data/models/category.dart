// ─── lib/data/models/category.dart ───
import 'package:finia/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

enum Category {
  food('Food', Icons.restaurant, AppColors.food),
  transport('Transport', Icons.directions_car, AppColors.transport),
  shopping('Shopping', Icons.shopping_bag, AppColors.shopping),
  entertainment('Entertainment', Icons.movie, AppColors.entertainment),
  health('Health', Icons.favorite, AppColors.health),
  housing('Housing', Icons.home, AppColors.housing),
  utilities('Utilities', Icons.electrical_services, AppColors.utilities),
  education('Education', Icons.school, AppColors.education),
  travel('Travel', Icons.flight, AppColors.travel),
  income('Income', Icons.account_balance_wallet, AppColors.income),
  salary('Salary', Icons.work, AppColors.income),
  rent('Rent', Icons.house, AppColors.housing),
  other('Other', Icons.category, AppColors.other);

  const Category(this.label, this.icon, this.color);

  final String label;
  final IconData icon;
  final Color color;

  /// Expense categories (exclude income)
  static List<Category> get expenses => [
        food,
        transport,
        shopping,
        entertainment,
        health,
        housing,
        utilities,
        education,
        travel,
        other,
      ];

  /// Whether this is an expense category
  bool get isExpense => this != income;

  static Category fromId(String id) => values.byName(id);
}
