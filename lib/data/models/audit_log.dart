// ─── lib/data/models/audit_log.dart ───
import 'package:hive/hive.dart';

part 'audit_log_adapter.dart';

@HiveType(typeId: 3)
class AuditLog extends HiveObject {
  AuditLog({
    required String id,
    required AuditAction action,
    required String entityType,
    required String entityId,
    double? amount,
    String? description,
    DateTime? timestamp,
    Map<String, dynamic>? previousData,
    Map<String, dynamic>? newData,
  }) {
    this.id = id;
    this.action = action;
    this.entityType = entityType;
    this.entityId = entityId;
    this.amount = amount;
    this.description = description;
    this.timestamp = timestamp ?? DateTime.now();
    this.previousData = previousData;
    this.newData = newData;
  }

  @HiveField(0)
  late String id;

  @HiveField(1)
  late AuditAction action;

  @HiveField(2)
  late String entityType;

  @HiveField(3)
  late String entityId;

  @HiveField(4)
  double? amount;

  @HiveField(5)
  String? description;

  @HiveField(6)
  late DateTime timestamp;

  @HiveField(7)
  Map<String, dynamic>? previousData;

  @HiveField(8)
  Map<String, dynamic>? newData;
}

enum AuditAction {
  @HiveField(0)
  create,

  @HiveField(1)
  update,

  @HiveField(2)
  delete,

  @HiveField(3)
  login,

  @HiveField(4)
  logout,
}