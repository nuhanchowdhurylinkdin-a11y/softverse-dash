import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/dashboard_category_model.dart';
import '../models/dashboard_employee_model.dart';
import '../models/dashboard_item_model.dart';
import '../models/inventory_product_model.dart';
import '../models/sales_report_models.dart';
import '../models/store_model.dart';
import '../data/dashboard_repository.dart';
import '../widgets/inventory_product_details_sheet.dart';
import '../../../core/services/network_caller.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/utils/constants/api_constants.dart';
import '../../../core/utils/constants/colors.dart';
import '../../../core/utils/helpers/app_helper.dart';
import '../../../routes/app_routes.dart';

enum SalesReportKind { item, category, employee, summary }

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

  final stores = <StoreModel>[const StoreModel(name: 'All stores')].obs;
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
  final reportItems = <ItemSalesReportRow>[].obs;
  final reportCategories = <CategorySalesReportRow>[].obs;
  final reportEmployees = <EmployeeSalesReportRow>[].obs;
  final reportTotal = 0.obs;
  final reportNetSales = 0.0.obs;
  final isReportLoading = false.obs;
  final reportError = RxnString();
  final activeReport = Rxn<SalesReportKind>();
  final currencyCode = ''.obs;
  static const reportPageSize = 20;

  String get currencySymbol => switch (currencyCode.value.toUpperCase()) {
    'USD' => r'$',
    'EUR' => '€',
    'GBP' => '£',
    'BDT' => '৳',
    'INR' => '₹',
    final code when code.isNotEmpty => '$code ',
    _ => '',
  };

  String money(num value, {int decimals = 2}) =>
      '$currencySymbol${value.toStringAsFixed(decimals)}';

  final chartValues = <double>[].obs;
  final chartMaxValue = 10000.0.obs;

  final items = <DashboardItemModel>[].obs;
  final categories = <DashboardCategoryModel>[].obs;
  final employees = <DashboardEmployeeModel>[].obs;

  final stockFilters = const [
    'All Category',
    'Low Stock',
    'Out of Stock',
    'Expired',
    'Expiring in 30 days',
  ];
  final selectedStockFilterIndex = 0.obs;

  final categoryTabs = <String>['All Item'].obs;
  final categoryIds = <String?>[null].obs;
  final selectedCategoryTabIndex = 0.obs;

  final inventoryProducts = <InventoryProductModel>[].obs;
  final isInventoryLoading = false.obs;
  final inventoryError = RxnString();
  final accountEmail = (StorageService.email ?? '').obs;

  List<InventoryProductModel> get filteredInventoryProducts =>
      inventoryProducts.toList(growable: false);

  final stockNotificationsEnabled = true.obs;
  final settingsSound = 'SIMToolkitPositiveACK';
  String get settingsAccountEmail =>
      accountEmail.value.isEmpty ? 'Not available' : accountEmail.value;
  final settingsIpAddress = 'Not available';
  final settingsAppVersion = '1.21';

  @override
  void onInit() {
    super.onInit();
    unawaited(_loadIdentityAndStores());
    _fetchSalesOverview();
  }

  Future<void> refreshSalesOverview() => _fetchSalesOverview();

  void selectNavIndex(int index) {
    selectedNavIndex.value = index;
    if (index == 1) unawaited(refreshInventory());
    if (index == 2) unawaited(refreshIdentity());
  }

  Future<void> selectStockFilter(int index) async {
    selectedStockFilterIndex.value = index;
    await refreshInventory();
  }

  Future<void> selectCategoryTab(int index) async {
    selectedCategoryTabIndex.value = index;
    await refreshInventory();
  }

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

  Future<void> selectStore(int index) async {
    if (index < 0 || index >= stores.length) return;
    selectedStoreIndex.value = index;
    await StorageService.setSelectedStoreId(selectedStore.id);
    await Future.wait([
      _fetchSalesOverview(),
      refreshInventory(),
      refreshActiveReport(),
    ]);
  }

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
    _clearReportState();
    chartValues.clear();
    chartMaxValue.value = 10000;
    items.clear();
    categories.clear();
    employees.clear();
    stores.assignAll([const StoreModel(name: 'All stores')]);
    categoryTabs.assignAll(['All Item']);
    categoryIds.assignAll([null]);
    inventoryProducts.clear();
    selectedStockFilterIndex.value = 0;
    selectedCategoryTabIndex.value = 0;
    inventoryError.value = null;
    accountEmail.value = '';
  }

  Future<void> _loadIdentityAndStores() async {
    await Future.wait([
      refreshIdentity(),
      refreshStores(),
      refreshCategories(),
    ]);
  }

  Future<void> refreshIdentity() async {
    final response = await _dashboardRepository.fetchIdentity();
    if (!response.isSuccess || response.responseData is! Map) return;
    final root = Map<String, dynamic>.from(response.responseData as Map);
    final user = root['user'] is Map
        ? Map<String, dynamic>.from(root['user'] as Map)
        : root;
    final email = user['email']?.toString().trim() ?? '';
    final name =
        user['fullName']?.toString().trim() ??
        user['name']?.toString().trim() ??
        '';
    currencyCode.value = user['currency']?.toString().trim() ?? '';
    if (email.isEmpty) return;
    accountEmail.value = email;
    await StorageService.updateIdentity(fullName: name, email: email);
  }

  Future<void> refreshStores() async {
    final response = await _dashboardRepository.fetchStores();
    if (!response.isSuccess || response.responseData is! Map) return;
    final data = Map<String, dynamic>.from(response.responseData as Map);
    final activeStores = (data['stores'] as List? ?? const [])
        .whereType<Map>()
        .where((row) => row['isActive'] != false)
        .map(
          (row) => StoreModel(
            id: row['id']?.toString(),
            name: row['name']?.toString() ?? 'Unnamed store',
          ),
        )
        .where((store) => store.id != null)
        .toList();
    final selectedId = StorageService.selectedStoreId ?? selectedStore.id;
    selectedStoreIndex.value = 0;
    stores.assignAll([const StoreModel(name: 'All stores'), ...activeStores]);
    final nextIndex = stores.indexWhere((store) => store.id == selectedId);
    selectedStoreIndex.value = nextIndex < 0 ? 0 : nextIndex;
    if (nextIndex < 0 && selectedId != null) {
      await StorageService.setSelectedStoreId(null);
    }
  }

  Future<void> refreshCategories() async {
    final response = await _dashboardRepository.fetchCategories();
    if (!response.isSuccess || response.responseData is! List) return;
    final rows = (response.responseData as List).whereType<Map>().toList();
    categoryTabs.assignAll([
      'All Item',
      ...rows.map((row) => row['name']?.toString() ?? 'Unnamed category'),
    ]);
    categoryIds.assignAll([null, ...rows.map((row) => row['id']?.toString())]);
    if (selectedCategoryTabIndex.value >= categoryTabs.length) {
      selectedCategoryTabIndex.value = 0;
    }
  }

  Future<void> refreshInventory({String? search}) async {
    isInventoryLoading.value = true;
    inventoryError.value = null;
    final stockIndex = selectedStockFilterIndex.value;
    final response = await _dashboardRepository.fetchInventory(
      storeId: selectedStore.id,
      categoryId: selectedCategoryTabIndex.value < categoryIds.length
          ? categoryIds[selectedCategoryTabIndex.value]
          : null,
      stockStatus: switch (stockIndex) {
        1 => 'low_stock',
        2 => 'out_of_stock',
        _ => null,
      },
      expirationStatus: switch (stockIndex) {
        3 => 'expired',
        4 => 'expiring_soon',
        _ => null,
      },
      expiringSoonDays: stockIndex == 4 ? 30 : null,
      search: search,
    );
    isInventoryLoading.value = false;
    if (!response.isSuccess || response.responseData is! Map) {
      inventoryError.value = response.errorMessage.isEmpty
          ? 'Unable to load inventory.'
          : response.errorMessage;
      return;
    }
    final data = Map<String, dynamic>.from(response.responseData as Map);
    final products = (data['items'] as List? ?? const [])
        .whereType<Map>()
        .map(
          (row) =>
              InventoryProductModel.fromApi(Map<String, dynamic>.from(row)),
        )
        .where((item) => stockIndex < 3 || item.expirationDate != null)
        .toList();
    inventoryProducts.assignAll(products);
  }

  Future<void> openInventorySearch() async {
    selectedStockFilterIndex.value = 0;
    selectedCategoryTabIndex.value = 0;
    await Get.toNamed<void>(AppRoute.getInventorySearchScreen());
    await refreshInventory();
  }

  Future<void> openInventoryScanner() async {
    final barcode = await Get.toNamed<String>(AppRoute.getScanBarcodeScreen());
    if (barcode == null || barcode.isEmpty) return;
    selectedStockFilterIndex.value = 0;
    selectedCategoryTabIndex.value = 0;
    await refreshInventory(search: barcode);
    if (inventoryProducts.isEmpty) {
      AppHelperFunctions.showWarningSnackBar(
        'No item found for barcode $barcode.',
      );
      return;
    }
    showInventoryProductDetails(inventoryProducts.first);
  }

  void openInventoryProduct(InventoryProductModel product) =>
      showInventoryProductDetails(product);

  Future<void> openReport(SalesReportKind kind) async {
    activeReport.value = kind;
    await refreshActiveReport();
  }

  void closeReport() {
    activeReport.value = null;
    _clearReportState();
  }

  bool get canLoadMoreReport {
    final loaded = switch (activeReport.value) {
      SalesReportKind.item => reportItems.length,
      SalesReportKind.category => reportCategories.length,
      SalesReportKind.employee => reportEmployees.length,
      _ => reportTotal.value,
    };
    return loaded < reportTotal.value;
  }

  Future<void> refreshActiveReport({bool loadMore = false}) async {
    final kind = activeReport.value;
    if (kind == null || isReportLoading.value) return;
    final currentLength = switch (kind) {
      SalesReportKind.item => reportItems.length,
      SalesReportKind.category => reportCategories.length,
      SalesReportKind.employee => reportEmployees.length,
      SalesReportKind.summary => 0,
    };
    final offset = loadMore ? currentLength : 0;
    if (!loadMore) {
      _clearReportRows();
      reportError.value = null;
    }
    isReportLoading.value = true;
    final response = await switch (kind) {
      SalesReportKind.item => _dashboardRepository.fetchItemSales(
        selectedPeriodStart.value,
        selectedPeriodEnd.value,
        storeId: selectedStore.id,
        limit: reportPageSize,
        offset: offset,
      ),
      SalesReportKind.category => _dashboardRepository.fetchCategorySalesPage(
        selectedPeriodStart.value,
        selectedPeriodEnd.value,
        storeId: selectedStore.id,
        limit: reportPageSize,
        offset: offset,
      ),
      SalesReportKind.employee => _dashboardRepository.fetchEmployeeSalesPage(
        selectedPeriodStart.value,
        selectedPeriodEnd.value,
        storeId: selectedStore.id,
        limit: reportPageSize,
        offset: offset,
      ),
      SalesReportKind.summary => _dashboardRepository.fetchSalesSummary(
        selectedPeriodStart.value,
        selectedPeriodEnd.value,
        storeId: selectedStore.id,
      ),
    };
    isReportLoading.value = false;
    if (!response.isSuccess || response.responseData is! Map) {
      reportError.value = response.errorMessage.isEmpty
          ? 'Unable to load this report.'
          : response.errorMessage;
      return;
    }
    final data = Map<String, dynamic>.from(response.responseData as Map);
    _applyReport(kind, data, append: loadMore);
  }

  void _applyReport(
    SalesReportKind kind,
    Map<String, dynamic> data, {
    required bool append,
  }) {
    final rows = (data['rows'] as List? ?? const [])
        .whereType<Map>()
        .map((row) => Map<String, dynamic>.from(row))
        .toList();
    final totals = data['totals'] is Map
        ? Map<String, dynamic>.from(data['totals'] as Map)
        : <String, dynamic>{};
    reportTotal.value = (data['total'] as num?)?.toInt() ?? rows.length;
    reportNetSales.value = (totals['netSales'] as num?)?.toDouble() ?? 0;
    if (kind == SalesReportKind.item) {
      final mapped = rows
          .map(
            (row) => ItemSalesReportRow(
              id: row['itemId']?.toString() ?? '',
              name: row['itemName']?.toString() ?? 'Unnamed item',
              imageUrl: ApiConstants.resolveAssetUrl(
                row['imageUrl']?.toString(),
              ),
              quantitySold: (row['quantitySold'] as num?)?.toDouble() ?? 0,
              netSales: (row['netSales'] as num?)?.toDouble() ?? 0,
            ),
          )
          .toList();
      append ? reportItems.addAll(mapped) : reportItems.assignAll(mapped);
    } else if (kind == SalesReportKind.category) {
      final mapped = rows
          .map(
            (row) => CategorySalesReportRow(
              id: row['categoryId']?.toString(),
              name: row['categoryName']?.toString() ?? 'Uncategorized',
              itemsSold: (row['itemsSold'] as num?)?.toDouble() ?? 0,
              netSales: (row['netSales'] as num?)?.toDouble() ?? 0,
            ),
          )
          .toList();
      append
          ? reportCategories.addAll(mapped)
          : reportCategories.assignAll(mapped);
    } else if (kind == SalesReportKind.employee) {
      final mapped = rows
          .map(
            (row) => EmployeeSalesReportRow(
              id: row['employeeId']?.toString() ?? '',
              name: row['employeeName']?.toString() ?? 'Unknown employee',
              avatarUrl: ApiConstants.resolveAssetUrl(
                row['avatarUrl']?.toString(),
              ),
              receipts: (row['receipts'] as num?)?.toInt() ?? 0,
              netSales: (row['netSales'] as num?)?.toDouble() ?? 0,
            ),
          )
          .toList();
      append
          ? reportEmployees.addAll(mapped)
          : reportEmployees.assignAll(mapped);
    } else {
      salesSummaryGrossSales.value =
          (totals['grossSales'] as num?)?.toDouble() ?? 0;
      salesSummaryRefunds.value = (totals['refunds'] as num?)?.toDouble() ?? 0;
      salesSummaryDiscounts.value =
          (totals['discounts'] as num?)?.toDouble() ?? 0;
      salesSummaryNetSales.value = reportNetSales.value;
      salesSummaryTaxes.value = (totals['taxes'] as num?)?.toDouble() ?? 0;
      salesSummaryTotalTendered.value =
          (totals['totalTendered'] as num?)?.toDouble() ?? 0;
      salesSummaryCostOfGoods.value =
          (totals['costOfGoods'] as num?)?.toDouble() ?? 0;
      salesSummaryGrossProfit.value =
          (totals['grossProfit'] as num?)?.toDouble() ?? 0;
    }
  }

  void _clearReportRows() {
    reportItems.clear();
    reportCategories.clear();
    reportEmployees.clear();
    reportTotal.value = 0;
    reportNetSales.value = 0;
    salesSummaryGrossSales.value = 0;
    salesSummaryRefunds.value = 0;
    salesSummaryDiscounts.value = 0;
    salesSummaryNetSales.value = 0;
    salesSummaryTaxes.value = 0;
    salesSummaryTotalTendered.value = 0;
    salesSummaryCostOfGoods.value = 0;
    salesSummaryGrossProfit.value = 0;
  }

  void _clearReportState() {
    _clearReportRows();
    activeReport.value = null;
    reportError.value = null;
    isReportLoading.value = false;
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
    unawaited(refreshActiveReport());
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
      final storeId = selectedStore.id;

      final responses = await Future.wait([
        _dashboardRepository.fetchOverview(from, to, storeId: storeId),
        _dashboardRepository.fetchOverview(
          previousFrom,
          previousTo,
          storeId: storeId,
        ),
        _dashboardRepository.fetchCategorySales(from, to, storeId: storeId),
        _dashboardRepository.fetchEmployeeSales(from, to, storeId: storeId),
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
