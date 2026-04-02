// ─── lib/features/goals/providers/goals_provider.dart ───
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../../../data/models/goal.dart';
import '../../../data/adapters/goal_adapter.dart';

final goalsBoxProvider = FutureProvider<Box<Goal>>((ref) async {
  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(ManualGoalAdapter());
  }
  return Hive.openBox<Goal>('goals');
});

final goalsProvider = StateNotifierProvider<GoalsNotifier, List<Goal>>((ref) {
  final box = ref.watch(goalsBoxProvider);
  return GoalsNotifier(box.value);
});

class GoalsNotifier extends StateNotifier<List<Goal>> {
  GoalsNotifier(this._box) : super([]) {
    _load();
  }

  final Box<Goal>? _box;
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
    return goal;
  }

  Future<void> update(Goal goal) async {
    if (_box == null) return;
    final index = _box.values.toList().indexWhere((g) => g.id == goal.id);
    if (index != -1) {
      await _box.putAt(index, goal);
      _load();
    }
  }

  Future<void> delete(String id) async {
    if (_box == null) return;
    final index = _box.values.toList().indexWhere((g) => g.id == id);
    if (index != -1) {
      await _box.deleteAt(index);
      _load();
    }
  }

  Future<void> addMoney(String goalId, double amount) async {
    final goal = state.firstWhere((g) => g.id == goalId);
    final updated = goal.copyWith(
      currentAmount: goal.currentAmount + amount,
      isCompleted: goal.currentAmount + amount >= goal.targetAmount,
    );
    await update(updated);
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
