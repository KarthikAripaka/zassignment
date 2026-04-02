// ─── lib/features/goals/add_edit_goal_screen.dart ───
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/goal.dart';
import 'providers/goals_provider.dart';

class AddEditGoalScreen extends ConsumerStatefulWidget {
  const AddEditGoalScreen({super.key});

  @override
  ConsumerState<AddEditGoalScreen> createState() => _AddEditGoalScreenState();
}

class _AddEditGoalScreenState extends ConsumerState<AddEditGoalScreen> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  GoalType _selectedType = GoalType.savings;
  DateTime? _deadline;

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Goal'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Goal type selector
            const Text('Goal Type', style: AppTextStyles.headlineSmall),
            const Gap(12),
            ...GoalType.values.map((type) {
              final isSelected = type == _selectedType;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: GestureDetector(
                  onTap: () => setState(() => _selectedType = type),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary.withOpacity(0.08)
                          : (isDark
                              ? AppColors.darkSurface
                              : AppColors.surface),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.border.withOpacity(0.5),
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          type.icon,
                          color: isSelected
                              ? AppColors.primary
                              : (isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.textSecondary),
                        ),
                        const Gap(12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                type.displayName,
                                style: AppTextStyles.bodyLarge.copyWith(
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                ),
                              ),
                              Text(
                                _getTypeDescription(type),
                                style: AppTextStyles.bodySmall,
                              ),
                            ],
                          ),
                        ),
                        if (isSelected)
                          const Icon(
                            Icons.check_circle,
                            color: AppColors.primary,
                          ),
                      ],
                    ),
                  ),
                ),
              );
            }),
            const Gap(24),

            // Title
            const Text('Goal Name', style: AppTextStyles.headlineSmall),
            const Gap(12),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: _getDefaultTitle(),
                prefixIcon: const Icon(Icons.edit, size: 20),
              ),
            ),
            const Gap(24),

            // Target amount
            Text(
              _selectedType == GoalType.budget
                  ? 'Weekly Budget Cap'
                  : 'Target Amount',
              style: AppTextStyles.headlineSmall,
            ),
            const Gap(12),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                prefixText: '₹ ',
                hintText: '0',
              ),
            ),
            const Gap(24),

            // Deadline (optional)
            const Text('Deadline (optional)',
                style: AppTextStyles.headlineSmall),
            const Gap(12),
            GestureDetector(
              onTap: _pickDeadline,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.border.withOpacity(0.5),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 20,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.textSecondary,
                    ),
                    const Gap(12),
                    Text(
                      _deadline != null
                          ? '${_deadline!.day}/${_deadline!.month}/${_deadline!.year}'
                          : 'No deadline set',
                      style: AppTextStyles.bodyLarge,
                    ),
                    const Spacer(),
                    if (_deadline != null)
                      GestureDetector(
                        onTap: () => setState(() => _deadline = null),
                        child: const Icon(Icons.close, size: 18),
                      ),
                  ],
                ),
              ),
            ),
            const Gap(32),

            // Create button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _createGoal,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  'Create Goal',
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getTypeDescription(GoalType type) {
    return switch (type) {
      GoalType.savings => 'Save towards a specific amount',
      GoalType.noSpend =>
        'Track consecutive days without non-essential spending',
      GoalType.budget => 'Set a weekly spending cap and track progress',
    };
  }

  String _getDefaultTitle() {
    return switch (_selectedType) {
      GoalType.savings => 'e.g., New laptop fund',
      GoalType.noSpend => 'e.g., No shopping challenge',
      GoalType.budget => 'e.g., Weekly food budget',
    };
  }

  Future<void> _pickDeadline() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _deadline ?? DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );
    if (picked != null) {
      setState(() => _deadline = picked);
    }
  }

  void _createGoal() {
    final title = _titleController.text.trim().isEmpty
        ? _getDefaultTitle().replaceFirst('e.g., ', '')
        : _titleController.text.trim();

    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid amount')),
      );
      return;
    }

    ref.read(goalsProvider.notifier).add(
          title: title,
          targetAmount: amount,
          deadline: _deadline,
          type: _selectedType,
        );

    HapticFeedback.lightImpact();
    Navigator.pop(context);
  }
}
