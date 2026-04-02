# Finia - Personal Finance Companion

A production-quality, fully offline-first personal finance app built with Flutter.

## Design Philosophy

Calm, refined, confidence-inspiring. Like a premium banking app crossed with a minimal productivity tool. Every interaction is polished with micro-animations, intelligent insights, and a signature Goals & Challenges feature.

## Tech Stack & Rationale

- **Flutter 3.x / Dart 3.x**: Cross-platform excellence with null safety
- **Riverpod 2.x**: Modern, testable state management (AsyncNotifier + StateNotifier)
- **Hive**: Fast offline persistence for transactions, goals, settings, and audit logs
- **go_router 12.x**: Type-safe navigation with ShellRoute for bottom nav
- **fl_chart 0.66+**: Beautiful, customizable charts for spending trends
- **Google Fonts**: DM Serif Display (headings), DM Sans (body), Roboto Mono (amounts)
- **freezed**: Immutable models with Hive/JSON serialization
- **flutter_animate**: Count-up animations, list entrances, page transitions

## Architecture

```
lib/
├── main.dart                    # App entry, Hive init, seed data
├── app.dart                     # MaterialApp.router + ProviderScope
├── core/
│   ├── theme/                   # Colors, text styles, ThemeData (light/dark)
│   ├── router/                  # go_router with ShellRoute
│   ├── utils/                   # Currency formatter, date utils, extensions
│   ├── widgets/                 # Shared widgets (empty state, shimmer, etc.)
│   └── providers/               # Settings provider (theme, income, balance)
├── features/
│   ├── onboarding/              # 3-page onboarding with name/balance
│   ├── dashboard/               # Balance card, charts, recent transactions
│   ├── transactions/            # CRUD, search, filter (All/Income/Expenses)
│   ├── goals/                   # Savings goals with streak tracking
│   └── insights/                # Category breakdown, trends
└── data/
    ├── models/                  # Freezed + HiveType models
    ├── adapters/                # Hive adapters for all models
    └── services/              # Database + seed data services
```

## Features

### Dashboard
- Animated balance card with monthly income/expense split
- 7-day spending bar chart (tappable bars with tooltips)
- Recent transactions preview
- Active goals progress cards
- Savings rate display

### Transactions
- Grouped by date with sticky headers
- Filter by type (All/Income/Expenses) and date (This Month)
- Real-time search
- Add/edit with category grid, date picker, notes
- Stays on transaction screen after adding

### Goals & Challenges
- **Savings Goals**: Progress bars, quick add money, streak tracking
- **Contribution Streak**: Fire icon with consecutive day count (stored in database)
- Color shifts as progress increases
- Add money stays on goals screen

### Insights
- Category pie chart with tappable legend
- Income vs expenses breakdown
- Smart insight cards from actual data

### Database (Full Local Storage)
- **Transactions**: Stored in Hive
- **Goals**: Stored in Hive with contributionStreak & lastContribution
- **Settings**: Stored in Hive (balance, income, theme, user name)
- **Audit Logs**: Full tracking of all CRUD operations

### Theme Support
- Light mode: Pure white background, black text
- Dark mode: Dark background, white text
- Theme toggle persisted in database
- System theme option

### UX Excellence
- Custom empty/error/loading states everywhere
- Haptic feedback on interactions
- Staggered list animations
- Count-up number animations on dashboard
- Light/dark/system theme toggle (persisted)
- Bottom nav with NavigationBar

## Seed Data

On first launch (and every restart for development), the app seeds:
- 5 sample transactions (salary, grocery, fuel, rent, movie)
- 3 sample goals with different streak levels:
  - Emergency Fund: 8 day streak
  - New Phone: 9 day streak
  - Vacation Trip: 0 day streak

## Screenshots

### Dashboard
```
[Balance Card]
 Total Balance: ₹15,000
 Income: ₹5,000 | Expenses: ₹4,600

[7-day Spending Chart]
 Recent Transactions →
 Active Goals →
```

### Transactions
```
[Search Bar] [Filters: All|Income|Expenses|This Month]

 Today
   Grocery shopping  Food  -₹1,500
   Fuel  Transport  -₹800

 Yesterday
   Salary  Income  +₹5,000
```

### Goals
```
[Emergency Fund] 🔥 8
 ██████████████░░ 30% (₹15,000 of ₹50,000)
 90 days left

[New Phone] 🔥 9
 █████████████████░░░ 32% (₹8,000 of ₹25,000)
 60 days left
```

### Theme
- Light: White (#FFFFFF) background, Black (#000000) text
- Dark: Dark (#121318) background, White (#FFFFFF) text
- Charts and icons retain their colors in both themes

## Setup & Run

1. `flutter pub get`
2. `dart run build_runner build --delete-conflicting-outputs`
3. `flutter analyze` (zero errors)
4. `flutter run -d chrome` or `flutter run`

## Assumptions

- Currency: INR (₹)
- Categories: 12 pre-defined categories (food, transport, shopping, entertainment, health, housing, utilities, education, travel, income, salary, rent, other)
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
11. Bill reminders
12. Investment tracking

---

Built with Flutter + Riverpod + Hive. Fully offline-first.