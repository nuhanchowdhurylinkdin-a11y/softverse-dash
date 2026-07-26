import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../core/common/widgets/app_network_image.dart';
import '../../../../core/common/widgets/gradient_list_card.dart';
import '../../controller/dashboard_controller.dart';
import '../../widgets/sales_detail_scaffold.dart';

class SalesByItemScreen extends GetView<DashboardController> {
  const SalesByItemScreen({super.key});

  static final _wholeAmount = NumberFormat('#,##0');

  @override
  Widget build(BuildContext context) {
    return SalesDetailScaffold(
      controller: controller,
      appBarTitle: 'Sales by Item',
      sectionLabel: 'Items',
      footerTitle: 'Sales By Items',
      footerCountLabel: 'Total Item- ${controller.items.length}',
      listItems: [
        for (final item in controller.items)
          GradientListCard(
            leading: AppNetworkImage(
              url: item.imageUrl,
              width: 55.w,
              height: 55.w,
            ),
            title: item.name,
            subtitle: 'x ${item.quantity}',
            trailingText: '\$${_wholeAmount.format(item.price)}',
          ),
      ],
    );
  }
}
