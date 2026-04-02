// ─── lib/data/services/database_service.dart ───
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../models/transaction.dart';
import '../models/goal.dart';
import '../models/app_settings.dart';
import '../models/audit_log.dart';
import '../adapters/transaction_adapter.dart';
import '../adapters/goal_adapter.dart';

class DatabaseService {
  static const String transactionsBox = 'transactions';
  static const String goalsBox = 'goals';
  static const String settingsBox = 'settings';
  static const String auditLogsBox = 'audit_logs';

  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  final _uuid = const Uuid();

  late Box<Transaction> _transactionsBox;
  late Box<Goal> _goalsBox;
  late Box<AppSettings> _settingsBox;
  late Box<AuditLog> _auditLogsBox;

  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;

    await Hive.initFlutter();

    _registerAdapters();

    _transactionsBox = await Hive.openBox<Transaction>(transactionsBox);
    _goalsBox = await Hive.openBox<Goal>(goalsBox);
    _settingsBox = await Hive.openBox<AppSettings>(settingsBox);
    _auditLogsBox = await Hive.openBox<AuditLog>(auditLogsBox);

    _isInitialized = true;
  }

  void _registerAdapters() {
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(ManualTransactionAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(ManualGoalAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(AppSettingsAdapter());
    }
    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter(AuditLogAdapter());
    }
  }

  // Settings
  AppSettings get settings {
    if (_settingsBox.isEmpty) {
      final defaultSettings = AppSettings();
      _settingsBox.put('default', defaultSettings);
      return defaultSettings;
    }
    return _settingsBox.get('default') ?? AppSettings();
  }

  Future<void> saveSettings(AppSettings settings) async {
    await _settingsBox.put('default', settings);
  }

  // Audit Logs
  Future<void> logAudit({
    required AuditAction action,
    required String entityType,
    required String entityId,
    double? amount,
    String? description,
    Map<String, dynamic>? previousData,
    Map<String, dynamic>? newData,
  }) async {
    final log = AuditLog(
      id: _uuid.v4(),
      action: action,
      entityType: entityType,
      entityId: entityId,
      amount: amount,
      description: description,
      previousData: previousData,
      newData: newData,
    );
    await _auditLogsBox.add(log);
  }

  List<AuditLog> getAuditLogs({String? entityType, String? entityId}) {
    var logs = _auditLogsBox.values.toList();
    if (entityType != null) {
      logs = logs.where((l) => l.entityType == entityType).toList();
    }
    if (entityId != null) {
      logs = logs.where((l) => l.entityId == entityId).toList();
    }
    logs.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return logs;
  }

  // Export all data
  Map<String, dynamic> exportData() {
    return {
      'exportedAt': DateTime.now().toIso8601String(),
      'transactions': _transactionsBox.values.map((t) => {
        'id': t.id,
        'amount': t.amount,
        'type': t.type.name,
        'categoryId': t.categoryId,
        'title': t.title,
        'notes': t.notes,
        'date': t.date.toIso8601String(),
        'createdAt': t.createdAt.toIso8601String(),
      }).toList(),
      'goals': _goalsBox.values.map((g) => {
        'id': g.id,
        'title': g.title,
        'targetAmount': g.targetAmount,
        'currentAmount': g.currentAmount,
        'type': g.type.name,
        'deadline': g.deadline?.toIso8601String(),
        'streakDays': g.streakDays,
        'lastCheckIn': g.lastCheckIn?.toIso8601String(),
        'isCompleted': g.isCompleted,
        'createdAt': g.createdAt.toIso8601String(),
      }).toList(),
      'settings': {
        'balance': settings.balance,
        'monthlyIncome': settings.monthlyIncome,
        'userName': settings.userName,
        'isOnboardingComplete': settings.isOnboardingComplete,
      },
      'auditLogs': _auditLogsBox.values.map((l) => {
        'id': l.id,
        'action': l.action.name,
        'entityType': l.entityType,
        'entityId': l.entityId,
        'amount': l.amount,
        'description': l.description,
        'timestamp': l.timestamp.toIso8601String(),
      }).toList(),
    };
  }

  // Clear all data (for testing/reset)
  Future<void> clearAll() async {
    await _transactionsBox.clear();
    await _goalsBox.clear();
    await _auditLogsBox.clear();
    await _settingsBox.clear();
  }

  // Close
  Future<void> close() async {
    await _transactionsBox.close();
    await _goalsBox.close();
    await _settingsBox.close();
    await _auditLogsBox.close();
  }
}