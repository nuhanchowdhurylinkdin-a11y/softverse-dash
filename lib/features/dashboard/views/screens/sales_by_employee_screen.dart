import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../core/common/widgets/app_network_image.dart';
import '../../../../core/common/widgets/gradient_list_card.dart';
import '../../controller/dashboard_controller.dart';
import '../../widgets/sales_detail_scaffold.dart';

class SalesByEmployeeScreen extends StatefulWidget {
  const SalesByEmployeeScreen({super.key});

  @override
  State<SalesByEmployeeScreen> createState() => _SalesByEmployeeScreenState();
}

class _SalesByEmployeeScreenState extends State<SalesByEmployeeScreen> {
  final controller = Get.find<DashboardController>();
  static final _amount = NumberFormat('#,##0.00');

  @override
  void initState() {
    super.initState();
    controller.openReport(SalesReportKind.employee);
  }

  @override
  void dispose() {
    if (controller.activeReport.value == SalesReportKind.employee) {
      controller.closeReport();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Obx(
    () => SalesDetailScaffold(
      controller: controller,
      appBarTitle: 'Sales by Employee',
      sectionLabel: 'Employee',
      footerTitle: 'Sales By Employee',
      footerCountLabel: 'Total Employees - ${controller.reportTotal.value}',
      footerAmount:
          '${controller.currencySymbol}${_amount.format(controller.reportNetSales.value)}',
      isLoading: controller.isReportLoading.value,
      error: controller.reportError.value,
      hasMore: controller.canLoadMoreReport,
      onRefresh: controller.refreshActiveReport,
      onLoadMore: () => controller.refreshActiveReport(loadMore: true),
      listItems: [
        for (final employee in controller.reportEmployees)
          GradientListCard(
            verticalPadding: 16,
            leading: AppNetworkImage(
              url: employee.avatarUrl,
              width: 55.w,
              height: 55.w,
            ),
            title: employee.name,
            subtitle:
                '${employee.receipts} sale${employee.receipts == 1 ? '' : 's'}',
            trailingText:
                '${controller.currencySymbol}${_amount.format(employee.netSales)}',
          ),
      ],
    ),
  );
}
