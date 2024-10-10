import 'package:get/get.dart';

import 'seed_products_controller.dart';

class SeedProductsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SeedProductsController>(
      () => SeedProductsController(),
    );
  }
}
