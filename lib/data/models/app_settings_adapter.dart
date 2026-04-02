// ─── lib/data/models/app_settings_adapter.dart ───
part of 'app_settings.dart';

class AppSettingsAdapter extends TypeAdapter<AppSettings> {
  @override
  final int typeId = 2;

  @override
  AppSettings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    final settings = AppSettings();
    settings.themeModeIndex = fields[0] as int? ?? 0;
    settings.currency = fields[1] as String? ?? 'INR';
    settings.monthlyIncome = fields[2] as double? ?? 0.0;
    settings.balance = fields[3] as double? ?? 0.0;
    settings.isOnboardingComplete = fields[4] as bool? ?? false;
    settings.userName = fields[5] as String? ?? 'User';
    settings.schemaVersion = fields[6] as int? ?? 1;
    settings.lastUpdated = fields[7] as DateTime?;
    return settings;
  }

  @override
  void write(BinaryWriter writer, AppSettings obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.themeModeIndex)
      ..writeByte(1)
      ..write(obj.currency)
      ..writeByte(2)
      ..write(obj.monthlyIncome)
      ..writeByte(3)
      ..write(obj.balance)
      ..writeByte(4)
      ..write(obj.isOnboardingComplete)
      ..writeByte(5)
      ..write(obj.userName)
      ..writeByte(6)
      ..write(obj.schemaVersion)
      ..writeByte(7)
      ..write(obj.lastUpdated);
  }
}