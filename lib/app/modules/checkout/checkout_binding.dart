import 'package:get/get.dart';
import 'package:plantix_app/app/modules/cart/cart_controller.dart';

import 'checkout_controller.dart';

class CheckoutBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CheckoutController>(() => CheckoutController());
    Get.lazyPut<CartController>(() => CartController());
  }
}
