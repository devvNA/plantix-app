import 'package:get/get.dart';

import 'artikel_controller.dart';

class ArtikelBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ArtikelController>(
      () => ArtikelController(),
    );
  }
}
