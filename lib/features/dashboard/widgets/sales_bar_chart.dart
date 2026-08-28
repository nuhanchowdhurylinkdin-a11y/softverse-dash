import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/common/styles/global_text_style.dart';
import '../../../core/utils/constants/colors.dart';

class SalesBarChart extends StatelessWidget {
  final List<double> values;
  final double maxValue;

  const SalesBarChart({
    super.key,
    required this.values,
    this.maxValue = 10000,
  });

  static const _yLabels = ['10k', '9k', '6k', '3k', '1k', '0%'];
  static const _xLabels = ['0.00', '5.00', '10.00', '15.00', '20.00'];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: SizedBox(
        height: 280.h,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: 24.w,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final label in _yLabels)
                    Text(
                      label,
                      style: getTextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: AppColors.dashboardAxisGrey,
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            for (int i = 0; i < _yLabels.length; i++)
                              Divider(
                                height: 1,
                                thickness: 1,
                                color: AppColors.authFieldDivider,
                              ),
                          ],
                        ),
                        Positioned.fill(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                if (values.isEmpty) {
                                  return const SizedBox.shrink();
                                }
                                final gap = 4.w;
                                final totalGap = gap * (values.length - 1);
                                final barWidth =
                                    ((constraints.maxWidth - totalGap) /
                                            values.length)
                                        .clamp(1.0, 9.w);
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    for (int i = 0; i < values.length; i++) ...[
                                      if (i > 0) SizedBox(width: gap),
                                      _Bar(
                                        width: barWidth,
                                        height: constraints.maxHeight *
                                            (values[i] / maxValue).clamp(0, 1),
                                      ),
                                    ],
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      for (final label in _xLabels)
                        Text(
                          label,
                          style: getTextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: AppColors.dashboardAxisGrey,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  final double width;
  final double height;

  const _Bar({required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(4.r)),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.authGradientStart,
            AppColors.authGradientEnd,
          ],
        ),
      ),
    );
  }
}
