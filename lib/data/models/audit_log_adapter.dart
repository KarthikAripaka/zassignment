// ─── lib/data/models/audit_log_adapter.dart ───
part of 'audit_log.dart';

class AuditLogAdapter extends TypeAdapter<AuditLog> {
  @override
  final int typeId = 3;

  @override
  AuditLog read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AuditLog(
      id: fields[0] as String? ?? '',
      action: AuditAction.values[fields[1] as int? ?? 0],
      entityType: fields[2] as String? ?? '',
      entityId: fields[3] as String? ?? '',
      amount: fields[4] as double?,
      description: fields[5] as String?,
      timestamp: fields[6] as DateTime?,
      previousData: (fields[7] as Map?)?.cast<String, dynamic>(),
      newData: (fields[8] as Map?)?.cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, AuditLog obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.action.index)
      ..writeByte(2)
      ..write(obj.entityType)
      ..writeByte(3)
      ..write(obj.entityId)
      ..writeByte(4)
      ..write(obj.amount)
      ..writeByte(5)
      ..write(obj.description)
      ..writeByte(6)
      ..write(obj.timestamp)
      ..writeByte(7)
      ..write(obj.previousData)
      ..writeByte(8)
      ..write(obj.newData);
  }
}