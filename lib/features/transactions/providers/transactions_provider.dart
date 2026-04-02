// ─── lib/features/transactions/providers/transactions_provider.dart ───
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../../../data/models/transaction.dart';
import '../../../data/adapters/transaction_adapter.dart' as adapter;
import '../../../core/providers/settings_provider.dart';

final transactionsBoxProvider = FutureProvider<Box<Transaction>>((ref) async {
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(adapter.ManualTransactionAdapter());
  }
  return Hive.openBox<Transaction>('transactions');
});

final transactionsProvider =
    StateNotifierProvider<TransactionsNotifier, List<Transaction>>((ref) {
  final box = ref.watch(transactionsBoxProvider);
  final settingsNotifier = ref.watch(settingsProvider.notifier);
  return TransactionsNotifier(box.value, settingsNotifier);
});

class TransactionsNotifier extends StateNotifier<List<Transaction>> {
  TransactionsNotifier(this._box, this._settingsNotifier) : super([]) {
    _load();
  }

  final Box<Transaction>? _box;
  final SettingsNotifier _settingsNotifier;
  static const _uuid = Uuid();

  void _load() {
    if (_box == null) return;
    state = _box.values.toList()..sort((a, b) => b.date.compareTo(a.date));
  }

  Future<void> add({
    required double amount,
    required TransactionType type,
    required String categoryId,
    required String title,
    String? notes,
    required DateTime date,
  }) async {
    if (_box == null) return;
    final transaction = Transaction(
      id: _uuid.v4(),
      amount: amount,
      type: type,
      categoryId: categoryId,
      title: title,
      notes: notes,
      date: date,
      createdAt: DateTime.now(),
    );
    await _box.add(transaction);
    _load();

    if (type == TransactionType.income) {
      await _settingsNotifier.addToBalance(amount);
    } else {
      await _settingsNotifier.subtractFromBalance(amount);
    }
  }

  Future<void> update(Transaction oldTransaction, Transaction newTransaction) async {
    if (_box == null) return;
    final index = _box.values.toList().indexWhere((t) => t.id == oldTransaction.id);
    if (index != -1) {
      await _box.putAt(index, newTransaction);
      _load();

      if (oldTransaction.type == TransactionType.income) {
        await _settingsNotifier.subtractFromBalance(oldTransaction.amount);
      } else {
        await _settingsNotifier.addToBalance(oldTransaction.amount);
      }

      if (newTransaction.type == TransactionType.income) {
        await _settingsNotifier.addToBalance(newTransaction.amount);
      } else {
        await _settingsNotifier.subtractFromBalance(newTransaction.amount);
      }
    }
  }

  Future<void> delete(String id) async {
    if (_box == null) return;
    final index = _box.values.toList().indexWhere((t) => t.id == id);
    if (index != -1) {
      final transaction = _box.values.toList()[index];
      await _box.deleteAt(index);
      _load();

      if (transaction.type == TransactionType.income) {
        await _settingsNotifier.subtractFromBalance(transaction.amount);
      } else {
        await _settingsNotifier.addToBalance(transaction.amount);
      }
    }
  }

  Future<void> clearAll() async {
    if (_box == null) return;
    await _box.clear();
    _load();
  }
}

final transactionFilterProvider =
    StateProvider<TransactionFilter>((ref) => const TransactionFilter());

class TransactionFilter {
  const TransactionFilter({
    this.type,
    this.categoryId,
    this.searchQuery = '',
    this.dateFrom,
    this.dateTo,
  });

  final TransactionType? type;
  final String? categoryId;
  final String searchQuery;
  final DateTime? dateFrom;
  final DateTime? dateTo;

  TransactionFilter copyWith({
    TransactionType? Function()? type,
    String? Function()? categoryId,
    String? searchQuery,
    DateTime? Function()? dateFrom,
    DateTime? Function()? dateTo,
  }) {
    return TransactionFilter(
      type: type != null ? type() : this.type,
      categoryId: categoryId != null ? categoryId() : this.categoryId,
      searchQuery: searchQuery ?? this.searchQuery,
      dateFrom: dateFrom != null ? dateFrom() : this.dateFrom,
      dateTo: dateTo != null ? dateTo() : this.dateTo,
    );
  }

  bool get isEmpty =>
      type == null &&
      categoryId == null &&
      searchQuery.isEmpty &&
      dateFrom == null &&
      dateTo == null;
}

final filteredTransactionsProvider =
    Provider<AsyncValue<List<Transaction>>>((ref) {
  final transactions = ref.watch(transactionsProvider);
  final filter = ref.watch(transactionFilterProvider);
  final boxState = ref.watch(transactionsBoxProvider);

  return boxState.when(
    data: (_) {
      var filtered = transactions;

      if (filter.type != null) {
        filtered = filtered.where((t) => t.type == filter.type).toList();
      }
      if (filter.categoryId != null) {
        filtered =
            filtered.where((t) => t.categoryId == filter.categoryId).toList();
      }
      if (filter.searchQuery.isNotEmpty) {
        final query = filter.searchQuery.toLowerCase();
        filtered = filtered
            .where((t) =>
                t.title.toLowerCase().contains(query) ||
                (t.notes?.toLowerCase().contains(query) ?? false))
            .toList();
      }
      if (filter.dateFrom != null) {
        filtered =
            filtered.where((t) => t.date.isAfter(filter.dateFrom!)).toList();
      }
      if (filter.dateTo != null) {
        filtered =
            filtered.where((t) => t.date.isBefore(filter.dateTo!)).toList();
      }

      return AsyncValue.data(filtered);
    },
    loading: () => const AsyncValue.loading(),
    error: (e, s) => AsyncValue.error(e, s),
  );
});
