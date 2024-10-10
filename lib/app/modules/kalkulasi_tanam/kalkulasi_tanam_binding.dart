import 'package:get/get.dart';

import 'kalkulasi_tanam_controller.dart';

class KalkulasiTanamBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<KalkulasiTanamController>(
      () => KalkulasiTanamController(),
    );
  }
}
