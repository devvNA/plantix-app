import 'package:get/get.dart';

import 'artikel_all_controller.dart';

class ArtikelAllBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ArtikelAllController>(
      () => ArtikelAllController(),
    );
  }
}
