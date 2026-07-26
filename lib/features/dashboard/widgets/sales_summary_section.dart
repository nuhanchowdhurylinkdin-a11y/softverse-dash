import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/common/styles/global_text_style.dart';
import '../../../core/common/widgets/radial_gauge.dart';
import '../../../core/utils/constants/colors.dart';
import '../controller/dashboard_controller.dart';

class SalesSummarySection extends StatelessWidget {
  final DashboardController controller;

  const SalesSummarySection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sales summary',
          style: getTextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.dashboardTextDark,
          ),
        ),
        SizedBox(height: 16.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _GaugeStat(
              size: 100.w,
              progress: 0.35,
              trackColor: AppColors.gaugeYellowTrack,
              gradientColors: const [
                AppColors.gaugeYellowStart,
                AppColors.gaugeYellowEnd,
              ],
              valueBuilder: () => Obx(
                () => Text(
                  '${controller.transactions.value}',
                  style: getTextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    color: AppColors.dashboardTextDark,
                  ),
                ),
              ),
              label: 'Transections',
              changeBuilder: () => Obx(
                () => _ChangeText(controller.transactionsChange.value),
              ),
            ),
            _GaugeStat(
              size: 129.w,
              progress: 0.88,
              trackColor: AppColors.gaugeGreenTrack,
              gradientColors: const [
                AppColors.gaugeGreenStart,
                AppColors.gaugeGreenEnd,
              ],
              valueBuilder: () => Obx(
                () => Text(
                  '\$${controller.netSales.value.toStringAsFixed(2)}',
                  style: getTextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: AppColors.dashboardTextDark,
                  ),
                ),
              ),
              label: 'Net sales',
              changeBuilder: () => Obx(
                () => _ChangeText(controller.netSalesChange.value),
              ),
            ),
            _GaugeStat(
              size: 100.w,
              progress: 0.62,
              trackColor: AppColors.gaugePurpleTrack,
              gradientColors: const [
                AppColors.gaugePurpleStart,
                AppColors.gaugePurpleEnd,
              ],
              valueBuilder: () => Obx(
                () => Text(
                  '\$${controller.averageSale.value.toStringAsFixed(2)}',
                  style: getTextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    color: AppColors.dashboardTextDark,
                  ),
                ),
              ),
              label: 'Average sale',
              changeBuilder: () => Obx(
                () => _ChangeText(controller.averageSaleChange.value),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _GaugeStat extends StatelessWidget {
  final double size;
  final double progress;
  final Color trackColor;
  final List<Color> gradientColors;
  final Widget Function() valueBuilder;
  final String label;
  final Widget Function() changeBuilder;

  const _GaugeStat({
    required this.size,
    required this.progress,
    required this.trackColor,
    required this.gradientColors,
    required this.valueBuilder,
    required this.label,
    required this.changeBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        RadialGauge(
          size: size,
          progress: progress,
          trackColor: trackColor,
          gradientColors: gradientColors,
          strokeWidth: 10.w,
          center: valueBuilder(),
        ),
        SizedBox(height: 11.h),
        Text(
          label,
          style: getTextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.dashboardTextDark,
          ),
        ),
        SizedBox(height: 4.h),
        changeBuilder(),
      ],
    );
  }
}

class _ChangeText extends StatelessWidget {
  final double value;

  const _ChangeText(this.value);

  @override
  Widget build(BuildContext context) {
    final sign = value > 0 ? '+' : '';
    return Text(
      '$sign${value.toStringAsFixed(2)}%',
      style: getTextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: AppColors.dashboardAccentBlue,
      ),
    );
  }
}
