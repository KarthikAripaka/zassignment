// ─── lib/features/goals/providers/goals_provider.dart ───
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../../../data/models/goal.dart';
import '../../../data/models/audit_log.dart';
import '../../../data/adapters/goal_adapter.dart';
import '../../../core/providers/settings_provider.dart';
import '../../../data/services/database_service.dart';

final goalsBoxProvider = FutureProvider<Box<Goal>>((ref) async {
  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(ManualGoalAdapter());
  }
  return Hive.openBox<Goal>('goals');
});

final goalsProvider = StateNotifierProvider<GoalsNotifier, List<Goal>>((ref) {
  final box = ref.watch(goalsBoxProvider);
  final settingsNotifier = ref.watch(settingsProvider.notifier);
  return GoalsNotifier(box.value, settingsNotifier);
});

class GoalsNotifier extends StateNotifier<List<Goal>> {
  GoalsNotifier(this._box, this._settingsNotifier) : super([]) {
    _load();
  }

  final Box<Goal>? _box;
  final SettingsNotifier _settingsNotifier;
  static const _uuid = Uuid();

  void _load() {
    if (_box == null) return;
    state = _box.values.toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Future<Goal> add({
    required String title,
    required double targetAmount,
    DateTime? deadline,
    required GoalType type,
  }) async {
    if (_box == null) {
      throw StateError('Goals box not initialized');
    }
    final goal = Goal(
      id: _uuid.v4(),
      title: title,
      targetAmount: targetAmount,
      type: type,
      deadline: deadline,
      createdAt: DateTime.now(),
    );
    await _box.add(goal);
    _load();

    await DatabaseService().logAudit(
      action: AuditAction.create,
      entityType: 'goal',
      entityId: goal.id,
      amount: targetAmount,
      description: 'Goal created: $title',
      newData: {
        'title': title,
        'targetAmount': targetAmount,
        'type': type.name,
      },
    );

    return goal;
  }

  Future<void> update(Goal goal) async {
    if (_box == null) return;
    final index = _box.values.toList().indexWhere((g) => g.id == goal.id);
    if (index != -1) {
      final oldGoal = _box.values.toList()[index];
      await _box.putAt(index, goal);
      _load();

      await DatabaseService().logAudit(
        action: AuditAction.update,
        entityType: 'goal',
        entityId: goal.id,
        amount: goal.currentAmount,
        description: 'Goal updated: ${goal.title}',
        previousData: {
          'title': oldGoal.title,
          'currentAmount': oldGoal.currentAmount,
        },
        newData: {
          'title': goal.title,
          'currentAmount': goal.currentAmount,
        },
      );
    }
  }

  Future<void> delete(String id) async {
    if (_box == null) return;
    final index = _box.values.toList().indexWhere((g) => g.id == id);
    if (index != -1) {
      final goal = _box.values.toList()[index];
      await _box.deleteAt(index);
      _load();

      await DatabaseService().logAudit(
        action: AuditAction.delete,
        entityType: 'goal',
        entityId: id,
        description: 'Goal deleted: ${goal.title}',
        previousData: {
          'title': goal.title,
          'targetAmount': goal.targetAmount,
        },
      );
    }
  }

  Future<bool> addMoney(String goalId, double amount) async {
    final goal = state.firstWhere((g) => g.id == goalId);
    
    // Check if sufficient balance
    if (_settingsNotifier.state.balance < amount) {
      return false;
    }

    // Deduct from balance
    await _settingsNotifier.subtractFromBalance(amount);

    // Update goal
    final updated = goal.copyWith(
      currentAmount: goal.currentAmount + amount,
      isCompleted: goal.currentAmount + amount >= goal.targetAmount,
    );

    final oldAmount = goal.currentAmount;
    await update(updated);

    await DatabaseService().logAudit(
      action: AuditAction.update,
      entityType: 'goal',
      entityId: goalId,
      amount: amount,
      description: 'Added money to goal: ${goal.title}',
      previousData: {
        'currentAmount': oldAmount,
      },
      newData: {
        'currentAmount': updated.currentAmount,
      },
    );

    return true;
  }

  Future<void> checkInStreak(String goalId) async {
    final goal = state.firstWhere((g) => g.id == goalId);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final lastCheck = goal.lastCheckIn != null
        ? DateTime(
            goal.lastCheckIn!.year,
            goal.lastCheckIn!.month,
            goal.lastCheckIn!.day,
          )
        : null;

    if (lastCheck == today) return;

    final isConsecutive =
        lastCheck == null || today.difference(lastCheck).inDays == 1;

    final updated = goal.copyWith(
      streakDays: isConsecutive ? goal.streakDays + 1 : 1,
      lastCheckIn: now,
    );
    await update(updated);
  }

  Future<void> completeGoal(String goalId) async {
    final goal = state.firstWhere((g) => g.id == goalId);
    await update(goal.copyWith(isCompleted: true));
  }

  List<Goal> get activeGoals => state.where((g) => !g.isCompleted).toList();

  List<Goal> get completedGoals => state.where((g) => g.isCompleted).toList();

  Future<void> clearAll() async {
    if (_box == null) return;
    await _box.clear();
    _load();
  }
}
