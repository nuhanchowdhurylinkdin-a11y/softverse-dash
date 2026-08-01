import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../core/common/styles/global_text_style.dart';
import '../../../core/common/widgets/gradient_app_bar.dart';
import '../../../core/utils/constants/colors.dart';
import '../controller/dashboard_controller.dart';
import 'dashboard_bottom_nav.dart';
import 'dashboard_date_bar.dart';
import 'sales_summary_footer_card.dart';
import 'store_switcher.dart';

/// Shared layout for the "sales by X" drill-down screens (item/category/
/// employee) reached from the dashboard's "See all" links: a gradient app
/// bar with a back button, the day navigator, a sortable list section and a
/// gradient totals card pinned above the bottom nav.
class SalesDetailScaffold extends StatelessWidget {
  final DashboardController controller;
  final String appBarTitle;
  final String sectionLabel;
  final String footerTitle;
  final String footerCountLabel;
  final List<Widget> listItems;

  static final _decimalAmount = NumberFormat('#,##0.00');

  const SalesDetailScaffold({
    super.key,
    required this.controller,
    required this.appBarTitle,
    required this.sectionLabel,
    required this.footerTitle,
    required this.footerCountLabel,
    required this.listItems,
  });

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: GradientAppBar(
          title: appBarTitle,
          titleLetterSpacing: 0.09,
          gradientColors: const [
            AppColors.dashboardHeaderGradientStart,
            AppColors.dashboardHeaderGradientEnd,
          ],
          leading: IconButton(
            onPressed: Get.back,
            icon: Icon(Icons.arrow_back, color: Colors.white, size: 22.w),
          ),
          trailing: StoreSwitcher(controller: controller),
          bottom: DashboardDateBar(controller: controller),
        ),
        body: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    sectionLabel,
                    style: getTextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.dashboardTextDark,
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.arrow_upward,
                        color: AppColors.dashboardAccentBlue,
                        size: 16.w,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        'Net sales',
                        style: getTextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.dashboardAccentBlue,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 11.h),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      for (int i = 0; i < listItems.length; i++) ...[
                        if (i > 0) SizedBox(height: 8.h),
                        listItems[i],
                      ],
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Obx(
                () => SalesSummaryFooterCard(
                  title: footerTitle,
                  countLabel: footerCountLabel,
                  amount: '\$${_decimalAmount.format(controller.totalNetSalesAmount.value)}',
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: DashboardBottomNav(controller: controller),
      ),
    );
  }
}
