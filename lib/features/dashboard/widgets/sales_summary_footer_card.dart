import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/common/styles/global_text_style.dart';
import '../../../core/utils/constants/colors.dart';

/// The gradient totals card shown at the bottom of each sales-detail screen
/// (sales by item/category/employee) — a title + count on one row and a
/// "Net Sales Amount" + formatted total on the next.
class SalesSummaryFooterCard extends StatelessWidget {
  final String title;
  final String countLabel;
  final String netSalesLabel;
  final String amount;
  final List<Color> gradientColors;

  const SalesSummaryFooterCard({
    super.key,
    required this.title,
    required this.countLabel,
    required this.amount,
    this.netSalesLabel = 'Net Sales Amount',
    this.gradientColors = const [
      AppColors.gaugeYellowStart,
      AppColors.gaugeYellowEnd,
    ],
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: getTextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.dashboardTextDark,
                ),
              ),
              Text(
                countLabel,
                style: getTextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.dashboardTextDark,
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                netSalesLabel,
                style: getTextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.dashboardTextDark,
                ),
              ),
              Text(
                amount,
                style: getTextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.dashboardTextDark,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
