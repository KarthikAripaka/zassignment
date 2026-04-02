// ─── lib/data/models/goal.dart ───
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'goal.freezed.dart';
part 'goal.g.dart';

@freezed
@HiveType(typeId: 1)
class Goal with _$Goal {
  const Goal._();

  factory Goal({
    @HiveField(0) required String id,
    @HiveField(1) required String title,
    @HiveField(2) required double targetAmount,
    @HiveField(3) @Default(0.0) double currentAmount,
    @HiveField(4) DateTime? deadline,
    @HiveField(5) required GoalType type,
    @HiveField(6) @Default(0) int streakDays,
    @HiveField(7) DateTime? lastCheckIn,
    @HiveField(8) @Default(false) bool isCompleted,
    @HiveField(9) required DateTime createdAt,
    @HiveField(10) @Default(0) int contributionStreak,
    @HiveField(11) DateTime? lastContribution,
  }) = _Goal;

  factory Goal.fromJson(Map<String, dynamic> json) => _$GoalFromJson(json);

  double get progress => targetAmount > 0 ? currentAmount / targetAmount : 0.0;

  bool get isActive => !isCompleted && (deadline == null || deadline!.isAfter(DateTime.now()));

  String get progressText => '${(progress * 100).toStringAsFixed(0)}%';

  bool get contributedToday {
    if (lastContribution == null) return false;
    final now = DateTime.now();
    return lastContribution!.year == now.year && 
           lastContribution!.month == now.month && 
           lastContribution!.day == now.day;
  }

  @override
  String toString() => 'Goal(title: $title, progress: $progress)';
}

enum GoalType {
  @JsonValue('savings')
  savings,
  @JsonValue('no_spend')
  noSpend,
  @JsonValue('budget')
  budget,
}

extension GoalTypeX on GoalType {
  String get displayName => switch (this) {
    GoalType.savings => 'Savings Goal',
    GoalType.noSpend => 'No-Spend Challenge',
    GoalType.budget => 'Budget Challenge',
  };

  IconData get icon => switch (this) {
    GoalType.savings => Icons.savings,
    GoalType.noSpend => Icons.local_fire_department,
    GoalType.budget => Icons.account_balance_wallet,
  };
}

