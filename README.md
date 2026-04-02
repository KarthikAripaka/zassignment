# Finia - Personal Finance Companion

A production-quality, fully offline-first personal finance app built with Flutter.

## Design Philosophy

Calm, refined, confidence-inspiring. Like a premium banking app crossed with a minimal productivity tool. Every interaction is polished with micro-animations, intelligent insights, and a signature Goals & Challenges feature.

## Tech Stack & Rationale

- **Flutter 3.x / Dart 3.x**: Cross-platform excellence with null safety
- **Riverpod 2.x**: Modern, testable state management (AsyncNotifier + StateNotifier)
- **Hive**: Fast offline persistence for transactions and goals, no SQL overhead
- **go_router 12.x**: Type-safe navigation with ShellRoute for bottom nav
- **fl_chart 0.66+**: Beautiful, customizable charts for spending trends
- **Google Fonts**: DM Serif Display (headings), DM Sans (body), Roboto Mono (amounts)
- **freezed**: Immutable models with Hive/JSON serialization
- **flutter_animate**: Count-up animations, list entrances, page transitions

## Architecture

```
lib/
├── main.dart                    # App entry, Hive init, SharedPreferences
├── app.dart                     # MaterialApp.router + ProviderScope
├── core/
│   ├── theme/                   # Colors, text styles, ThemeData
│   ├── router/                  # go_router with ShellRoute
│   ├── utils/                   # Currency formatter, date utils, extensions
│   ├── widgets/                 # Shared widgets (empty state, shimmer, etc.)
│   └── providers/               # Settings provider (theme, income, onboarding)
├── features/
│   ├── onboarding/              # 3-page onboarding with seed data
│   ├── dashboard/               # Balance card, charts, recent transactions
│   ├── transactions/            # CRUD, search, filter, grouped list
│   ├── goals/                   # Savings goals + challenges
│   └── insights/                # Category breakdown, trends, smart insights
└── data/
    ├── models/                  # Freezed + HiveType models
    └── adapters/                # Manual Hive adapters
```

## Features

### Dashboard
- Animated balance card with monthly income/expense split
- 7-day spending bar chart (tappable bars with tooltips)
- Recent transactions preview
- Active goals carousel
- Savings rate and top category chips

### Transactions
- Grouped by date with sticky headers
- Swipe to delete with undo snackbar
- Filter by type (income/expense), date range
- Real-time search
- Add/edit with category grid, date picker, notes

### Goals & Challenges (Signature Feature)
- **Savings Goals**: Progress bars, quick add money, color shifts as progress increases
- **No-Spend Streak**: Flame streak counter, daily check-in tracking
- **Weekly Budget Challenge**: Fuel gauge visualization
- Streak badges, motivational messaging

### Insights
- Category pie chart with tappable legend
- Income vs expenses line chart (4-week trend)
- Smart insight cards generated from actual data
- Period selector (This Week, This Month, Last Month)
- Top transactions list

### UX Excellence
- Custom empty/error/loading states everywhere
- Haptic feedback on interactions
- Staggered list animations
- Count-up number animations on dashboard
- Light/dark/system theme toggle (persisted)
- Bottom nav with animated indicator

## Screenshots

### Dashboard
```
[Balance Card]
 Total Balance: ₹45,230
 Income: ₹52,000 | Expenses: ₹6,770

[7-day Spending Chart]

 This Month: 78% saved | Top: Food ₹2.1K

 Recent Transactions →
 Active Goals →
```

### Transactions
```
[Search Bar] [Filters: All|Income|Expenses|This Week]

 Today
   Grocery shopping  Food  -₹450
   Metro pass  Transport  -₹120

 Yesterday
   Monthly Salary  Income  +₹52,000
```

### Goals
```
 [Savings] New Laptop Fund
  ████████░░░░ 31% (₹25,000 of ₹80,000)
  87 days left

 [No-Spend] No Shopping Week
  🔥 3 day streak
  [Check In Today]
```

### Insights
```
 Spending by Category [Donut Chart]
 Food: ₹2,100 | Transport: ₹320 | Shopping: ₹1,549

 💡 Your biggest expense is Food (₹2.1K)
 💡 You're saving 78% of your income this period
 💡 Friday is your highest spending day
```

## Setup & Run

1. `flutter pub get`
2. `dart run build_runner build --delete-conflicting-outputs`
3. `flutter analyze` (zero errors)
4. `flutter run`

First launch shows onboarding, seeds 15 sample transactions + 2 goals.

## Assumptions

- Currency: INR (₹)
- Categories: Pre-defined 11 categories (non-editable)
- Offline-only (no sync/backend)
- Single user
- Monthly income used for insights calculations

## Potential Improvements

1. Cloud sync (Firebase/Supabase)
2. Custom categories
3. Export CSV/PDF
4. Biometric authentication
5. Recurring transactions
6. Budget planner with alerts
7. Multi-currency support
8. Share insights as image
9. Home screen widget
10. Split transactions

---

Built with Flutter + Riverpod + Hive. Fully offline-first.
