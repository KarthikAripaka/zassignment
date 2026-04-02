// ─── lib/features/transactions/transactions_screen.dart ───
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/date_utils.dart' as app_dates;
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/error_state.dart';
import '../../core/widgets/loading_shimmer.dart';
import '../../data/models/transaction.dart';
import 'providers/transactions_provider.dart';
import 'widgets/transaction_list_item.dart';
import 'add_edit_transaction_screen.dart';

class TransactionsScreen extends ConsumerStatefulWidget {
  const TransactionsScreen({super.key});

  @override
  ConsumerState<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends ConsumerState<TransactionsScreen> {
  final _searchController = TextEditingController();
  bool _showSearch = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final transactionsBox = ref.watch(transactionsBoxProvider);
    final filteredTransactions = ref.watch(filteredTransactionsProvider);

    return transactionsBox.when(
      loading: () => const Scaffold(body: DashboardShimmer()),
      error: (e, _) => Scaffold(
        body: Center(child: Text('Error: $e')),
      ),
      data: (_) {
        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Transactions',
                            style: AppTextStyles.headlineLarge,
                          ),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    _showSearch = !_showSearch;
                                    if (!_showSearch) {
                                      _searchController.clear();
                                      ref
                                          .read(
                                            transactionFilterProvider.notifier,
                                          )
                                          .state = ref
                                          .read(
                                            transactionFilterProvider,
                                          )
                                          .copyWith(
                                            searchQuery: '',
                                          );
                                    }
                                  });
                                },
                                icon: Icon(
                                  _showSearch ? Icons.close : Icons.search,
                                ),
                                tooltip: 'Search transactions',
                              ),
                            ],
                          ),
                        ],
                      ),
                      if (_showSearch) ...[
                        const Gap(12),
                        TextField(
                          controller: _searchController,
                          autofocus: true,
                          decoration: const InputDecoration(
                            hintText: 'Search transactions...',
                            prefixIcon: Icon(Icons.search, size: 20),
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                          onChanged: (value) {
                            ref.read(transactionFilterProvider.notifier).state =
                                ref
                                    .read(transactionFilterProvider)
                                    .copyWith(searchQuery: value);
                          },
                        ).animate().slideY(begin: -0.5, duration: 200.ms),
                      ],
                      const Gap(12),
                      _FilterChipsRow(),
                    ],
                  ),
                ),
                Expanded(
                  child: filteredTransactions.when(
                    loading: () => const LoadingShimmer(
                      itemCount: 5,
                      height: 72,
                      borderRadius: 12,
                    ),
                    error: (e, _) => ErrorState(message: e.toString()),
                    data: (transactions) {
                      if (transactions.isEmpty) {
                        return EmptyState(
                          icon: Icons.receipt_long_outlined,
                          title: 'No transactions',
                          subtitle: ref.read(transactionFilterProvider).isEmpty
                              ? 'Start tracking your finances by adding your first transaction'
                              : 'No transactions match your current filters',
                          actionLabel:
                              ref.read(transactionFilterProvider).isEmpty
                                  ? 'Add Transaction'
                                  : null,
                          onAction: ref.read(transactionFilterProvider).isEmpty
                              ? () => _openAddTransaction(context)
                              : null,
                        );
                      }

                      // Group by date
                      final grouped = <String, List<Transaction>>{};
                      for (final t in transactions) {
                        final key = app_dates.AppDateUtils.relativeDate(t.date);
                        grouped.putIfAbsent(key, () => []).add(t);
                      }

                      final entries = grouped.entries.toList();
                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                        itemCount: entries.length,
                        itemBuilder: (context, index) {
                          final entry = entries[index];
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                                child: Text(
                                  entry.key,
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              ...entry.value.map(
                                (t) => TransactionListItem(
                                  transaction: t,
                                  onDelete: () => _deleteTransaction(t),
                                  onTap: () => _editTransaction(context, t),
                                ).animate().fadeIn(
                                      delay: Duration(
                                        milliseconds: 50 * index,
                                      ),
                                      duration: 300.ms,
                                    ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _openAddTransaction(context),
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  void _openAddTransaction(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const AddEditTransactionScreen()),
    );
  }

  void _editTransaction(BuildContext context, Transaction transaction) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => AddEditTransactionScreen(transaction: transaction),
      ),
    );
  }

  void _deleteTransaction(Transaction transaction) {
    ref.read(transactionsProvider.notifier).delete(transaction.id);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${transaction.title} deleted'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            ref.read(transactionsProvider.notifier).add(
                  amount: transaction.amount,
                  type: transaction.type,
                  categoryId: transaction.categoryId,
                  title: transaction.title,
                  notes: transaction.notes,
                  date: transaction.date,
                );
          },
        ),
      ),
    );
  }
}

class _FilterChipsRow extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(transactionFilterProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      height: 36,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _FilterChip(
            label: 'All',
            isSelected: filter.isEmpty,
            onTap: () => ref.read(transactionFilterProvider.notifier).state =
                const TransactionFilter(),
          ),
          const Gap(8),
          _FilterChip(
            label: 'Income',
            isSelected: filter.type == TransactionType.income,
            onTap: () {
              final notifier = ref.read(transactionFilterProvider.notifier);
              if (filter.type == TransactionType.income) {
                notifier.state = filter.copyWith(type: () => null);
              } else {
                notifier.state =
                    filter.copyWith(type: () => TransactionType.income);
              }
            },
          ),
          const Gap(8),
          _FilterChip(
            label: 'Expenses',
            isSelected: filter.type == TransactionType.expense,
            onTap: () {
              final notifier = ref.read(transactionFilterProvider.notifier);
              if (filter.type == TransactionType.expense) {
                notifier.state = filter.copyWith(type: () => null);
              } else {
                notifier.state =
                    filter.copyWith(type: () => TransactionType.expense);
              }
            },
          ),
          const Gap(8),
          _FilterChip(
            label: 'This Week',
            isSelected: filter.dateFrom != null &&
                filter.dateFrom!.isAfter(
                  DateTime.now().subtract(const Duration(days: 7)),
                ),
            onTap: () {
              final now = DateTime.now();
              final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
              final notifier = ref.read(transactionFilterProvider.notifier);
              notifier.state = filter.copyWith(
                dateFrom: () => DateTime(
                  startOfWeek.year,
                  startOfWeek.month,
                  startOfWeek.day,
                ),
              );
            },
          ),
          const Gap(8),
          _FilterChip(
            label: 'This Month',
            isSelected: filter.dateFrom != null &&
                filter.dateFrom!.month == DateTime.now().month,
            onTap: () {
              final now = DateTime.now();
              final notifier = ref.read(transactionFilterProvider.notifier);
              notifier.state = filter.copyWith(
                dateFrom: () => DateTime(now.year, now.month, 1),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? AppColors.darkPrimary : AppColors.primary)
              : (isDark ? AppColors.darkSurface : AppColors.surface),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? (isDark ? AppColors.darkPrimary : AppColors.primary)
                : AppColors.border.withOpacity(0.5),
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: isSelected
                ? Colors.white
                : (isDark ? AppColors.darkTextPrimary : AppColors.textPrimary),
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
