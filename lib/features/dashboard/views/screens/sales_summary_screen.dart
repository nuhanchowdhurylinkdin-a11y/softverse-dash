import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/common/widgets/gradient_app_bar.dart';
import '../../../../core/utils/constants/colors.dart';
import '../../controller/dashboard_controller.dart';
import '../../widgets/dashboard_bottom_nav.dart';
import '../../widgets/dashboard_date_bar.dart';
import '../../widgets/sales_summary_breakdown_card.dart';

class SalesSummaryScreen extends GetView<DashboardController> {
  const SalesSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: GradientAppBar(
          title: 'Sales Summary',
          titleLetterSpacing: 0.09,
          gradientColors: const [
            AppColors.dashboardHeaderGradientStart,
            AppColors.dashboardHeaderGradientEnd,
          ],
          leading: IconButton(
            onPressed: Get.back,
            icon: Icon(Icons.arrow_back, color: Colors.white, size: 22.w),
          ),
          bottom: DashboardDateBar(controller: controller),
        ),
        body: Padding(
          padding: EdgeInsets.all(16.w),
          child: SalesSummaryBreakdownCard(controller: controller),
        ),
        bottomNavigationBar: DashboardBottomNav(controller: controller),
      ),
    );
  }
}
