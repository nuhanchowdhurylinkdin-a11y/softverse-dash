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
  static String get stores =>
      '$baseUrl/business-admin-dashboard/settings/stores';
  static String get inventory => '$baseUrl/inventory';
  static String get categories => '$baseUrl/categories';

  static String get dashboardOverview =>
      '$baseUrl/business-admin-dashboard/overview';
  static String get categorySales => '$baseUrl/reports/category-sales';
  static String get employeeSales => '$baseUrl/reports/employee-sales';

  static String resolveAssetUrl(String? url) {
    if (url == null || url.trim().isEmpty) return '';
    final value = url.trim();
    final uri = Uri.tryParse(value);
    if (uri != null && uri.hasScheme) {
      final uploadPath = _normalizeUploadPath(uri.path);
      if (uploadPath != null) return '$baseUrl$uploadPath';
      return value;
    }

    final uploadPath = _normalizeUploadPath(value);
    if (uploadPath != null) return '$baseUrl$uploadPath';
    if (value.startsWith('/')) return '$baseUrl$value';
    return '$baseUrl/$value';
  }

  static String? _normalizeUploadPath(String path) {
    final normalized = path.trim();
    if (normalized.isEmpty) return null;

    if (normalized.startsWith('/media/uploads/')) return normalized;
    if (normalized.startsWith('/uploads/')) return '/media$normalized';
    if (normalized.startsWith('media/uploads/')) return '/$normalized';
    if (normalized.startsWith('uploads/')) return '/media/$normalized';
    return null;
  }
}
