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
import '../../widgets/store_switcher.dart';

class SalesSummaryScreen extends StatefulWidget {
  const SalesSummaryScreen({super.key});

  @override
  State<SalesSummaryScreen> createState() => _SalesSummaryScreenState();
}

class _SalesSummaryScreenState extends State<SalesSummaryScreen> {
  final controller = Get.find<DashboardController>();

  @override
  void initState() {
    super.initState();
    controller.openReport(SalesReportKind.summary);
  }

  @override
  void dispose() {
    if (controller.activeReport.value == SalesReportKind.summary) {
      controller.closeReport();
    }
    super.dispose();
  }

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
          trailing: StoreSwitcher(controller: controller),
          bottom: DashboardDateBar(controller: controller),
        ),
        body: Obx(
          () => RefreshIndicator(
            onRefresh: controller.refreshActiveReport,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.all(16.w),
              children: [
                if (controller.isReportLoading.value)
                  const LinearProgressIndicator(),
                if (controller.reportError.value != null) ...[
                  Text(
                    controller.reportError.value!,
                    textAlign: TextAlign.center,
                  ),
                  TextButton(
                    onPressed: controller.refreshActiveReport,
                    child: const Text('Try again'),
                  ),
                ] else
                  SalesSummaryBreakdownCard(controller: controller),
              ],
            ),
          ),
        ),
        bottomNavigationBar: DashboardBottomNav(controller: controller),
      ),
    );
  }
}
