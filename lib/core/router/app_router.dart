// ─── lib/core/router/app_router.dart ───
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/dashboard/dashboard_screen.dart';
import '../../features/goals/goals_screen.dart';
import '../../features/insights/insights_screen.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/transactions/transactions_screen.dart';
import '../widgets/app_scaffold.dart';
import '../providers/settings_provider.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final settings = ref.watch(settingsProvider);

  return GoRouter(
    initialLocation: settings.isOnboardingComplete ? '/' : '/onboarding',
    routes: [
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => AppScaffold(child: child),
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const DashboardScreen(),
            routes: [
              GoRoute(
                path: 'transactions',
                builder: (context, state) => const TransactionsScreen(),
              ),
              GoRoute(
                path: 'goals',
                builder: (context, state) => const GoalsScreen(),
              ),
              GoRoute(
                path: 'insights',
                builder: (context, state) => const InsightsScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
