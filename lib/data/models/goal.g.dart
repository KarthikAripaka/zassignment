// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GoalAdapter extends TypeAdapter<Goal> {
  @override
  final int typeId = 1;

  @override
  Goal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Goal(
      id: fields[0] as String,
      title: fields[1] as String,
      targetAmount: fields[2] as double,
      currentAmount: fields[3] as double? ?? 0.0,
      deadline: fields[4] as DateTime?,
      type: fields[5] as GoalType,
      streakDays: fields[6] as int? ?? 0,
      lastCheckIn: fields[7] as DateTime?,
      isCompleted: fields[8] as bool? ?? false,
      createdAt: fields[9] as DateTime,
      contributionStreak: fields[10] as int? ?? 0,
      lastContribution: fields[11] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Goal obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.targetAmount)
      ..writeByte(3)
      ..write(obj.currentAmount)
      ..writeByte(4)
      ..write(obj.deadline)
      ..writeByte(5)
      ..write(obj.type)
      ..writeByte(6)
      ..write(obj.streakDays)
      ..writeByte(7)
      ..write(obj.lastCheckIn)
      ..writeByte(8)
      ..write(obj.isCompleted)
      ..writeByte(9)
      ..write(obj.createdAt)
      ..writeByte(10)
      ..write(obj.contributionStreak)
      ..writeByte(11)
      ..write(obj.lastContribution);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GoalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GoalImpl _$$GoalImplFromJson(Map<String, dynamic> json) => _$GoalImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      targetAmount: (json['targetAmount'] as num).toDouble(),
      currentAmount: (json['currentAmount'] as num?)?.toDouble() ?? 0.0,
      deadline: json['deadline'] == null
          ? null
          : DateTime.parse(json['deadline'] as String),
      type: $enumDecode(_$GoalTypeEnumMap, json['type']),
      streakDays: (json['streakDays'] as num?)?.toInt() ?? 0,
      lastCheckIn: json['lastCheckIn'] == null
          ? null
          : DateTime.parse(json['lastCheckIn'] as String),
      isCompleted: json['isCompleted'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$GoalImplToJson(_$GoalImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'targetAmount': instance.targetAmount,
      'currentAmount': instance.currentAmount,
      'deadline': instance.deadline?.toIso8601String(),
      'type': _$GoalTypeEnumMap[instance.type]!,
      'streakDays': instance.streakDays,
      'lastCheckIn': instance.lastCheckIn?.toIso8601String(),
      'isCompleted': instance.isCompleted,
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$GoalTypeEnumMap = {
  GoalType.savings: 'savings',
  GoalType.noSpend: 'no_spend',
  GoalType.budget: 'budget',
};
