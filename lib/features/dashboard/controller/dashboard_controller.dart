import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/dashboard_category_model.dart';
import '../models/dashboard_employee_model.dart';
import '../models/dashboard_item_model.dart';
import '../models/inventory_product_model.dart';
import '../models/store_model.dart';
import '../data/dashboard_repository.dart';
import '../../../core/services/network_caller.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/utils/constants/api_constants.dart';
import '../../../core/utils/constants/colors.dart';
import '../../../core/utils/helpers/app_helper.dart';
import '../../../routes/app_routes.dart';

class DashboardController extends GetxController {
  final DashboardRepository _dashboardRepository;
  bool _isFetchingOverview = false;

  DashboardController({DashboardRepository? dashboardRepository})
    : _dashboardRepository = dashboardRepository ?? HttpDashboardRepository();

  static const _categoryGradients = [
    [AppColors.gaugeGreenStart, AppColors.gaugeGreenEnd],
    [AppColors.gaugeYellowStart, AppColors.gaugeYellowEnd],
    [AppColors.gaugePurpleStart, AppColors.gaugePurpleEnd],
  ];

  final selectedNavIndex = 0.obs;

  final selectedDate = _startOfCurrentMonth().obs;
  final selectedPeriodStart = _startOfCurrentMonth().obs;
  final selectedPeriodEnd = _today().obs;

