import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanBarcodeController extends GetxController with WidgetsBindingObserver {
  final cameraController = MobileScannerController();
  bool _handled = false;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
  }

  void onDetect(BarcodeCapture capture) {
    if (_handled || capture.barcodes.isEmpty) return;
    final value = capture.barcodes.first.rawValue?.trim();
    if (value == null || value.isEmpty) return;
    _handled = true;
    Get.back(result: value);
  }

  void flipCamera() => cameraController.switchCamera();

  Future<void> retryCamera() => cameraController.start();

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!cameraController.value.hasCameraPermission) return;

    switch (state) {
      case AppLifecycleState.resumed:
        unawaited(cameraController.start());
      case AppLifecycleState.inactive:
        unawaited(cameraController.stop());
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
        return;
    }
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    cameraController.dispose();
    super.onClose();
  }
}
