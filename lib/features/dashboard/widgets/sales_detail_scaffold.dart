import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

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
  final String footerAmount;
  final List<Widget> listItems;
  final bool isLoading;
  final String? error;
  final bool hasMore;
  final Future<void> Function() onRefresh;
  final Future<void> Function() onLoadMore;

  const SalesDetailScaffold({
    super.key,
    required this.controller,
    required this.appBarTitle,
    required this.sectionLabel,
    required this.footerTitle,
    required this.footerCountLabel,
    required this.footerAmount,
    required this.listItems,
    required this.isLoading,
    required this.error,
    required this.hasMore,
    required this.onRefresh,
    required this.onLoadMore,
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
                child: _ReportBody(
                  items: listItems,
                  isLoading: isLoading,
                  error: error,
                  hasMore: hasMore,
                  onRefresh: onRefresh,
                  onLoadMore: onLoadMore,
                ),
              ),
              SizedBox(height: 16.h),
              SalesSummaryFooterCard(
                title: footerTitle,
                countLabel: footerCountLabel,
                amount: footerAmount,
              ),
            ],
          ),
        ),
        bottomNavigationBar: DashboardBottomNav(controller: controller),
      ),
    );
  }
}

class _ReportBody extends StatelessWidget {
  final List<Widget> items;
  final bool isLoading;
  final String? error;
  final bool hasMore;
  final Future<void> Function() onRefresh;
  final Future<void> Function() onLoadMore;

  const _ReportBody({
    required this.items,
    required this.isLoading,
    required this.error,
    required this.hasMore,
    required this.onRefresh,
    required this.onLoadMore,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading && items.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (error != null && items.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(error!, textAlign: TextAlign.center),
            TextButton(onPressed: onRefresh, child: const Text('Try again')),
          ],
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: items.length + 1,
        separatorBuilder: (_, _) => SizedBox(height: 8.h),
        itemBuilder: (_, index) {
          if (index < items.length) return items[index];
          if (items.isEmpty) {
            return Padding(
              padding: EdgeInsets.only(top: 160.h),
              child: const Center(child: Text('No sales found')),
            );
          }
          if (!hasMore) return const SizedBox.shrink();
          return Center(
            child: isLoading
                ? const CircularProgressIndicator()
                : TextButton(
                    onPressed: onLoadMore,
                    child: const Text('Load more'),
                  ),
          );
        },
      ),
    );
  }
}
