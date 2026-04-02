// ─── lib/data/adapters/goal_adapter.dart ───
import 'package:hive/hive.dart';
import '../models/goal.dart';

class ManualGoalAdapter extends TypeAdapter<Goal> {
  @override
  final int typeId = 1;

  @override
  Goal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (int i = 0; i < numOfFields; i++) {
      final key = reader.readByte();
      final value = reader.read();
      fields[key] = value;
    }

    return Goal(
      id: fields[0] as String,
      title: fields[1] as String,
      targetAmount: fields[2] as double,
      currentAmount: fields.containsKey(3) ? fields[3] as double : 0.0,
      deadline: fields.containsKey(4) ? fields[4] as DateTime? : null,
      type: GoalType.values[fields[5] as int],
      streakDays: fields.containsKey(6) ? fields[6] as int : 0,
      lastCheckIn: fields.containsKey(7) ? fields[7] as DateTime? : null,
      isCompleted: fields.containsKey(8) ? fields[8] as bool : false,
      createdAt: fields[9] as DateTime,
      contributionStreak: fields.containsKey(10) ? fields[10] as int : 0,
      lastContribution: fields.containsKey(11) ? fields[11] as DateTime? : null,
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
      ..write(obj.type.index)
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
}
