// ─── lib/core/providers/database_provider.dart ───
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/services/database_service.dart';

final databaseServiceProvider = Provider<DatabaseService>((ref) {
  return DatabaseService();
});

final databaseInitProvider = FutureProvider<void>((ref) async {
  final db = ref.read(databaseServiceProvider);
  await db.init();
});