import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:softverse_dash/core/models/response_data.dart';
import 'package:softverse_dash/core/services/storage_service.dart';
import 'package:softverse_dash/features/dashboard/controller/dashboard_controller.dart';
import 'package:softverse_dash/features/dashboard/data/dashboard_repository.dart';
import 'package:softverse_dash/features/dashboard/models/dashboard_item_model.dart';

void main() {
  test('dashboard starts without demo business data', () {
    final controller = DashboardController(
      dashboardRepository: _FakeDashboardRepository(),
    );

    expect(controller.stores.map((store) => store.name), ['All stores']);
    expect(controller.categoryTabs, ['All Item']);
    expect(controller.inventoryProducts, isEmpty);
    expect(controller.totalNetSalesAmount.value, 0);
    expect(controller.salesSummaryGrossSales.value, 0);
    expect(controller.salesSummaryCostOfGoods.value, 0);
    expect(controller.settingsAccountEmail, isNot('softvence@corp.com'));
  });

  test('settings displays the authenticated account email', () async {
    SharedPreferences.setMockInitialValues({'email': 'owner@business.test'});
    await StorageService.init();
    final controller = DashboardController(
      dashboardRepository: _FakeDashboardRepository(),
    );

    expect(controller.settingsAccountEmail, 'owner@business.test');
  });

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
    expect(controller.totalNetSalesAmount.value, 270);
    expect(controller.averageSale.value, 135);
    expect(controller.chartValues, [120, 150]);
    expect(controller.items.single.name, 'Chicken Fry');
    expect(controller.categories.single.name, 'Beverages');
    expect(controller.employees.single.name, 'Owner');
  });

  test('clears all account-owned in-memory state', () {
    final controller = DashboardController(
      dashboardRepository: _FakeDashboardRepository(),
    );
    controller.transactions.value = 3;
    controller.netSales.value = 300;
    controller.totalNetSalesAmount.value = 300;
    controller.chartValues.value = [100, 200];
    controller.items.add(
      const DashboardItemModel(
        name: 'Owned item',
        quantity: 1,
        price: 100,
        imageUrl: '',
      ),
    );

    controller.clearAccountState();

    expect(controller.transactions.value, 0);
    expect(controller.netSales.value, 0);
    expect(controller.totalNetSalesAmount.value, 0);
    expect(controller.chartValues, isEmpty);
    expect(controller.items, isEmpty);
  });

  test(
    'inventory filters are sent to the API and expiry data is retained',
    () async {
      final repository = _FakeDashboardRepository()
        ..inventoryRows = [
          {
            'id': 'item-1',
            'name': 'Milk',
            'sku': 'MILK-1',
            'barcode': 'BAR-1',
            'price': 4,
            'trackStock': true,
            'inStock': 2,
            'lowStock': 3,
            'stockStatus': 'low_stock',
            'trackExpiration': true,
            'expirationDate': '2026-09-20',
            'expirationStatus': 'expiring_soon',
            'categoryName': 'Dairy',
          },
        ];
      final controller = DashboardController(dashboardRepository: repository);

      await controller.selectStockFilter(4);

      expect(repository.lastExpirationStatus, 'expiring_soon');
      expect(repository.lastExpiringSoonDays, 30);
      expect(controller.inventoryProducts.single.expirationDate, isNotNull);
      expect(controller.inventoryProducts.single.barcode, 'BAR-1');
    },
  );

  test('selected real store is persisted and restored', () async {
    SharedPreferences.setMockInitialValues({});
    await StorageService.init();
    final repository = _FakeDashboardRepository()
      ..storeRows = [
        {'id': 'store-1', 'name': 'Uptown', 'isActive': true},
      ];
    final controller = DashboardController(dashboardRepository: repository);

    await controller.refreshStores();
    await controller.selectStore(1);
    expect(StorageService.selectedStoreId, 'store-1');

    final restored = DashboardController(dashboardRepository: repository);
    await restored.refreshStores();
    expect(restored.selectedStore.id, 'store-1');
  });
}

class _FakeDashboardRepository implements DashboardRepository {
  final overviewRanges = <(DateTime, DateTime)>[];
  final categoryRanges = <(DateTime, DateTime)>[];
  final employeeRanges = <(DateTime, DateTime)>[];
  List<Map<String, dynamic>> inventoryRows = [];
  List<Map<String, dynamic>> storeRows = [];
  String? lastExpirationStatus;
  int? lastExpiringSoonDays;

  @override
  Future<ResponseData> fetchOverview(
    DateTime from,
    DateTime to, {
    String? storeId,
  }) async {
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
  Future<ResponseData> fetchCategorySales(
    DateTime from,
    DateTime to, {
    String? storeId,
  }) async {
    categoryRanges.add((from, to));
    return _success({
      'rows': [
        {'categoryName': 'Beverages', 'itemsSold': 18, 'netSales': 180},
      ],
    });
  }

  @override
  Future<ResponseData> fetchEmployeeSales(
    DateTime from,
    DateTime to, {
    String? storeId,
  }) async {
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

  @override
  Future<ResponseData> fetchIdentity() async => _success({
    'user': {'email': 'owner@business.test', 'fullName': 'Owner'},
  });

  @override
  Future<ResponseData> fetchStores() async => _success({'stores': storeRows});

  @override
  Future<ResponseData> fetchCategories() async => _success(<dynamic>[]);

  @override
  Future<ResponseData> fetchInventory({
    String? storeId,
    String? categoryId,
    String? stockStatus,
    String? expirationStatus,
    int? expiringSoonDays,
    String? search,
  }) async {
    lastExpirationStatus = expirationStatus;
    lastExpiringSoonDays = expiringSoonDays;
    return _success({'items': inventoryRows});
  }

  ResponseData _success(dynamic data) => ResponseData(
    isSuccess: true,
    statusCode: 200,
    errorMessage: '',
    responseData: data,
  );
}
