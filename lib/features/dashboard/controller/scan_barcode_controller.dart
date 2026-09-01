import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanBarcodeController extends GetxController {
  final cameraController = MobileScannerController();
  bool _handled = false;

  void onDetect(BarcodeCapture capture) {
    if (_handled || capture.barcodes.isEmpty) return;
    final value = capture.barcodes.first.rawValue?.trim();
    if (value == null || value.isEmpty) return;
    _handled = true;
    Get.back(result: value);
  }

  void flipCamera() => cameraController.switchCamera();

  @override
  void onClose() {
    cameraController.dispose();
    super.onClose();
  }
}
