// ─── lib/features/goals/goals_screen.dart ───
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/loading_shimmer.dart';
import '../../data/models/goal.dart';
import 'providers/goals_provider.dart';
import 'widgets/goal_card.dart';
import 'add_edit_goal_screen.dart';

class GoalsScreen extends ConsumerWidget {
  const GoalsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goalsBox = ref.watch(goalsBoxProvider);
    final goals = ref.watch(goalsProvider);

    return goalsBox.when(
      loading: () => const Scaffold(body: DashboardShimmer()),
      error: (e, _) => Scaffold(body: Center(child: Text('Error: $e'))),
      data: (_) {
        final activeGoals = goals.where((g) => !g.isCompleted).toList();
        final completedGoals = goals.where((g) => g.isCompleted).toList();

        return Scaffold(
          body: SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Goals & Challenges',
                          style: AppTextStyles.headlineLarge,
                        ),
                        IconButton(
                          onPressed: () => _openAddGoal(context),
                          icon: const Icon(Icons.add_circle_outline),
                          tooltip: 'Add goal',
                        ),
                      ],
                    ),
                  ),
                ),
                if (goals.isEmpty)
                  SliverFillRemaining(
                    child: EmptyState(
                      icon: Icons.flag_outlined,
                      title: 'Set your first goal',
                      subtitle:
                          'Create savings goals or take on spending challenges to build better habits',
                      actionLabel: 'Create Goal',
                      onAction: () => _openAddGoal(context),
                    ),
                  )
                else ...[
                  if (activeGoals.isNotEmpty) ...[
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(20, 24, 20, 12),
                        child: Text(
                          'Active',
                          style: AppTextStyles.headlineSmall,
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final goal = activeGoals[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: GoalCard(
                                goal: goal,
                                onAddMoney: () =>
                                    _showAddMoneyDialog(context, ref, goal),
                                onComplete: () => _completeGoal(ref, goal),
                                onCheckIn: () => _checkInStreak(ref, goal),
                              ).animate().fadeIn(
                                    delay: Duration(milliseconds: 100 * index),
                                    duration: 400.ms,
                                  ),
                            );
                          },
                          childCount: activeGoals.length,
                        ),
                      ),
                    ),
                  ],
                  if (completedGoals.isNotEmpty) ...[
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
                        child: Text(
                          'Completed',
                          style: AppTextStyles.headlineSmall.copyWith(
                            color: AppColors.success,
                          ),
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final goal = completedGoals[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: GoalCard(
                                goal: goal,
                                isCompleted: true,
                              ),
                            );
                          },
                          childCount: completedGoals.length,
                        ),
                      ),
                    ),
                  ],
                ],
                const SliverToBoxAdapter(child: Gap(100)),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _openAddGoal(context),
            backgroundColor: AppColors.accent,
            foregroundColor: Colors.white,
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  void _openAddGoal(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const AddEditGoalScreen()),
    );
  }

  void _showAddMoneyDialog(BuildContext context, WidgetRef ref, Goal goal) {
    final controller = TextEditingController();
    final goalsContext = context;

    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Add money to ${goal.title}'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: const InputDecoration(
            labelText: 'Amount',
            prefixText: '₹ ',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final amount = double.tryParse(controller.text);
              if (amount != null && amount > 0) {
                final messenger = ScaffoldMessenger.of(goalsContext);
                final success = await ref.read(goalsProvider.notifier).addMoney(goal.id, amount);
                if (dialogContext.mounted) {
                  Navigator.of(dialogContext).pop();
                }
                if (!success) {
                  messenger.showSnackBar(
                    const SnackBar(
                      content: Text('Insufficient balance. Please add income first.'),
                      backgroundColor: AppColors.danger,
                    ),
                  );
                } else {
                  HapticFeedback.mediumImpact();
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _completeGoal(WidgetRef ref, Goal goal) {
    ref.read(goalsProvider.notifier).completeGoal(goal.id);
    HapticFeedback.mediumImpact();
  }

  void _checkInStreak(WidgetRef ref, Goal goal) {
    ref.read(goalsProvider.notifier).checkInStreak(goal.id);
    HapticFeedback.lightImpact();
  }
}
