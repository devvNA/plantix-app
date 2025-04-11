import 'package:get/get.dart';
import 'package:plantix_app/app/modules/profile/profile_controller.dart';
import 'package:plantix_app/app/modules/shop/shop_controller.dart';

import 'home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<ShopController>(() => ShopController());
    Get.lazyPut<ProfileController>(() => ProfileController(), fenix: true);
  }
}
