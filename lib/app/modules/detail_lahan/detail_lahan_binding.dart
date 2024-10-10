import 'package:get/get.dart';

import 'detail_lahan_controller.dart';

class DetailLahanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailLahanController>(
      () => DetailLahanController(),
    );
  }
}
