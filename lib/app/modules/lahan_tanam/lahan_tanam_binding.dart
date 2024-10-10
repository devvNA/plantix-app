import 'package:get/get.dart';

import 'lahan_tanam_controller.dart';

class LahanTanamBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LahanTanamController>(() => LahanTanamController());
    // ...existing dependencies...
  }
}
