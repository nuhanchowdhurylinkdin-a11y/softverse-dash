import 'package:flutter/material.dart';

import '../../../core/common/widgets/gradient_app_bar.dart';
import '../../../core/utils/constants/colors.dart';
import '../controller/dashboard_controller.dart';
import 'dashboard_date_bar.dart';

/// The dashboard's app bar, its title and whether the date bar shows
/// depending on which bottom-nav tab (Sales/Inventory/Settings) is active.
class DashboardAppBar extends StatelessWidget implements PreferredSizeWidget {
  final DashboardController controller;
  final int selectedIndex;

  const DashboardAppBar({
    super.key,
    required this.controller,
    required this.selectedIndex,
  });

  static const _titles = ['Sales Overview', 'Inventory', 'Settings'];

  bool get _showDateBar => selectedIndex != 2;

  @override
  Size get preferredSize => _buildAppBar().preferredSize;

  @override
  Widget build(BuildContext context) => _buildAppBar();

  GradientAppBar _buildAppBar() {
    return GradientAppBar(
      title: _titles[selectedIndex],
      titleLetterSpacing: 0.09,
      gradientColors: const [
        AppColors.dashboardHeaderGradientStart,
        AppColors.dashboardHeaderGradientEnd,
      ],
      bottom: _showDateBar ? DashboardDateBar(controller: controller) : null,
    );
  }
}
