import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../../core/utils/theme/app_colors_extension.dart';
import '../../controller/splash_controller.dart';

class SplashScreen extends GetView<SplashController> {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    // Touch `controller` so GetX resolves it and its onInit navigation timer starts.
    controller;

    return Scaffold(
      backgroundColor: c.cardBg,
      body: Center(
        child: Image.asset(
          'assets/icons/logo.png',
          width: 240.w,
          height: 240.w,
        ),
      ),
    );
  }
}
