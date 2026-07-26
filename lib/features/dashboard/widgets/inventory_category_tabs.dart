import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/common/styles/global_text_style.dart';
import '../../../core/utils/constants/colors.dart';
import '../controller/dashboard_controller.dart';

/// The horizontally-scrollable category tab row ("All Item", "PC Components",
/// …) on the Inventory tab.
class InventoryCategoryTabs extends StatelessWidget {
  final DashboardController controller;

  const InventoryCategoryTabs({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (int i = 0; i < controller.categoryTabs.length; i++) ...[
              if (i > 0) SizedBox(width: 8.w),
              _CategoryTab(
                label: controller.categoryTabs[i],
                isSelected: controller.selectedCategoryTabIndex.value == i,
                onTap: () => controller.selectCategoryTab(i),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _CategoryTab extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryTab({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40.h,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        decoration: BoxDecoration(
          color: AppColors.inventoryChipBg,
          border: Border.all(color: AppColors.dashboardCardBorder),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Text(
          label,
          style: getTextStyle(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
            color: isSelected ? AppColors.dashboardAccentBlue : AppColors.dashboardNavInactive,
          ),
        ),
      ),
    );
  }
}
