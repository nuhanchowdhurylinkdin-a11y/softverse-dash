import 'package:get/get.dart';

import '../controller/theme_controller.dart';
import '../../features/splash/controller/splash_controller.dart';
import '../../features/auth/controller/auth_controller.dart';
import '../../features/dashboard/controller/dashboard_controller.dart';

class ControllerBinder extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ThemeController>(() => ThemeController(), fenix: true);
    Get.lazyPut<SplashController>(() => SplashController(), fenix: true);
    Get.lazyPut<AuthController>(() => AuthController(), fenix: true);
    Get.lazyPut<DashboardController>(() => DashboardController(), fenix: true);
  }
}
