import 'package:get/get.dart';

import '../features/splash/views/screens/splash_screen.dart';
import '../features/auth/views/screens/login_screen.dart';
import '../features/dashboard/views/screens/dashboard_screen.dart';
import '../features/dashboard/views/screens/sales_by_item_screen.dart';
import '../features/dashboard/views/screens/sales_by_category_screen.dart';
import '../features/dashboard/views/screens/sales_by_employee_screen.dart';
import '../features/dashboard/views/screens/sales_summary_screen.dart';

class AppRoute {
  static String splashScreen = "/splashScreen";
  static String loginScreen = "/loginScreen";
  static String dashboardScreen = "/dashboardScreen";
  static String salesByItemScreen = "/salesByItemScreen";
  static String salesByCategoryScreen = "/salesByCategoryScreen";
  static String salesByEmployeeScreen = "/salesByEmployeeScreen";
  static String salesSummaryScreen = "/salesSummaryScreen";

  static String getSplashScreen() => splashScreen;
  static String getLoginScreen() => loginScreen;
  static String getDashboardScreen() => dashboardScreen;
  static String getSalesByItemScreen() => salesByItemScreen;
  static String getSalesByCategoryScreen() => salesByCategoryScreen;
  static String getSalesByEmployeeScreen() => salesByEmployeeScreen;
  static String getSalesSummaryScreen() => salesSummaryScreen;

  static List<GetPage> routes = [
    GetPage(name: splashScreen, page: () => const SplashScreen()),
    GetPage(name: loginScreen, page: () => const LoginScreen()),
    GetPage(name: dashboardScreen, page: () => const DashboardScreen()),
    GetPage(name: salesByItemScreen, page: () => const SalesByItemScreen()),
    GetPage(name: salesByCategoryScreen, page: () => const SalesByCategoryScreen()),
    GetPage(name: salesByEmployeeScreen, page: () => const SalesByEmployeeScreen()),
    GetPage(name: salesSummaryScreen, page: () => const SalesSummaryScreen()),
  ];
}
