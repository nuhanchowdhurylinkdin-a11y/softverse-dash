import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../core/common/styles/global_text_style.dart';
import '../../../core/utils/constants/colors.dart';
import '../controller/dashboard_controller.dart';

/// The "All Category / Low Stock / Out of Stock / Expire date" filter row
/// on the Inventory tab.
class InventoryStockFilterChips extends StatelessWidget {
  final DashboardController controller;

  const InventoryStockFilterChips({super.key, required this.controller});

  static const _icons = [
    Iconsax.category,
    Iconsax.trend_down,
    Iconsax.close_circle,
    Iconsax.calendar_2,
    Iconsax.calendar_tick,
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (int i = 0; i < controller.stockFilters.length; i++) ...[
              if (i > 0) SizedBox(width: 10.w),
              _FilterChip(
                icon: _icons[i],
                label: controller.stockFilters[i],
                isSelected: controller.selectedStockFilterIndex.value == i,
                onTap: () => controller.selectStockFilter(i),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final foreground = isSelected
        ? Colors.white
        : AppColors.dashboardAccentBlue;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        height: 42.h,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(21.r),
          gradient: isSelected
              ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.authGradientStart,
                    AppColors.authGradientEnd,
                  ],
                )
              : null,
          color: isSelected ? null : AppColors.inventoryChipBg,
          border: isSelected
              ? null
              : Border.all(color: AppColors.dashboardCardBorder),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.dashboardAccentBlue.withValues(
                      alpha: 0.28,
                    ),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16.w, color: foreground),
            SizedBox(width: 6.w),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 220),
              style: getTextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: foreground,
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}
