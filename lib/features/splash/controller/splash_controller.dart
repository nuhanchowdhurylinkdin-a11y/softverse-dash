import 'package:get/get.dart';

import '../../../core/services/storage_service.dart';
import '../../../../../routes/app_routes.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _navigateToPair();
  }

  Future<void> _navigateToPair() async {
    await Future.delayed(const Duration(seconds: 2));
    if (StorageService.hasToken()) {
      Get.offAllNamed(AppRoute.getDashboardScreen());
      return;
    }
    Get.offAllNamed(AppRoute.getLoginScreen());
  }
}
