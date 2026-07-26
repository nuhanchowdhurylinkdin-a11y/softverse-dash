import 'package:get/get.dart';

import '../../../../../routes/app_routes.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _navigateToPair();
  }

  Future<void> _navigateToPair() async {
    await Future.delayed(const Duration(seconds: 2));
    Get.offAllNamed(AppRoute.getLoginScreen());
  }
}
