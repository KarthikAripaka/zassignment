// ─── lib/data/models/app_settings.dart ───
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'app_settings_adapter.dart';

@HiveType(typeId: 2)
class AppSettings extends HiveObject {
  AppSettings();

  @HiveField(0)
  int themeModeIndex = 0;

  @HiveField(1)
  String currency = 'INR';

  @HiveField(2)
  double monthlyIncome = 0.0;

  @HiveField(3)
  double balance = 0.0;

  @HiveField(4)
  bool isOnboardingComplete = false;

  @HiveField(5)
  String userName = 'User';

  @HiveField(6)
  int schemaVersion = 1;

  @HiveField(7)
  DateTime? lastUpdated;

  ThemeMode get themeMode => ThemeMode.values[themeModeIndex];
  set themeMode(ThemeMode mode) => themeModeIndex = mode.index;

  AppSettings copyWith({
    ThemeMode? themeMode,
    String? currency,
    double? monthlyIncome,
    double? balance,
    bool? isOnboardingComplete,
    String? userName,
    int? schemaVersion,
  }) {
    final settings = AppSettings()
      ..themeModeIndex = themeMode?.index ?? themeModeIndex
      ..currency = currency ?? this.currency
      ..monthlyIncome = monthlyIncome ?? this.monthlyIncome
      ..balance = balance ?? this.balance
      ..isOnboardingComplete = isOnboardingComplete ?? this.isOnboardingComplete
      ..userName = userName ?? this.userName
      ..schemaVersion = schemaVersion ?? this.schemaVersion
      ..lastUpdated = DateTime.now();
    return settings;
  }
}