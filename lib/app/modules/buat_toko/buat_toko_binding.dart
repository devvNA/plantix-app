import 'package:get/get.dart';

import 'buat_toko_controller.dart';

class BuatTokoBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<BuatTokoController>(BuatTokoController(), permanent: false);
  }
}
