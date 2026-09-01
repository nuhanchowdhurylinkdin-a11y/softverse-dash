import 'package:flutter_test/flutter_test.dart';
import 'package:softverse_dash/core/models/response_data.dart';
import 'package:softverse_dash/features/dashboard/controller/dashboard_controller.dart';
import 'package:softverse_dash/features/dashboard/data/dashboard_repository.dart';

void main() {
  test('dashboard state is populated from its injected repository', () async {
    final repository = _FakeDashboardRepository();
    final controller = DashboardController(dashboardRepository: repository);
    controller.selectedPeriodStart.value = DateTime(2026, 8, 1);
    controller.selectedPeriodEnd.value = DateTime(2026, 8, 31);

    await controller.refreshSalesOverview();

    expect(repository.overviewRanges, hasLength(2));
    expect(repository.categoryRanges, hasLength(1));
    expect(repository.employeeRanges, hasLength(1));
    expect(controller.transactions.value, 2);
    expect(controller.netSales.value, 270);
    expect(controller.averageSale.value, 135);
    expect(controller.chartValues, [120, 150]);
    expect(controller.items.single.name, 'Chicken Fry');
    expect(controller.categories.single.name, 'Beverages');
    expect(controller.employees.single.name, 'Owner');
  });
}

class _FakeDashboardRepository implements DashboardRepository {
  final overviewRanges = <(DateTime, DateTime)>[];
  final categoryRanges = <(DateTime, DateTime)>[];
  final employeeRanges = <(DateTime, DateTime)>[];

  @override
  Future<ResponseData> fetchOverview(DateTime from, DateTime to) async {
    overviewRanges.add((from, to));
    final current = overviewRanges.length == 1;
    return _success({
      'cards': {
        'transactionCount': current ? 2 : 1,
        'netSales': current ? 270 : 100,
        'averageSale': current ? 135 : 100,
      },
      'chart': current
          ? [
              {'date': '2026-08-01', 'value': 120},
              {'date': '2026-08-02', 'value': 150},
            ]
          : <Map<String, dynamic>>[],
      'topSellingItems': current
          ? [
              {
                'name': 'Chicken Fry',
                'quantity': 18,
                'sales': 180,
                'imageUrl': '',
              },
            ]
          : <Map<String, dynamic>>[],
    });
  }

  @override
  Future<ResponseData> fetchCategorySales(DateTime from, DateTime to) async {
    categoryRanges.add((from, to));
    return _success({
      'rows': [
        {'categoryName': 'Beverages', 'itemsSold': 18, 'netSales': 180},
      ],
    });
  }

  @override
  Future<ResponseData> fetchEmployeeSales(DateTime from, DateTime to) async {
    employeeRanges.add((from, to));
    return _success({
      'rows': [
        {
          'employeeName': 'Owner',
          'receipts': 2,
          'netSales': 270,
          'avatarUrl': '',
        },
      ],
    });
  }

  ResponseData _success(dynamic data) => ResponseData(
    isSuccess: true,
    statusCode: 200,
    errorMessage: '',
    responseData: data,
  );
}
