// ─── lib/main.dart ───
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'core/providers/settings_provider.dart';
import 'data/services/database_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final db = DatabaseService();
  await db.init();

  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const FiniaApp(),
    ),
  );
}
