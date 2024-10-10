import 'package:get/get.dart';

import 'detail_analisa_usaha_controller.dart';

class DetailAnalisaUsahaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailAnalisaUsahaController>(
      () => DetailAnalisaUsahaController(),
    );
  }
}
