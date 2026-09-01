import '../../../core/models/response_data.dart';
import '../../../core/services/network_caller.dart';
import '../../../core/utils/constants/api_constants.dart';

abstract interface class DashboardRepository {
  Future<ResponseData> fetchOverview(DateTime from, DateTime to);

  Future<ResponseData> fetchCategorySales(DateTime from, DateTime to);

  Future<ResponseData> fetchEmployeeSales(DateTime from, DateTime to);
}

class HttpDashboardRepository implements DashboardRepository {
  final NetworkCaller _networkCaller;

  HttpDashboardRepository({NetworkCaller? networkCaller})
    : _networkCaller = networkCaller ?? NetworkCaller();

  @override
  Future<ResponseData> fetchOverview(DateTime from, DateTime to) =>
      _networkCaller.getRequest(
        _dateRangeUrl(ApiConstants.dashboardOverview, from, to),
      );

  @override
  Future<ResponseData> fetchCategorySales(DateTime from, DateTime to) =>
      _networkCaller.getRequest(
        _dateRangeUrl(ApiConstants.categorySales, from, to),
      );

  @override
  Future<ResponseData> fetchEmployeeSales(DateTime from, DateTime to) =>
      _networkCaller.getRequest(
        _dateRangeUrl(ApiConstants.employeeSales, from, to),
      );

  String _dateRangeUrl(String base, DateTime from, DateTime to) {
    return Uri.parse(base)
        .replace(queryParameters: {'from': _isoDate(from), 'to': _isoDate(to)})
        .toString();
  }

  String _isoDate(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';
}
