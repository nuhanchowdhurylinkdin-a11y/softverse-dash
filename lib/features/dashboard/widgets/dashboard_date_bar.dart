import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../core/common/styles/global_text_style.dart';
import '../../../core/utils/constants/colors.dart';
import '../controller/dashboard_controller.dart';

/// The day navigator row (previous/next arrows + formatted date) shown
/// beneath the gradient app bar on the dashboard and its sales-detail screens.
class DashboardDateBar extends StatelessWidget implements PreferredSizeWidget {
  final DashboardController controller;

  const DashboardDateBar({super.key, required this.controller});

  static double get _height => 55.h;

  @override
  Size get preferredSize => Size.fromHeight(_height);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _height,
      color: AppColors.dashboardDateBarBg,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          InkWell(
            onTap: controller.goToPreviousDay,
            child: Icon(
              Icons.keyboard_arrow_left,
              color: AppColors.dashboardTextDark,
              size: 22.w,
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => _pickDate(context),
              child: Center(
                child: Obx(
                  () => Text(
                    DateFormat('d MMMM').format(controller.selectedDate.value),
                    style: getTextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: AppColors.dashboardTextDark,
                    ),
                  ),
                ),
              ),
            ),
          ),
          InkWell(
            onTap: controller.goToNextDay,
            child: Icon(
              Icons.keyboard_arrow_right,
              color: AppColors.dashboardTextDark,
              size: 22.w,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: controller.selectedDate.value,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: AppColors.dashboardAccentBlue,
                ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) controller.selectDate(picked);
  }
}
