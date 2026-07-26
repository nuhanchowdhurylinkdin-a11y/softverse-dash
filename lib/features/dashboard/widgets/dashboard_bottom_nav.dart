import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../core/common/styles/global_text_style.dart';
import '../../../core/utils/constants/colors.dart';
import '../controller/dashboard_controller.dart';

class DashboardBottomNav extends StatelessWidget {
  final DashboardController controller;

  const DashboardBottomNav({super.key, required this.controller});

  static const _tabs = [
    (icon: Iconsax.chart_2, label: 'Sales'),
    (icon: Iconsax.hierarchy_square, label: 'Inventory'),
    (icon: Iconsax.setting_2, label: 'Settings'),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        height: 91.h,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: AppColors.authFieldDivider),
          ),
        ),
        child: Row(
          children: [
            for (int i = 0; i < _tabs.length; i++)
              Expanded(
                child: InkWell(
                  onTap: () => controller.selectNavIndex(i),
                  child: _NavTabContent(
                    icon: _tabs[i].icon,
                    label: _tabs[i].label,
                    isSelected: controller.selectedNavIndex.value == i,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _NavTabContent extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;

  const _NavTabContent({
    required this.icon,
    required this.label,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSelected
        ? AppColors.dashboardAccentBlue
        : AppColors.dashboardNavInactive;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color, size: 26.w),
        SizedBox(height: 4.h),
        Text(
          label,
          style: getTextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: color,
          ),
        ),
      ],
    );
  }
}
