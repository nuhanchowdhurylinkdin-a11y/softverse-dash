# Softverse Dash

A Flutter POS dashboard app for managing sales, inventory, and settings β€” built with
[GetX](https://pub.dev/packages/get) for state management/routing and
[flutter_screenutil](https://pub.dev/packages/flutter_screenutil) for responsive sizing,
implemented from Figma designs.

## Features

- **Splash** β†’ **Auth** β†’ **Dashboard** flow, wired end to end.
- **Login** screen with form validation.
- **Dashboard** (Sales tab) β€” sales summary gauges, a sales bar chart, and Items /
  Categories / Employees lists.
  - Tapping the bar chart opens **Sales Summary** (gross sales, refunds, discounts,
    net sales, taxes, totals, cost of goods, gross profit).
  - Each list's "See all" opens a dedicated drill-down screen: **Sales by Item**,
    **Sales by Category**, **Sales by Employee**.
- **Inventory** tab β€” stock filter chips, scrollable category tabs, a product list
  with stock-status badges, and floating search/scan actions.
- **Settings** tab β€” stock notification toggle, sound/help rows, account details,
  and log out.

All three bottom-nav tabs (Sales / Inventory / Settings) share one dashboard
screen and controller, with the app bar reactively changing title and whether the
date navigator shows per tab.

## Tech stack

| Concern | Package |
|---|---|
| State management & routing | `get` (GetX) |
| Responsive sizing | `flutter_screenutil` |
| Fonts | `google_fonts` (Inter) |
| Icons | `iconsax_flutter` |
| Local persistence | `shared_preferences` |
| Networking | `http` |
| Env config | `flutter_dotenv` |
| Image loading states | `skeletonizer` |

## Project structure

Each flow lives in its own feature folder under `lib/features/<feature_name>/`:

```
lib/
  core/
    bindings/         # GetX controller bindings
    common/
      styles/         # getTextStyle() global text style helper
      widgets/         # Cross-feature reusable widgets (AppButton, AppTextField,
                       # GradientAppBar, GradientListCard, RadialGauge, ...)
    services/          # StorageService, NetworkCaller
    utils/
      constants/       # AppColors, API constants
      theme/           # Light/dark ThemeData, AppColorsExtension
  features/
    splash/            # Splash screen + controller
    auth/              # Login screen, controller, form widgets
    dashboard/         # Sales / Inventory / Settings tabs + sales drill-downs
      controller/
      models/
      views/screens/
      widgets/
  routes/              # AppRoute route table
  main.dart
  app.dart
```

Reusable, cross-feature widgets live in `core/common/widgets/`; widgets specific
to one feature live in that feature's own `widgets/` folder. Every screen and
widget is a `StatelessWidget` β€” state lives in the feature's `GetxController`,
consumed via `Obx`/`GetView`.

## Routes

| Route | Screen |
|---|---|
| `/splashScreen` | `SplashScreen` |
| `/loginScreen` | `LoginScreen` |
| `/dashboardScreen` | `DashboardScreen` (Sales / Inventory / Settings tabs) |
| `/salesSummaryScreen` | `SalesSummaryScreen` |
| `/salesByItemScreen` | `SalesByItemScreen` |
| `/salesByCategoryScreen` | `SalesByCategoryScreen` |
| `/salesByEmployeeScreen` | `SalesByEmployeeScreen` |

## Getting started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (Dart ^3.11.1)
- A configured iOS/Android simulator, or a physical device

### Setup

```bash
git clone <repo-url>
cd softverse_dash
flutter pub get
```

Create a `.env` file in the project root (already git-ignored) with:

```
BASE_URL=https://your-api.example.com
```

### Run

```bash
flutter run
```

### Verify

```bash
flutter analyze
flutter test
```

## Design system

- Colors are centralized in [`AppColors`](lib/core/utils/constants/colors.dart) β€”
  never hardcode a `Color(0x...)` in a screen or widget.
- Text styles go through `getTextStyle()` in
  [`global_text_style.dart`](lib/core/common/styles/global_text_style.dart).
- Light/dark-aware colors are available via `context.appColors`
  ([`app_colors_extension.dart`](lib/core/utils/theme/app_colors_extension.dart)).
