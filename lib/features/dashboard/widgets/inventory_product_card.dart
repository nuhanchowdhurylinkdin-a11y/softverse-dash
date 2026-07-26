import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../core/common/styles/global_text_style.dart';
import '../../../core/common/widgets/app_network_image.dart';
import '../../../core/utils/constants/colors.dart';
import '../models/inventory_product_model.dart';

/// A single inventory row: product image, name/SKU, and a stock-status
/// badge above the price.
class InventoryProductCard extends StatelessWidget {
  final InventoryProductModel product;

  const InventoryProductCard({super.key, required this.product});

  static final _wholeAmount = NumberFormat('#,##0');

  Color get _statusColor {
    if (product.stockCount <= 0) return AppColors.dangerRed;
    if (product.stockCount < 10) return AppColors.stockLow;
    return AppColors.stockHigh;
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor;

    return Container(
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.dashboardCardBorder),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: AppNetworkImage(url: product.imageUrl, width: 60.w, height: 60.w),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: getTextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.dashboardTextDark,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  product.sku,
                  style: getTextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColors.dashboardAccentBlue,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  '${product.stockCount} In Stock',
                  style: getTextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: statusColor,
                  ),
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                '\$${_wholeAmount.format(product.price)}',
                style: getTextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: AppColors.dashboardAccentBlue,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
