import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../core/common/styles/global_text_style.dart';
import '../../../core/utils/constants/colors.dart';
import '../controller/dashboard_controller.dart';

/// The store picker shown in the app bar's trailing slot, letting a manager
/// who runs more than one store switch which store's data is shown. Kept
/// deliberately compact (fixed max width, single line, small type) so it
/// never crowds out the screen title next to it.
class StoreSwitcher extends StatelessWidget {
  final DashboardController controller;

  const StoreSwitcher({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openStorePicker(context),
      child: Container(
        constraints: BoxConstraints(maxWidth: 118.w),
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.16),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Iconsax.shop, color: Colors.white, size: 14.w),
            SizedBox(width: 5.w),
            Flexible(
              child: Obx(
                () => Text(
                  controller.selectedStore.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: getTextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(width: 2.w),
            Icon(Icons.expand_more, color: Colors.white, size: 16.w),
          ],
        ),
      ),
    );
  }

  void _openStorePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 4.h),
                child: Text(
                  'Switch store',
                  style: getTextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.dashboardTextDark,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 8.h),
                child: Text(
                  'Softvence stores',
                  style: getTextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: AppColors.dashboardNavInactive,
                  ),
                ),
              ),
              for (int i = 0; i < controller.stores.length; i++)
                Obx(
                  () => InkWell(
                    onTap: () {
                      controller.selectStore(i);
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                      child: Row(
                        children: [
                          Icon(Iconsax.shop, color: AppColors.dashboardAccentBlue, size: 20.w),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Text(
                              controller.stores[i].name,
                              style: getTextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: AppColors.dashboardTextDark,
                              ),
                            ),
                          ),
                          if (controller.selectedStoreIndex.value == i)
                            Icon(Icons.check_circle, color: AppColors.dashboardAccentBlue, size: 20.w),
                        ],
                      ),
                    ),
                  ),
                ),
              SizedBox(height: 8.h),
            ],
          ),
        );
      },
    );
  }
}
