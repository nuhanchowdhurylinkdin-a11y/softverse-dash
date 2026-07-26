import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../core/common/widgets/gradient_list_card.dart';
import '../../controller/dashboard_controller.dart';
import '../../widgets/sales_detail_scaffold.dart';

class SalesByCategoryScreen extends GetView<DashboardController> {
  const SalesByCategoryScreen({super.key});

  static final _wholeAmount = NumberFormat('#,##0');

  @override
  Widget build(BuildContext context) {
    return SalesDetailScaffold(
      controller: controller,
      appBarTitle: 'Sales by Category',
      sectionLabel: 'Category',
      footerTitle: 'Sales By Category',
      footerCountLabel: 'Total Categories- ${controller.categories.length}',
      listItems: [
        for (final category in controller.categories)
          GradientListCard(
            verticalPadding: 16,
            leading: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: category.gradientColors,
                ),
              ),
            ),
            title: category.name,
            subtitle: 'x ${category.quantity}',
            trailingText: '\$${_wholeAmount.format(category.price)}',
          ),
      ],
    );
  }
}
