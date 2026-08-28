import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/dashboard_category_model.dart';
import '../models/dashboard_employee_model.dart';
import '../models/dashboard_item_model.dart';
import '../models/inventory_product_model.dart';
import '../models/store_model.dart';
import '../../../core/utils/constants/colors.dart';

class DashboardController extends GetxController {
  final selectedNavIndex = 0.obs;

  final selectedDate = DateTime(DateTime.now().year, 6, 28).obs;
  final selectedPeriodStart = DateTime(DateTime.now().year, 6, 28).obs;
  final selectedPeriodEnd = DateTime(DateTime.now().year, 6, 28).obs;

  DateTimeRange get selectedPeriod => DateTimeRange(
    start: selectedPeriodStart.value,
    end: selectedPeriodEnd.value,
  );

  final stores = const [
    StoreModel(name: 'Downtown'),
    StoreModel(name: 'Mall Branch'),
    StoreModel(name: 'Airport'),
  ];
  final selectedStoreIndex = 0.obs;

  StoreModel get selectedStore => stores[selectedStoreIndex.value];

  final transactions = 3.obs;
  final transactionsChange = (-70.0).obs;

  final netSales = 760.00.obs;
  final netSalesChange = 22.55.obs;

  final averageSale = 1760.00.obs;
  final averageSaleChange = 308.51.obs;

  final totalNetSalesAmount = 17510.00.obs;

  final salesSummaryGrossSales = 5760.00.obs;
  final salesSummaryRefunds = 0.00.obs;
  final salesSummaryDiscounts = 0.00.obs;
  final salesSummaryNetSales = 5760.00.obs;
  final salesSummaryTaxes = 0.00.obs;
  final salesSummaryTotalTendered = 5760.00.obs;
  final salesSummaryCostOfGoods = 5115.20.obs;
  final salesSummaryGrossProfit = 644.80.obs;

  final chartValues = const [8300.0, 3400.0];

  final items = const [
    DashboardItemModel(
      name: 'A4Ttech Mouse',
      quantity: 1,
      price: 400,
      imageUrl: 'https://picsum.photos/seed/a4tech-mouse/200',
    ),
    DashboardItemModel(
      name: 'HP Monitor',
      quantity: 1,
      price: 18000,
      imageUrl: 'https://picsum.photos/seed/hp-monitor/200',
    ),
    DashboardItemModel(
      name: 'HP Monitor',
      quantity: 1,
      price: 18000,
      imageUrl: 'https://picsum.photos/seed/hp-monitor/200',
    ),
    DashboardItemModel(
      name: 'HP Monitor',
      quantity: 1,
      price: 18000,
      imageUrl: 'https://picsum.photos/seed/hp-monitor/200',
    ),
  ];

  final categories = const [
    DashboardCategoryModel(
      name: 'External',
      quantity: 2,
      price: 400,
      gradientColors: [AppColors.gaugeGreenStart, AppColors.gaugeGreenEnd],
    ),
    DashboardCategoryModel(
      name: 'Computer',
      quantity: 5,
      price: 18000,
      gradientColors: [AppColors.gaugeYellowStart, AppColors.gaugeYellowEnd],
    ),
  ];

  final employees = const [
    DashboardEmployeeModel(
      name: 'Maxwell',
      posLabel: 'POS-1',
      earnings: 5760.00,
      avatarUrl: 'https://picsum.photos/seed/maxwell/200',
    ),
    DashboardEmployeeModel(
      name: 'Oliver',
      posLabel: 'POS-2',
      earnings: 4257.00,
      avatarUrl: 'https://picsum.photos/seed/oliver/200',
    ),
  ];

  final stockFilters = const [
    'All Category',
    'Low Stock',
    'Out of Stock',
    'Expire date',
  ];
  final selectedStockFilterIndex = 0.obs;

  final categoryTabs = const [
    'All Item',
    'PC Components',
    'Monitor & Display',
    'Input Devices',
    'Audio',
    'Gaming Accessories',
    'Networking',
    'Laptop & Accessories',
    'Storage Devices',
    'Printers & Office',
    'Cables & Adapters',
    'Software & Licenses',
  ];
  final selectedCategoryTabIndex = 0.obs;

  final inventoryProducts = const [
    InventoryProductModel(
      name: 'A4Ttech Keyboard',
      sku: 'SKU-10012',
      price: 800,
      imageUrl: 'https://picsum.photos/seed/a4tech-keyboard-1/200',
      stockCount: 97,
      category: 'PC Components',
    ),
    InventoryProductModel(
      name: 'A4Ttech Keyboard',
      sku: 'SKU-10012',
      price: 800,
      imageUrl: 'https://picsum.photos/seed/a4tech-keyboard-2/200',
      stockCount: 9,
      category: 'PC Components',
    ),
    InventoryProductModel(
      name: 'A4Ttech Mouse',
      sku: 'SKU-10012',
      price: 400,
      imageUrl: 'https://picsum.photos/seed/a4tech-mouse-1/200',
      stockCount: 97,
      category: 'PC Components',
    ),
    InventoryProductModel(
      name: 'A4Ttech Mouse',
      sku: 'SKU-10012',
      price: 400,
      imageUrl: 'https://picsum.photos/seed/a4tech-mouse-2/200',
      stockCount: 97,
      category: 'PC Components',
    ),
    InventoryProductModel(
      name: 'HP Monitor',
      sku: 'SKU-10012',
      price: 18000,
      imageUrl: 'https://picsum.photos/seed/hp-monitor-1/200',
      stockCount: 7,
      category: 'Monitor & Display',
    ),
    InventoryProductModel(
      name: 'HP Monitor',
      sku: 'SKU-10012',
      price: 18000,
      imageUrl: 'https://picsum.photos/seed/hp-monitor-2/200',
      stockCount: 0,
      category: 'Monitor & Display',
    ),
    InventoryProductModel(
      name: 'HP Monitor',
      sku: 'SKU-10012',
      price: 18000,
      imageUrl: 'https://picsum.photos/seed/hp-monitor-3/200',
      stockCount: 97,
      category: 'Monitor & Display',
    ),
    InventoryProductModel(
      name: 'HP Monitor',
      sku: 'SKU-10012',
      price: 18000,
      imageUrl: 'https://picsum.photos/seed/hp-monitor-4/200',
      stockCount: 0,
      category: 'Monitor & Display',
    ),
  ];

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
  final settingsAccountEmail = 'softvence@corp.com';
  final settingsIpAddress = '192.152.11.145';
  final settingsAppVersion = '1.21';

  void selectNavIndex(int index) => selectedNavIndex.value = index;

  void selectStockFilter(int index) => selectedStockFilterIndex.value = index;

  void selectCategoryTab(int index) => selectedCategoryTabIndex.value = index;

  void toggleStockNotifications() =>
      stockNotificationsEnabled.value = !stockNotificationsEnabled.value;

  void selectStore(int index) => selectedStoreIndex.value = index;

  void goToPreviousDay() => _shiftSelectedPeriod(isForward: false);

  void goToNextDay() => _shiftSelectedPeriod(isForward: true);

  void selectDate(DateTime date) {
    final normalizedDate = _dateOnly(date);
    selectedDate.value = normalizedDate;
    selectedPeriodStart.value = normalizedDate;
    selectedPeriodEnd.value = normalizedDate;
  }

  void selectPeriod(DateTimeRange period) {
    final start = _dateOnly(period.start);
    final end = _dateOnly(period.end);
    selectedPeriodStart.value = start;
    selectedPeriodEnd.value = end;
    selectedDate.value = start;
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
}
