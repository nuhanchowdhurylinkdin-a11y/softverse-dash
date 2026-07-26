import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../styles/global_text_style.dart';
import '../../utils/constants/colors.dart';

/// A soft gradient card with a leading thumbnail, a title/subtitle pair and
/// a trailing value — used by list rows across dashboard/CDS style screens
/// (items, categories, employees, purchase items, etc).
class GradientListCard extends StatelessWidget {
  final Widget leading;
  final String title;
  final String subtitle;
  final String trailingText;
  final double verticalPadding;
  final BoxBorder? border;
  final Color titleColor;
  final Color accentColor;

  const GradientListCard({
    super.key,
    required this.leading,
    required this.title,
    required this.subtitle,
    required this.trailingText,
    this.verticalPadding = 8,
    this.border,
    this.titleColor = AppColors.dashboardTextDark,
    this.accentColor = AppColors.dashboardAccentBlue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: verticalPadding.h,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: border,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.dashboardCardGradientStart,
            AppColors.dashboardCardGradientEnd,
          ],
        ),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: SizedBox(width: 55.w, height: 55.w, child: leading),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: getTextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: titleColor,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  subtitle,
                  style: getTextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: accentColor,
                  ),
                ),
              ],
            ),
          ),
          Text(
            trailingText,
            style: getTextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: accentColor,
            ),
          ),
        ],
      ),
    );
  }
}
