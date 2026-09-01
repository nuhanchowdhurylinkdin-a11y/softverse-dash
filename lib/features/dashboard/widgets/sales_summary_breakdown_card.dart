import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../core/common/styles/global_text_style.dart';
import '../../../core/common/widgets/dashed_divider.dart';
import '../../../core/utils/constants/colors.dart';
import '../controller/dashboard_controller.dart';

/// The gradient breakdown card on the "Sales Summary" screen: gross sales
/// down through gross profit, grouped into dashed-divider-separated sections.
class SalesSummaryBreakdownCard extends StatelessWidget {
  final DashboardController controller;

  const SalesSummaryBreakdownCard({super.key, required this.controller});

  static final _amount = NumberFormat('#,##0.00');

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.dashboardCardBorder),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: const [
            AppColors.dashboardCardGradientStart,
            AppColors.dashboardCardGradientEnd,
          ],
        ),
      ),
      child: Column(
        children: [
          _SummaryRow(
            label: 'Gross sales',
            value: controller.salesSummaryGrossSales.value,
            emphasize: true,
          ),
          SizedBox(height: 8.h),
          _SummaryRow(
            label: 'Refunds',
            value: controller.salesSummaryRefunds.value,
          ),
          SizedBox(height: 8.h),
          _SummaryRow(
            label: 'Discounts',
            value: controller.salesSummaryDiscounts.value,
          ),
          SizedBox(height: 10.h),
          const DashedDivider(),
          SizedBox(height: 10.h),
          _SummaryRow(
            label: 'Net sales',
            value: controller.salesSummaryNetSales.value,
            emphasize: true,
          ),
          SizedBox(height: 8.h),
          _SummaryRow(
            label: 'Taxes',
            value: controller.salesSummaryTaxes.value,
            boldValue: true,
          ),
          SizedBox(height: 10.h),
          const DashedDivider(),
          SizedBox(height: 10.h),
          _SummaryRow(
            label: 'Total tendered',
            value: controller.salesSummaryTotalTendered.value,
            emphasize: true,
          ),
          SizedBox(height: 10.h),
          const DashedDivider(),
          SizedBox(height: 10.h),
          _SummaryRow(
            label: 'Cost of goods',
            value: controller.salesSummaryCostOfGoods.value,
            boldValue: true,
          ),
          SizedBox(height: 8.h),
          _SummaryRow(
            label: 'Gross profit',
            value: controller.salesSummaryGrossProfit.value,
            emphasize: true,
          ),
          SizedBox(height: 12.h),
          Text(
            'Net sales = Gross sales − Refunds − Discounts',
            style: getTextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: AppColors.dashboardNavInactive,
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final double value;
  final bool emphasize;
  final bool boldValue;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.emphasize = false,
    this.boldValue = false,
  });

  @override
  Widget build(BuildContext context) {
    final labelColor = emphasize
        ? AppColors.dashboardAccentBlue
        : AppColors.dashboardNavInactive;
    final valueColor = emphasize
        ? AppColors.dashboardAccentBlue
        : AppColors.dashboardNavInactive;
    final valueWeight = emphasize || boldValue
        ? FontWeight.w500
        : FontWeight.w400;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: getTextStyle(
            fontSize: 16,
            fontWeight: emphasize ? FontWeight.w500 : FontWeight.w400,
            color: labelColor,
          ),
        ),
        Text(
          '${Get.find<DashboardController>().currencySymbol}${SalesSummaryBreakdownCard._amount.format(value)}',
          style: getTextStyle(
            fontSize: 16,
            fontWeight: valueWeight,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}
