import 'package:get/get.dart';

import 'analisa_usaha_tani_controller.dart';

class AnalisaUsahaTaniBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AnalisaUsahaTaniController>(
      () => AnalisaUsahaTaniController(),
    );
  }
}
