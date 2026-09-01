import 'package:get/get.dart';

import '../features/splash/views/screens/splash_screen.dart';
import '../features/auth/views/screens/login_screen.dart';
import '../features/dashboard/views/screens/dashboard_screen.dart';
import '../features/dashboard/views/screens/sales_by_item_screen.dart';
import '../features/dashboard/views/screens/sales_by_category_screen.dart';
import '../features/dashboard/views/screens/sales_by_employee_screen.dart';
import '../features/dashboard/views/screens/sales_summary_screen.dart';
import '../features/dashboard/controller/scan_barcode_controller.dart';
import '../features/dashboard/views/screens/inventory_search_screen.dart';
import '../features/dashboard/views/screens/scan_barcode_screen.dart';

class AppRoute {
  static String splashScreen = "/splashScreen";
  static String loginScreen = "/loginScreen";
  static String dashboardScreen = "/dashboardScreen";
  static String salesByItemScreen = "/salesByItemScreen";
  static String salesByCategoryScreen = "/salesByCategoryScreen";
  static String salesByEmployeeScreen = "/salesByEmployeeScreen";
  static String salesSummaryScreen = "/salesSummaryScreen";
  static String inventorySearchScreen = "/inventorySearchScreen";
  static String scanBarcodeScreen = "/scanBarcodeScreen";

  static String getSplashScreen() => splashScreen;
  static String getLoginScreen() => loginScreen;
  static String getDashboardScreen() => dashboardScreen;
  static String getSalesByItemScreen() => salesByItemScreen;
  static String getSalesByCategoryScreen() => salesByCategoryScreen;
  static String getSalesByEmployeeScreen() => salesByEmployeeScreen;
  static String getSalesSummaryScreen() => salesSummaryScreen;
  static String getInventorySearchScreen() => inventorySearchScreen;
  static String getScanBarcodeScreen() => scanBarcodeScreen;

  static List<GetPage> routes = [
    GetPage(name: splashScreen, page: () => const SplashScreen()),
    GetPage(name: loginScreen, page: () => const LoginScreen()),
    GetPage(name: dashboardScreen, page: () => const DashboardScreen()),
    GetPage(
      name: inventorySearchScreen,
      page: () => const InventorySearchScreen(),
    ),
    GetPage(
      name: scanBarcodeScreen,
      page: () => const ScanBarcodeScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<ScanBarcodeController>(() => ScanBarcodeController());
      }),
    ),
    GetPage(name: salesByItemScreen, page: () => const SalesByItemScreen()),
    GetPage(
      name: salesByCategoryScreen,
      page: () => const SalesByCategoryScreen(),
    ),
    GetPage(
      name: salesByEmployeeScreen,
      page: () => const SalesByEmployeeScreen(),
    ),
    GetPage(name: salesSummaryScreen, page: () => const SalesSummaryScreen()),
  ];
}
