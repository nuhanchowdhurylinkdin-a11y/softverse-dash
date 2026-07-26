import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/common/styles/global_text_style.dart';
import '../../../core/utils/constants/colors.dart';

class DashboardListSection extends StatelessWidget {
  final String title;
  final List<Widget> cards;
  final VoidCallback? onSeeAllTap;

  const DashboardListSection({
    super.key,
    required this.title,
    required this.cards,
    this.onSeeAllTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: getTextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.dashboardTextDark,
              ),
            ),
            GestureDetector(
              onTap: onSeeAllTap,
              child: Text(
                'See all',
                style: getTextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.dashboardAccentBlue,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 11.h),
        for (int i = 0; i < cards.length; i++) ...[
          if (i > 0) SizedBox(height: 8.h),
          cards[i],
        ],
      ],
    );
  }
}
