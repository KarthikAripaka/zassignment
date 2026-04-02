// ─── lib/core/providers/settings_provider.dart ───
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences not initialized');
});

final settingsProvider =
    StateNotifierProvider<SettingsNotifier, Settings>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return SettingsNotifier(prefs);
});

class Settings {
  const Settings({
    this.themeMode = ThemeMode.system,
    this.currency = 'INR',
    this.monthlyIncome = 0.0,
    this.balance = 0.0,
    this.isOnboardingComplete = false,
    this.userName = 'Karthik',
  });

  final ThemeMode themeMode;
  final String currency;
  final double monthlyIncome;
  final double balance;
  final bool isOnboardingComplete;
  final String userName;

  Settings copyWith({
    ThemeMode? themeMode,
    String? currency,
    double? monthlyIncome,
    double? balance,
    bool? isOnboardingComplete,
    String? userName,
  }) {
    return Settings(
      themeMode: themeMode ?? this.themeMode,
      currency: currency ?? this.currency,
      monthlyIncome: monthlyIncome ?? this.monthlyIncome,
      balance: balance ?? this.balance,
      isOnboardingComplete:
          isOnboardingComplete ?? this.isOnboardingComplete,
      userName: userName ?? this.userName,
    );
  }
}

class SettingsNotifier extends StateNotifier<Settings> {
  SettingsNotifier(this._prefs) : super(const Settings()) {
    _load();
  }

  final SharedPreferences _prefs;

  void _load() {
    final themeIndex = _prefs.getInt('themeMode') ?? 0;
    final currency = _prefs.getString('currency') ?? 'INR';
    final monthlyIncome = _prefs.getDouble('monthlyIncome') ?? 0.0;
    final balance = _prefs.getDouble('balance') ?? 0.0;
    final isOnboardingComplete = _prefs.getBool('onboardingComplete') ?? false;
    final userName = _prefs.getString('userName') ?? 'Karthik';

    state = Settings(
      themeMode: ThemeMode.values[themeIndex],
      currency: currency,
      monthlyIncome: monthlyIncome,
      balance: balance,
      isOnboardingComplete: isOnboardingComplete,
      userName: userName,
    );
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    await _prefs.setInt('themeMode', mode.index);
    state = state.copyWith(themeMode: mode);
  }

  Future<void> setMonthlyIncome(double income) async {
    await _prefs.setDouble('monthlyIncome', income);
    state = state.copyWith(monthlyIncome: income);
  }

  Future<void> setBalance(double balance) async {
    await _prefs.setDouble('balance', balance);
    state = state.copyWith(balance: balance);
  }

  Future<void> addToBalance(double amount) async {
    final newBalance = state.balance + amount;
    await _prefs.setDouble('balance', newBalance);
    state = state.copyWith(balance: newBalance);
  }

  Future<void> subtractFromBalance(double amount) async {
    final newBalance = state.balance - amount;
    await _prefs.setDouble('balance', newBalance);
    state = state.copyWith(balance: newBalance);
  }

  Future<void> completeOnboarding({
    required double monthlyIncome,
    required double balance,
    String userName = 'Karthik',
  }) async {
    await _prefs.setBool('onboardingComplete', true);
    await _prefs.setDouble('monthlyIncome', monthlyIncome);
    await _prefs.setDouble('balance', balance);
    await _prefs.setString('userName', userName);
    state = state.copyWith(
      isOnboardingComplete: true,
      monthlyIncome: monthlyIncome,
      balance: balance,
      userName: userName,
    );
  }

  Future<void> setUserName(String name) async {
    await _prefs.setString('userName', name);
    state = state.copyWith(userName: name);
  }
}
