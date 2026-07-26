import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../core/utils/constants/colors.dart';
import '../controller/dashboard_controller.dart';
import 'inventory_category_tabs.dart';
import 'inventory_product_card.dart';
import 'inventory_stock_filter_chips.dart';

/// The Inventory tab body: stock filter chips, category tabs, the scrollable
/// product list and the floating search/scan action buttons.
class InventoryTabView extends StatelessWidget {
  final DashboardController controller;

  const InventoryTabView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InventoryStockFilterChips(controller: controller),
              SizedBox(height: 16.h),
              InventoryCategoryTabs(controller: controller),
              SizedBox(height: 16.h),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      for (int i = 0; i < controller.inventoryProducts.length; i++) ...[
                        if (i > 0) SizedBox(height: 8.h),
                        InventoryProductCard(product: controller.inventoryProducts[i]),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          right: 16.w,
          bottom: 16.h,
          child: Column(
            children: [
              _FloatingIconButton(
                icon: Iconsax.search_normal,
                backgroundColor: AppColors.inventoryChipBg,
                iconColor: AppColors.dashboardAccentBlue,
                onTap: () {},
              ),
              SizedBox(height: 12.h),
              _FloatingIconButton(
                icon: Iconsax.scan_barcode,
                backgroundColor: AppColors.dashboardAccentBlue,
                iconColor: Colors.white,
                onTap: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FloatingIconButton extends StatelessWidget {
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;
  final VoidCallback onTap;

  const _FloatingIconButton({
    required this.icon,
    required this.backgroundColor,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 56.w,
          height: 56.w,
          child: Icon(icon, color: iconColor, size: 24.w),
        ),
      ),
    );
  }
}
