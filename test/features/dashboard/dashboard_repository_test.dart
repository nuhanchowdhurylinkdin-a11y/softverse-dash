import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:softverse_dash/core/models/response_data.dart';
import 'package:softverse_dash/core/services/network_caller.dart';
import 'package:softverse_dash/features/dashboard/data/dashboard_repository.dart';

void main() {
  setUpAll(() {
    dotenv.testLoad(fileInput: 'BASE_URL=https://phase-one.test');
  });

  test('dashboard repository serializes the selected date range', () async {
    final network = _RecordingNetworkCaller();
    final repository = HttpDashboardRepository(networkCaller: network);
    final from = DateTime(2026, 8, 1);
    final to = DateTime(2026, 8, 31);

    await repository.fetchOverview(from, to);
    await repository.fetchCategorySales(from, to);
    await repository.fetchEmployeeSales(from, to);

    expect(network.urls, [
      'https://phase-one.test/business-admin-dashboard/overview?from=2026-08-01&to=2026-08-31',
      'https://phase-one.test/reports/category-sales?from=2026-08-01&to=2026-08-31',
      'https://phase-one.test/reports/employee-sales?from=2026-08-01&to=2026-08-31',
    ]);
  });
}

class _RecordingNetworkCaller extends NetworkCaller {
  final urls = <String>[];

  @override
  Future<ResponseData> getRequest(String url, {String? token}) async {
    urls.add(url);
    return ResponseData(
      isSuccess: true,
      statusCode: 200,
      errorMessage: '',
      responseData: const <String, dynamic>{},
    );
  }
}
