import 'package:get/get.dart';
import 'package:plantix_app/app/modules/cart/cart_controller.dart';

import 'shop_controller.dart';

class ShopBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ShopController>(() => ShopController());
    Get.lazyPut<CartController>(() => CartController());
  }
}