  static DateTime _today() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  static DateTime _startOfCurrentMonth() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, 1);
  }

  DateTimeRange get selectedPeriod => DateTimeRange(
    start: selectedPeriodStart.value,
    end: selectedPeriodEnd.value,
  );

  final stores = const [StoreModel(name: 'All stores')];
  final selectedStoreIndex = 0.obs;

  StoreModel get selectedStore => stores[selectedStoreIndex.value];

  final transactions = 0.obs;
  final transactionsChange = 0.0.obs;

  final netSales = 0.0.obs;
  final netSalesChange = 0.0.obs;

  final averageSale = 0.0.obs;
  final averageSaleChange = 0.0.obs;

  final totalNetSalesAmount = 0.0.obs;

  final salesSummaryGrossSales = 0.0.obs;
  final salesSummaryRefunds = 0.0.obs;
  final salesSummaryDiscounts = 0.0.obs;
  final salesSummaryNetSales = 0.0.obs;
  final salesSummaryTaxes = 0.0.obs;
  final salesSummaryTotalTendered = 0.0.obs;
  final salesSummaryCostOfGoods = 0.0.obs;
  final salesSummaryGrossProfit = 0.0.obs;

  final chartValues = <double>[].obs;
  final chartMaxValue = 10000.0.obs;

  final items = <DashboardItemModel>[].obs;
  final categories = <DashboardCategoryModel>[].obs;
  final employees = <DashboardEmployeeModel>[].obs;

  final stockFilters = const [
    'All Category',
    'Low Stock',
    'Out of Stock',
    'Expire date',
  ];
  final selectedStockFilterIndex = 0.obs;

  final categoryTabs = const ['All Item'];
  final selectedCategoryTabIndex = 0.obs;

  final inventoryProducts = <InventoryProductModel>[].obs;

  List<InventoryProductModel> get filteredInventoryProducts {
    final selectedCategory = selectedCategoryTabIndex.value == 0
        ? null
        : categoryTabs[selectedCategoryTabIndex.value];

    return inventoryProducts.where((product) {
      final matchesCategory =
          selectedCategory == null || product.category == selectedCategory;
      final matchesStock = switch (selectedStockFilterIndex.value) {
        1 => product.stockCount > 0 && product.stockCount < 10,
        2 => product.stockCount <= 0,
        _ => true,
      };
      return matchesCategory && matchesStock;
    }).toList();
  }

  final stockNotificationsEnabled = true.obs;
  final settingsSound = 'SIMToolkitPositiveACK';
  String get settingsAccountEmail => StorageService.email ?? 'Not available';
  final settingsIpAddress = 'Not available';
  final settingsAppVersion = '1.21';

  @override
  void onInit() {
    super.onInit();
    _fetchSalesOverview();
  }

  Future<void> refreshSalesOverview() => _fetchSalesOverview();

  void selectNavIndex(int index) => selectedNavIndex.value = index;

  void selectStockFilter(int index) => selectedStockFilterIndex.value = index;

  void selectCategoryTab(int index) => selectedCategoryTabIndex.value = index;

  void toggleStockNotifications() =>
      stockNotificationsEnabled.value = !stockNotificationsEnabled.value;

  Future<void> logout() async {
    final refreshToken = StorageService.refreshToken;
    if (refreshToken != null) {
      await NetworkCaller().postRequest(
        ApiConstants.logout,
        body: {'refreshToken': refreshToken},
      );
    }
    clearAccountState();
    await StorageService.logoutUser();
    Get.offAllNamed(AppRoute.getLoginScreen());
  }

  void selectStore(int index) => selectedStoreIndex.value = index;

  void clearAccountState() {
    selectedStoreIndex.value = 0;
    transactions.value = 0;
    transactionsChange.value = 0;
    netSales.value = 0;
    netSalesChange.value = 0;
    averageSale.value = 0;
    averageSaleChange.value = 0;
    totalNetSalesAmount.value = 0;
    salesSummaryGrossSales.value = 0;
    salesSummaryRefunds.value = 0;
    salesSummaryDiscounts.value = 0;
    salesSummaryNetSales.value = 0;
    salesSummaryTaxes.value = 0;
    salesSummaryTotalTendered.value = 0;
    salesSummaryCostOfGoods.value = 0;
    salesSummaryGrossProfit.value = 0;
    chartValues.clear();
    chartMaxValue.value = 10000;
    items.clear();
    categories.clear();
    employees.clear();
    inventoryProducts.clear();
    selectedStockFilterIndex.value = 0;
    selectedCategoryTabIndex.value = 0;
  }

  void goToPreviousDay() => _shiftSelectedPeriod(isForward: false);

  void goToNextDay() => _shiftSelectedPeriod(isForward: true);

  void selectDate(DateTime date) {
    final normalizedDate = _dateOnly(date);
    selectedDate.value = normalizedDate;
    selectedPeriodStart.value = normalizedDate;
    selectedPeriodEnd.value = normalizedDate;
    _fetchSalesOverview();
  }

  void selectPeriod(DateTimeRange period) {
    final start = _dateOnly(period.start);
    final end = _dateOnly(period.end);
    selectedPeriodStart.value = start;
    selectedPeriodEnd.value = end;
    selectedDate.value = start;
    _fetchSalesOverview();
  }

  void _shiftSelectedPeriod({required bool isForward}) {
    final days =
        selectedPeriodEnd.value.difference(selectedPeriodStart.value).inDays +
        1;
    final offset = Duration(days: isForward ? days : -days);
    selectPeriod(
      DateTimeRange(
        start: selectedPeriodStart.value.add(offset),
        end: selectedPeriodEnd.value.add(offset),
      ),
    );
  }

  DateTime _dateOnly(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  Future<void> _fetchSalesOverview() async {
    if (_isFetchingOverview) return;
    _isFetchingOverview = true;

    try {
      final from = selectedPeriodStart.value;
      final to = selectedPeriodEnd.value;
      final periodDays = to.difference(from).inDays + 1;
      final previousTo = from.subtract(const Duration(days: 1));
      final previousFrom = previousTo.subtract(Duration(days: periodDays - 1));

      final responses = await Future.wait([
        _dashboardRepository.fetchOverview(from, to),
        _dashboardRepository.fetchOverview(previousFrom, previousTo),
        _dashboardRepository.fetchCategorySales(from, to),
        _dashboardRepository.fetchEmployeeSales(from, to),
      ]);

      final current = responses[0];
      final previous = responses[1];
      final categorySales = responses[2];
      final employeeSales = responses[3];

      if (!current.isSuccess) {
        AppHelperFunctions.showErrorSnackBar(current.errorMessage);
        return;
      }
      _applyOverview(Map<String, dynamic>.from(current.responseData as Map));

      if (previous.isSuccess && previous.responseData is Map) {
        _applyPreviousPeriodChange(
          Map<String, dynamic>.from(previous.responseData as Map),
        );
      }
      if (categorySales.isSuccess && categorySales.responseData is Map) {
        _applyCategorySales(
          Map<String, dynamic>.from(categorySales.responseData as Map),
        );
      }
      if (employeeSales.isSuccess && employeeSales.responseData is Map) {
        _applyEmployeeSales(
          Map<String, dynamic>.from(employeeSales.responseData as Map),
        );
      }
    } finally {
      _isFetchingOverview = false;
    }
  }

  void _applyOverview(Map<String, dynamic> data) {
    final cards = Map<String, dynamic>.from(data['cards'] as Map);
    transactions.value = (cards['transactionCount'] as num?)?.toInt() ?? 0;
    netSales.value = (cards['netSales'] as num?)?.toDouble() ?? 0;
    totalNetSalesAmount.value = netSales.value;
    averageSale.value = (cards['averageSale'] as num?)?.toDouble() ?? 0;

    final chart = (data['chart'] as List? ?? const []).map((point) {
      final row = Map<String, dynamic>.from(point as Map);
      return (row['value'] as num?)?.toDouble() ?? 0.0;
    }).toList();
    chartValues.value = chart;
    chartMaxValue.value = chart.isEmpty
        ? 10000.0
        : (chart.reduce((a, b) => a > b ? a : b) * 1.2).clamp(
            1.0,
            double.infinity,
          );

    items.value = (data['topSellingItems'] as List? ?? const []).map((raw) {
      final row = Map<String, dynamic>.from(raw as Map);
      return DashboardItemModel(
        name: row['name']?.toString() ?? '',
        quantity: (row['quantity'] as num?)?.toInt() ?? 0,
        price: (row['sales'] as num?)?.toDouble() ?? 0,
        imageUrl: ApiConstants.resolveAssetUrl(row['imageUrl']?.toString()),
      );
    }).toList();
  }

  void _applyPreviousPeriodChange(Map<String, dynamic> data) {
    final cards = Map<String, dynamic>.from(data['cards'] as Map);
    final previousTransactions =
        (cards['transactionCount'] as num?)?.toDouble() ?? 0;
    final previousNetSales = (cards['netSales'] as num?)?.toDouble() ?? 0;
    final previousAverageSale = (cards['averageSale'] as num?)?.toDouble() ?? 0;

    transactionsChange.value = _percentChange(
      previousTransactions,
      transactions.value.toDouble(),
    );
    netSalesChange.value = _percentChange(previousNetSales, netSales.value);
    averageSaleChange.value = _percentChange(
      previousAverageSale,
      averageSale.value,
    );
  }

  void _applyCategorySales(Map<String, dynamic> data) {
    final rows = (data['rows'] as List? ?? const [])
        .map((raw) => Map<String, dynamic>.from(raw as Map))
        .toList();
    categories.value = [
      for (var i = 0; i < rows.length; i++)
        DashboardCategoryModel(
          name: rows[i]['categoryName']?.toString() ?? 'Uncategorized',
          quantity: (rows[i]['itemsSold'] as num?)?.toInt() ?? 0,
          price: (rows[i]['netSales'] as num?)?.toDouble() ?? 0,
          gradientColors: _categoryGradients[i % _categoryGradients.length],
        ),
    ];
  }

  void _applyEmployeeSales(Map<String, dynamic> data) {
    employees.value = (data['rows'] as List? ?? const []).map((raw) {
      final row = Map<String, dynamic>.from(raw as Map);
      final receipts = (row['receipts'] as num?)?.toInt() ?? 0;
      return DashboardEmployeeModel(
        name: row['employeeName']?.toString() ?? 'Unknown',
        posLabel: '$receipts sale${receipts == 1 ? '' : 's'}',
        earnings: (row['netSales'] as num?)?.toDouble() ?? 0,
        avatarUrl: ApiConstants.resolveAssetUrl(row['avatarUrl']?.toString()),
      );
    }).toList();
  }

  double _percentChange(double previous, double current) {
    if (previous == 0) return current == 0 ? 0 : 100;
    return double.parse(
      (((current - previous) / previous) * 100).toStringAsFixed(2),
    );
  }
}
