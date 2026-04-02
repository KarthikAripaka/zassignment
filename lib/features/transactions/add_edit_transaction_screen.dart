// ─── lib/features/transactions/add_edit_transaction_screen.dart ───
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/providers/settings_provider.dart';
import '../../data/models/transaction.dart';
import '../../data/models/category.dart';
import 'providers/transactions_provider.dart';

class AddEditTransactionScreen extends ConsumerStatefulWidget {
  const AddEditTransactionScreen({super.key, this.transaction});

  final Transaction? transaction;

  @override
  ConsumerState<AddEditTransactionScreen> createState() =>
      _AddEditTransactionScreenState();
}

class _AddEditTransactionScreenState
    extends ConsumerState<AddEditTransactionScreen> {
  late final TextEditingController _amountController;
  late final TextEditingController _titleController;
  late final TextEditingController _notesController;
  TransactionType _type = TransactionType.expense;
  Category _selectedCategory = Category.food;
  DateTime _selectedDate = DateTime.now();
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.transaction != null;
    _amountController = TextEditingController(
      text: _isEditing ? widget.transaction!.amount.toStringAsFixed(0) : '',
    );
    _titleController = TextEditingController(
      text: _isEditing ? widget.transaction!.title : '',
    );
    _notesController = TextEditingController(
      text: _isEditing ? widget.transaction!.notes ?? '' : '',
    );
    if (_isEditing) {
      _type = widget.transaction!.type;
      _selectedCategory = Category.fromId(widget.transaction!.categoryId);
      _selectedDate = widget.transaction!.date;
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _titleController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Transaction' : 'Add Transaction'),
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
            // Amount input
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: _type == TransactionType.income
                    ? AppColors.success.withOpacity(0.08)
                    : AppColors.danger.withOpacity(0.08),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Text(
                    _type == TransactionType.income ? 'Income' : 'Expense',
                    style: AppTextStyles.bodyMedium,
                  ),
                  const Gap(8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          '₹',
                          style: AppTextStyles.displayMedium.copyWith(
                            color: _type == TransactionType.income
                                ? AppColors.success
                                : AppColors.danger,
                          ),
                        ),
                      ),
                      const Gap(4),
                      SizedBox(
                        width: 160,
                        child: TextField(
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          style: AppTextStyles.displayMedium.copyWith(
                            color: _type == TransactionType.income
                                ? AppColors.success
                                : AppColors.danger,
                          ),
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: '0',
                            hintStyle: AppTextStyles.displayMedium.copyWith(
                              color: (isDark
                                      ? AppColors.darkTextSecondary
                                      : AppColors.textSecondary)
                                  .withOpacity(0.4),
                            ),
                          ),
                          autofocus: !_isEditing,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Gap(24),

            // Type toggle
            Row(
              children: [
                Expanded(
                  child: _TypeButton(
                    label: 'Expense',
                    icon: Icons.arrow_upward,
                    isSelected: _type == TransactionType.expense,
                    color: AppColors.danger,
                    onTap: () =>
                        setState(() => _type = TransactionType.expense),
                  ),
                ),
                const Gap(12),
                Expanded(
                  child: _TypeButton(
                    label: 'Income',
                    icon: Icons.arrow_downward,
                    isSelected: _type == TransactionType.income,
                    color: AppColors.success,
                    onTap: () => setState(() => _type = TransactionType.income),
                  ),
                ),
              ],
            ),
            const Gap(24),

            // Category selector
            const Text('Category', style: AppTextStyles.headlineSmall),
            const Gap(12),
            SizedBox(
              height: 90,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: Category.values.length,
                separatorBuilder: (_, __) => const Gap(8),
                itemBuilder: (context, index) {
                  final cat = Category.values[index];
                  final isSelected = cat == _selectedCategory;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedCategory = cat;
                        if (_titleController.text.isEmpty ||
                            _titleController.text == _selectedCategory.label) {
                          _titleController.text = cat.label;
                        }
                      });
                    },
                    child: SizedBox(
                      width: 72,
                      child: Column(
                        children: [
                          Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? cat.color.withOpacity(0.2)
                                  : (isDark
                                      ? AppColors.darkSurface
                                      : AppColors.surface),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: isSelected
                                    ? cat.color
                                    : AppColors.border.withOpacity(0.5),
                                width: isSelected ? 2 : 1,
                              ),
                            ),
                            child: Icon(
                              cat.icon,
                              color: isSelected
                                  ? cat.color
                                  : (isDark
                                      ? AppColors.darkTextSecondary
                                      : AppColors.textSecondary),
                              size: 24,
                            ),
                          ),
                          const Gap(6),
                          Text(
                            cat.label,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: isSelected ? cat.color : null,
                              fontWeight: isSelected ? FontWeight.w600 : null,
                              fontSize: 10,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const Gap(24),

            // Title
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                prefixIcon: Icon(Icons.edit, size: 20),
              ),
            ),
            const Gap(16),

            // Date picker
            GestureDetector(
              onTap: _pickDate,
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
                      '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                      style: AppTextStyles.bodyLarge,
                    ),
                    const Spacer(),
                    Icon(
                      Icons.chevron_right,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.textSecondary,
                    ),
                  ],
                ),
              ),
            ),
            const Gap(16),

            // Notes
            TextField(
              controller: _notesController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Notes (optional)',
                prefixIcon: Icon(Icons.notes, size: 20),
                alignLabelWithHint: true,
              ),
            ),
            const Gap(32),

            // Save button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveTransaction,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  _isEditing ? 'Update Transaction' : 'Save Transaction',
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

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  void _saveTransaction() {
    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid amount')),
      );
      return;
    }

    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a title')),
      );
      return;
    }

    // Check balance for expense transactions
    if (_type == TransactionType.expense) {
      final settings = ref.read(settingsProvider);
      double availableBalance = settings.balance;
      if (_isEditing && widget.transaction!.type == TransactionType.expense) {
        availableBalance += widget.transaction!.amount;
      }
      if (amount > availableBalance) {
        showDialog<void>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Insufficient Balance'),
            content: Text(
              'You need \u20B9${amount.toStringAsFixed(0)} but your current balance is \u20B9${availableBalance.toStringAsFixed(0)}. Please add income first.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('OK'),
              ),
            ],
          ),
        );
        return;
      }
    }

    final notifier = ref.read(transactionsProvider.notifier);

    if (_isEditing) {
      final updated = widget.transaction!.copyWith(
        amount: amount,
        type: _type,
        categoryId: _selectedCategory.name,
        title: _titleController.text.trim(),
        notes: _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
        date: _selectedDate,
      );
      notifier.update(widget.transaction!, updated);
    } else {
      notifier.add(
        amount: amount,
        type: _type,
        categoryId: _selectedCategory.name,
        title: _titleController.text.trim(),
        notes: _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
        date: _selectedDate,
      );
    }

    HapticFeedback.lightImpact();

    // Show success dialog and clear form
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: AppColors.success, size: 28),
            const SizedBox(width: 12),
            Text(
              _isEditing ? 'Transaction updated!' : 'Transaction added!',
              style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );

    // Auto close dialog after 1.5 seconds and clear form
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        Navigator.of(context).pop(); // Close dialog
        // Clear form for next entry
        _amountController.clear();
        _titleController.clear();
        _notesController.clear();
        setState(() {
          _type = TransactionType.expense;
          _selectedCategory = Category.food;
          _selectedDate = DateTime.now();
        });
      }
    });
  }
}

class _TypeButton extends StatelessWidget {
  const _TypeButton({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.color,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withOpacity(0.1)
              : (isDark ? AppColors.darkSurface : AppColors.surface),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : AppColors.border.withOpacity(0.5),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected
                  ? color
                  : (isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.textSecondary),
            ),
            const Gap(8),
            Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(
                color: isSelected
                    ? color
                    : (isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.textPrimary),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
