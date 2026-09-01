import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/common/styles/global_text_style.dart';
import '../../../core/common/widgets/app_button.dart';
import '../../../core/utils/constants/colors.dart';
import '../controller/dashboard_controller.dart';

/// The Settings tab body: notification/sound/help rows, account details and
/// the log-out action.
class SettingsTabView extends StatelessWidget {
  final DashboardController controller;

  const SettingsTabView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Stock notifications',
                      style: getTextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.dashboardAccentBlue,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Notify when items are low or out of stock.',
                      style: getTextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppColors.dashboardNavInactive,
                      ),
                    ),
                  ],
                ),
              ),
              Obx(
                () => Switch(
                  value: controller.stockNotificationsEnabled.value,
                  onChanged: (_) => controller.toggleStockNotifications(),
                  activeTrackColor: AppColors.dashboardAccentBlue,
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Divider(color: AppColors.dashboardCardBorder, height: 1),
          SizedBox(height: 20.h),
          _LabeledRow(label: 'Sound', value: controller.settingsSound),
          SizedBox(height: 20.h),
          Divider(color: AppColors.dashboardCardBorder, height: 1),
          SizedBox(height: 20.h),
          Text(
            'Help',
            style: getTextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.dashboardAccentBlue,
            ),
          ),
          SizedBox(height: 20.h),
          Divider(color: AppColors.dashboardCardBorder, height: 1),
          SizedBox(height: 24.h),
          Obx(
            () => _InlineRow(
              label: 'Account',
              value: controller.settingsAccountEmail,
            ),
          ),
          SizedBox(height: 12.h),
          _InlineRow(label: 'IP address', value: controller.settingsIpAddress),
          SizedBox(height: 12.h),
          _InlineRow(label: 'Version', value: controller.settingsAppVersion),
          SizedBox(height: 40.h),
          Center(
            child: AppButton(
              label: 'Log out',
              width: 197.w,
              height: 68.h,
              backgroundColor: AppColors.dangerRed,
              onPressed: controller.logout,
            ),
          ),
        ],
      ),
    );
  }
}

class _LabeledRow extends StatelessWidget {
  final String label;
  final String value;

  const _LabeledRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: getTextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.dashboardAccentBlue,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          style: getTextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: AppColors.dashboardNavInactive,
          ),
        ),
      ],
    );
  }
}

class _InlineRow extends StatelessWidget {
  final String label;
  final String value;

  const _InlineRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: getTextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.dashboardAccentBlue,
          ),
        ),
        Text(
          value,
          style: getTextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: AppColors.dashboardNavInactive,
          ),
        ),
      ],
    );
  }
}
