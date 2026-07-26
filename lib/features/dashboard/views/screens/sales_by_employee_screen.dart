import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../core/common/widgets/app_network_image.dart';
import '../../../../core/common/widgets/gradient_list_card.dart';
import '../../controller/dashboard_controller.dart';
import '../../widgets/sales_detail_scaffold.dart';

class SalesByEmployeeScreen extends GetView<DashboardController> {
  const SalesByEmployeeScreen({super.key});

  static final _decimalAmount = NumberFormat('#,##0.00');

  @override
  Widget build(BuildContext context) {
    return SalesDetailScaffold(
      controller: controller,
      appBarTitle: 'Sales by Employee',
      sectionLabel: 'Employee',
      footerTitle: 'Sales By Employee',
      footerCountLabel: 'Total Employees- ${controller.employees.length}',
      listItems: [
        for (final employee in controller.employees)
          GradientListCard(
            verticalPadding: 16,
            leading: AppNetworkImage(
              url: employee.avatarUrl,
              width: 55.w,
              height: 55.w,
            ),
            title: employee.name,
            subtitle: employee.posLabel,
            trailingText: '\$${_decimalAmount.format(employee.earnings)}',
          ),
      ],
    );
  }
}
