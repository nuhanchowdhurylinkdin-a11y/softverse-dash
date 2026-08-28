import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  ApiConstants._();

  static String get baseUrl {
    final url = dotenv.env['BASE_URL'];
    assert(url != null && url.isNotEmpty, 'BASE_URL is not set in .env');
    return url!;
  }

  static String get login => '$baseUrl/auth/login';
  static String get refresh => '$baseUrl/auth/refresh';
  static String get logout => '$baseUrl/auth/logout';
  static String get me => '$baseUrl/auth/me';

  static String get dashboardOverview =>
      '$baseUrl/business-admin-dashboard/overview';
  static String get categorySales => '$baseUrl/reports/category-sales';
  static String get employeeSales => '$baseUrl/reports/employee-sales';
}
