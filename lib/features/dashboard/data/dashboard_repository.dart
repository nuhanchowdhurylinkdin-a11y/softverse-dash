import '../../../core/models/response_data.dart';
import '../../../core/services/network_caller.dart';
import '../../../core/utils/constants/api_constants.dart';

abstract interface class DashboardRepository {
  Future<ResponseData> fetchOverview(
    DateTime from,
    DateTime to, {
    String? storeId,
  });

  Future<ResponseData> fetchCategorySales(
    DateTime from,
    DateTime to, {
    String? storeId,
  });

  Future<ResponseData> fetchEmployeeSales(
    DateTime from,
    DateTime to, {
    String? storeId,
  });

  Future<ResponseData> fetchIdentity();

  Future<ResponseData> fetchStores();

  Future<ResponseData> fetchCategories();

  Future<ResponseData> fetchInventory({
    String? storeId,
    String? categoryId,
    String? stockStatus,
    String? expirationStatus,
    int? expiringSoonDays,
    String? search,
  });

  Future<ResponseData> fetchItemSales(
    DateTime from,
    DateTime to, {
    String? storeId,
    int limit = 20,
    int offset = 0,
  });

  Future<ResponseData> fetchSalesSummary(
    DateTime from,
    DateTime to, {
    String? storeId,
  });

  Future<ResponseData> fetchCategorySalesPage(
    DateTime from,
    DateTime to, {
    String? storeId,
    int limit = 20,
    int offset = 0,
  });

  Future<ResponseData> fetchEmployeeSalesPage(
    DateTime from,
    DateTime to, {
    String? storeId,
    int limit = 20,
    int offset = 0,
  });
}

class HttpDashboardRepository implements DashboardRepository {
  final NetworkCaller _networkCaller;

  HttpDashboardRepository({NetworkCaller? networkCaller})
    : _networkCaller = networkCaller ?? NetworkCaller();

  @override
  Future<ResponseData> fetchOverview(
    DateTime from,
    DateTime to, {
    String? storeId,
  }) => _networkCaller.getRequest(
    _dateRangeUrl(ApiConstants.dashboardOverview, from, to, storeId: storeId),
  );

  @override
  Future<ResponseData> fetchCategorySales(
    DateTime from,
    DateTime to, {
    String? storeId,
  }) => _networkCaller.getRequest(
    _dateRangeUrl(ApiConstants.categorySales, from, to, storeId: storeId),
  );

  @override
  Future<ResponseData> fetchEmployeeSales(
    DateTime from,
    DateTime to, {
    String? storeId,
  }) => _networkCaller.getRequest(
    _dateRangeUrl(ApiConstants.employeeSales, from, to, storeId: storeId),
  );

  @override
  Future<ResponseData> fetchIdentity() =>
      _networkCaller.getRequest(ApiConstants.me);

  @override
  Future<ResponseData> fetchStores() =>
      _networkCaller.getRequest(ApiConstants.stores);

  @override
  Future<ResponseData> fetchCategories() =>
      _networkCaller.getRequest(ApiConstants.categories);

  @override
  Future<ResponseData> fetchInventory({
    String? storeId,
    String? categoryId,
    String? stockStatus,
    String? expirationStatus,
    int? expiringSoonDays,
    String? search,
  }) {
    final parameters = <String, String>{
      'storeId': ?storeId,
      'categoryId': ?categoryId,
      'stockStatus': ?stockStatus,
      'expirationStatus': ?expirationStatus,
      if (expiringSoonDays != null) 'expiringSoonDays': '$expiringSoonDays',
      if (search != null && search.trim().isNotEmpty) 'search': search.trim(),
      'limit': '100',
    };
    return _networkCaller.getRequest(
      Uri.parse(
        ApiConstants.inventory,
      ).replace(queryParameters: parameters).toString(),
    );
  }

  @override
  Future<ResponseData> fetchItemSales(
    DateTime from,
    DateTime to, {
    String? storeId,
    int limit = 20,
    int offset = 0,
  }) => _networkCaller.getRequest(
    _reportUrl(
      ApiConstants.itemSales,
      from,
      to,
      storeId: storeId,
      limit: limit,
      offset: offset,
    ),
  );

  @override
  Future<ResponseData> fetchSalesSummary(
    DateTime from,
    DateTime to, {
    String? storeId,
  }) => _networkCaller.getRequest(
    _reportUrl(ApiConstants.salesSummary, from, to, storeId: storeId),
  );

  @override
  Future<ResponseData> fetchCategorySalesPage(
    DateTime from,
    DateTime to, {
    String? storeId,
    int limit = 20,
    int offset = 0,
  }) => _networkCaller.getRequest(
    _reportUrl(
      ApiConstants.categorySales,
      from,
      to,
      storeId: storeId,
      limit: limit,
      offset: offset,
    ),
  );

  @override
  Future<ResponseData> fetchEmployeeSalesPage(
    DateTime from,
    DateTime to, {
    String? storeId,
    int limit = 20,
    int offset = 0,
  }) => _networkCaller.getRequest(
    _reportUrl(
      ApiConstants.employeeSales,
      from,
      to,
      storeId: storeId,
      limit: limit,
      offset: offset,
    ),
  );

  String _dateRangeUrl(
    String base,
    DateTime from,
    DateTime to, {
    String? storeId,
  }) {
    return Uri.parse(base)
        .replace(
          queryParameters: {
            'from': _isoDate(from),
            'to': _isoDate(to),
            'storeId': ?storeId,
          },
        )
        .toString();
  }

  String _reportUrl(
    String base,
    DateTime from,
    DateTime to, {
    String? storeId,
    int? limit,
    int? offset,
  }) => Uri.parse(base)
      .replace(
        queryParameters: {
          'from': _isoDate(from),
          'to': _isoDate(to),
          'storeId': ?storeId,
          if (limit != null) 'limit': '$limit',
          if (offset != null) 'offset': '$offset',
        },
      )
      .toString();

  String _isoDate(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';
}
