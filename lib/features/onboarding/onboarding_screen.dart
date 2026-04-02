// ─── lib/features/onboarding/onboarding_screen.dart ───
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart'
    hide ScaleEffect;
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/extensions.dart';
import '../../core/providers/settings_provider.dart';
import '../transactions/providers/transactions_provider.dart';
import '../goals/providers/goals_provider.dart';
import '../../data/models/transaction.dart';
import '../../data/models/goal.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  final TextEditingController _incomeController = TextEditingController();
  int _currentPage = 0;
  bool _isOnboardingComplete = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
            },
            children: [
              _buildWelcomePage(),
              _buildFeaturesPage(),
              _buildIncomePage(),
            ],
          ),
          _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildWelcomePage() {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Animate(
            effects: const [
              FadeEffect(delay: Duration(milliseconds: 200)),
              ScaleEffect()
            ],
            child: Icon(
              Icons.trending_up,
              size: 120,
              color: Theme.of(context).colorScheme.primary,
            ),
          ).animate().slideY(begin: 0.2),
          const Gap(32),
          Text(
            'Finia',
            style: AppTextStyles.displayLarge.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
          )
              .animate()
              .slideY(begin: 0.3, delay: const Duration(milliseconds: 200)),
          const Gap(16),
          const Text(
            'Your Personal Finance Companion',
            style: AppTextStyles.headlineMedium,
            textAlign: TextAlign.center,
          )
              .animate()
              .slideY(begin: 0.3, delay: const Duration(milliseconds: 400)),
          const Gap(48),
          const Text(
            'Track spending, set goals, gain insights.\nEverything offline, beautifully designed.',
            style: AppTextStyles.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesPage() {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Everything you need',
            style: AppTextStyles.headlineLarge,
          ),
          const Gap(48),
          _buildFeatureItem(Icons.analytics, 'Smart Insights'),
          const Gap(24),
          _buildFeatureItem(Icons.flag, 'Goals & Challenges'),
          const Gap(24),
          _buildFeatureItem(Icons.receipt_long, 'Transaction Tracking'),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String title) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon,
              color: Theme.of(context).colorScheme.primary, size: 24),
        ),
        const Gap(16),
        Expanded(
          child: Text(
            title,
            style: AppTextStyles.headlineSmall,
          ),
        ),
      ],
    );
  }

  Widget _buildIncomePage() {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          const Gap(64),
          Animate(
            effects: const [FadeEffect()],
            child: const Text(
              'Let\'s get started',
              style: AppTextStyles.headlineLarge,
            ),
          ),
          const Gap(16),
          const Text(
            'Enter your monthly income for personalized insights',
            style: AppTextStyles.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const Gap(48),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity10,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Text(
                  '\u20B9',
                  style: AppTextStyles.displayMedium.copyWith(fontSize: 48),
                ),
                const Gap(8),
                SizedBox(
                  height: 60,
                  child: TextField(
                    controller: _incomeController,
                    keyboardType: TextInputType.number,
                    style: AppTextStyles.amountLarge,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: '0',
                      hintStyle: AppTextStyles.amountLarge.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.4),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Positioned(
      bottom: 32,
      left: 32,
      right: 32,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (_currentPage > 0)
            TextButton(
              onPressed: () => _pageController.previousPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              ),
              child: Text(
                'Back',
                style: AppTextStyles.bodyMedium.copyWith(
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            )
          else
            const SizedBox(width: 72),
          SmoothPageIndicator(
            controller: _pageController,
            count: 3,
            effect: WormEffect(
              dotColor:
                  Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
              activeDotColor: Theme.of(context).colorScheme.primary,
              dotHeight: 8,
              dotWidth: 8,
              spacing: 12,
            ),
          ),
          ElevatedButton(
            onPressed: _isOnboardingComplete ? null : () => _handleNext(),
            child: Text(
              _currentPage == 2 ? 'Get Started' : 'Next',
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleNext() async {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      setState(() => _isOnboardingComplete = true);

      final income = double.tryParse(_incomeController.text) ?? 50000.0;

      // Save onboarding state
      await ref.read(settingsProvider.notifier).completeOnboarding(
            monthlyIncome: income,
            balance: income,
          );

      // Seed sample transactions
      final now = DateTime.now();
      final transactionsNotifier = ref.read(transactionsProvider.notifier);

      final sampleTransactions = [
        {
          'amount': income,
          'type': TransactionType.income,
          'categoryId': 'income',
          'title': 'Monthly Salary',
          'date': DateTime(now.year, now.month, 1),
        },
        {
          'amount': 1200.0,
          'type': TransactionType.expense,
          'categoryId': 'food',
          'title': 'Grocery Shopping',
          'date': now.subtract(const Duration(days: 1)),
        },
        {
          'amount': 500.0,
          'type': TransactionType.expense,
          'categoryId': 'transport',
          'title': 'Uber Rides',
          'date': now.subtract(const Duration(days: 2)),
        },
        {
          'amount': 2500.0,
          'type': TransactionType.expense,
          'categoryId': 'shopping',
          'title': 'New Shoes',
          'date': now.subtract(const Duration(days: 3)),
        },
        {
          'amount': 300.0,
          'type': TransactionType.expense,
          'categoryId': 'entertainment',
          'title': 'Movie Night',
          'date': now.subtract(const Duration(days: 4)),
        },
        {
          'amount': 800.0,
          'type': TransactionType.expense,
          'categoryId': 'utilities',
          'title': 'Electricity Bill',
          'date': now.subtract(const Duration(days: 5)),
        },
        {
          'amount': 15000.0,
          'type': TransactionType.expense,
          'categoryId': 'housing',
          'title': 'Rent Payment',
          'date': DateTime(now.year, now.month, 1),
        },
        {
          'amount': 350.0,
          'type': TransactionType.expense,
          'categoryId': 'health',
          'title': 'Pharmacy',
          'date': now.subtract(const Duration(days: 6)),
        },
      ];

      for (final t in sampleTransactions) {
        await transactionsNotifier.add(
          amount: t['amount'] as double,
          type: t['type'] as TransactionType,
          categoryId: t['categoryId'] as String,
          title: t['title'] as String,
          date: t['date'] as DateTime,
        );
      }

      // Seed sample goals
      final goalsNotifier = ref.read(goalsProvider.notifier);

      await goalsNotifier.add(
        title: 'Emergency Fund',
        targetAmount: 100000,
        type: GoalType.savings,
        deadline: now.add(const Duration(days: 180)),
      );

      await goalsNotifier.add(
        title: 'No Takeout Week',
        targetAmount: 0,
        type: GoalType.noSpend,
      );

      await goalsNotifier.add(
        title: 'Monthly Budget',
        targetAmount: income * 0.7,
        type: GoalType.budget,
        deadline: DateTime(now.year, now.month + 1, 0),
      );

      // Navigate to dashboard
      if (mounted && context.mounted) {
        context.go('/');
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _incomeController.dispose();
    super.dispose();
  }
}
