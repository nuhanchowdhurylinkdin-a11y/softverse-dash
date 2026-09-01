import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../core/common/widgets/app_network_image.dart';
import '../../../../core/common/widgets/gradient_list_card.dart';
import '../../../../routes/app_routes.dart';
import '../../controller/dashboard_controller.dart';
import '../../widgets/dashboard_app_bar.dart';
import '../../widgets/dashboard_bottom_nav.dart';
import '../../widgets/dashboard_list_section.dart';
import '../../widgets/inventory_tab_view.dart';
import '../../widgets/sales_bar_chart.dart';
import '../../widgets/sales_summary_section.dart';
import '../../widgets/settings_tab_view.dart';

class DashboardScreen extends GetView<DashboardController> {
  const DashboardScreen({super.key});

  static const _sectionGap = 22.0;
  static final _wholeAmount = NumberFormat('#,##0');
  static final _decimalAmount = NumberFormat('#,##0.00');

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Obx(() {
        final navIndex = controller.selectedNavIndex.value;
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: DashboardAppBar(
            controller: controller,
            selectedIndex: navIndex,
          ),
          body: switch (navIndex) {
            1 => InventoryTabView(controller: controller),
            2 => SettingsTabView(controller: controller),
            _ => _SalesTabView(
              controller: controller,
              wholeAmount: _wholeAmount,
              decimalAmount: _decimalAmount,
              sectionGap: _sectionGap,
            ),
          },
          bottomNavigationBar: DashboardBottomNav(controller: controller),
        );
      }),
    );
  }
}

class _SalesTabView extends StatelessWidget {
  final DashboardController controller;
  final NumberFormat wholeAmount;
  final NumberFormat decimalAmount;
  final double sectionGap;

  const _SalesTabView({
    required this.controller,
    required this.wholeAmount,
    required this.decimalAmount,
    required this.sectionGap,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: controller.refreshSalesOverview,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SalesSummarySection(controller: controller),
            SizedBox(height: sectionGap.h),
            GestureDetector(
              onTap: () => Get.toNamed(AppRoute.getSalesSummaryScreen()),
              child: Obx(
                () => SalesBarChart(
                  values: controller.chartValues,
                  maxValue: controller.chartMaxValue.value,
                ),
              ),
            ),
            SizedBox(height: sectionGap.h),
            Obx(
              () => DashboardListSection(
                title: 'Items',
                onSeeAllTap: () => Get.toNamed(AppRoute.getSalesByItemScreen()),
                cards: [
                  for (final item in controller.items)
                    GradientListCard(
                      leading: AppNetworkImage(
                        url: item.imageUrl,
                        width: 55.w,
                        height: 55.w,
                      ),
                      title: item.name,
                      subtitle: 'x ${item.quantity}',
                      trailingText:
                          '${controller.currencySymbol}${wholeAmount.format(item.price)}',
                    ),
                ],
              ),
            ),
            SizedBox(height: sectionGap.h),
            Obx(
              () => DashboardListSection(
                title: 'Categories',
                onSeeAllTap: () =>
                    Get.toNamed(AppRoute.getSalesByCategoryScreen()),
                cards: [
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
                      trailingText:
                          '${controller.currencySymbol}${wholeAmount.format(category.price)}',
                    ),
                ],
              ),
            ),
            SizedBox(height: sectionGap.h),
            Obx(
              () => DashboardListSection(
                title: 'Employees',
                onSeeAllTap: () =>
                    Get.toNamed(AppRoute.getSalesByEmployeeScreen()),
                cards: [
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
                      trailingText:
                          '${controller.currencySymbol}${decimalAmount.format(employee.earnings)}',
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
