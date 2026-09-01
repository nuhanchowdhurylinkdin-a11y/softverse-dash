import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../core/common/widgets/app_network_image.dart';
import '../../../../core/common/widgets/gradient_list_card.dart';
import '../../controller/dashboard_controller.dart';
import '../../widgets/sales_detail_scaffold.dart';

class SalesByItemScreen extends StatefulWidget {
  const SalesByItemScreen({super.key});

  @override
  State<SalesByItemScreen> createState() => _SalesByItemScreenState();
}

class _SalesByItemScreenState extends State<SalesByItemScreen> {
  final controller = Get.find<DashboardController>();
  static final _quantity = NumberFormat('#,##0.##');
  static final _amount = NumberFormat('#,##0.00');

  @override
  void initState() {
    super.initState();
    controller.openReport(SalesReportKind.item);
  }

  @override
  void dispose() {
    if (controller.activeReport.value == SalesReportKind.item) {
      controller.closeReport();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Obx(
    () => SalesDetailScaffold(
      controller: controller,
      appBarTitle: 'Sales by Item',
      sectionLabel: 'Items',
      footerTitle: 'Sales By Items',
      footerCountLabel: 'Total Items - ${controller.reportTotal.value}',
      footerAmount:
          '${controller.currencySymbol}${_amount.format(controller.reportNetSales.value)}',
      isLoading: controller.isReportLoading.value,
      error: controller.reportError.value,
      hasMore: controller.canLoadMoreReport,
      onRefresh: controller.refreshActiveReport,
      onLoadMore: () => controller.refreshActiveReport(loadMore: true),
      listItems: [
        for (final item in controller.reportItems)
          GradientListCard(
            leading: AppNetworkImage(
              url: item.imageUrl,
              width: 55.w,
              height: 55.w,
            ),
            title: item.name,
            subtitle: 'x ${_quantity.format(item.quantitySold)}',
            trailingText:
                '${controller.currencySymbol}${_amount.format(item.netSales)}',
          ),
      ],
    ),
  );
}
