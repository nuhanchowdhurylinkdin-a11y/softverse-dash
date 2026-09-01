import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../core/common/widgets/gradient_list_card.dart';
import '../../../../core/utils/constants/colors.dart';
import '../../controller/dashboard_controller.dart';
import '../../widgets/sales_detail_scaffold.dart';

class SalesByCategoryScreen extends StatefulWidget {
  const SalesByCategoryScreen({super.key});

  @override
  State<SalesByCategoryScreen> createState() => _SalesByCategoryScreenState();
}

class _SalesByCategoryScreenState extends State<SalesByCategoryScreen> {
  final controller = Get.find<DashboardController>();
  static final _quantity = NumberFormat('#,##0.##');
  static final _amount = NumberFormat('#,##0.00');
  static const _gradients = [
    [AppColors.gaugeGreenStart, AppColors.gaugeGreenEnd],
    [AppColors.gaugeYellowStart, AppColors.gaugeYellowEnd],
    [AppColors.gaugePurpleStart, AppColors.gaugePurpleEnd],
  ];

  @override
  void initState() {
    super.initState();
    controller.openReport(SalesReportKind.category);
  }

  @override
  void dispose() {
    if (controller.activeReport.value == SalesReportKind.category) {
      controller.closeReport();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Obx(
    () => SalesDetailScaffold(
      controller: controller,
      appBarTitle: 'Sales by Category',
      sectionLabel: 'Category',
      footerTitle: 'Sales By Category',
      footerCountLabel: 'Total Categories - ${controller.reportTotal.value}',
      footerAmount:
          '${controller.currencySymbol}${_amount.format(controller.reportNetSales.value)}',
      isLoading: controller.isReportLoading.value,
      error: controller.reportError.value,
      hasMore: controller.canLoadMoreReport,
      onRefresh: controller.refreshActiveReport,
      onLoadMore: () => controller.refreshActiveReport(loadMore: true),
      listItems: [
        for (var index = 0; index < controller.reportCategories.length; index++)
          GradientListCard(
            verticalPadding: 16,
            leading: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: _gradients[index % _gradients.length],
                ),
              ),
            ),
            title: controller.reportCategories[index].name,
            subtitle:
                'x ${_quantity.format(controller.reportCategories[index].itemsSold)}',
            trailingText:
                '${controller.currencySymbol}${_amount.format(controller.reportCategories[index].netSales)}',
          ),
      ],
    ),
  );
}
