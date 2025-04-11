import 'package:get/get.dart';

import '../modules/shop/shop_binding.dart';
import '../modules/shop/shop_page.dart';

class ShopRoutes {
  ShopRoutes._();

  static const shop = '/shop';

  static final routes = [
    GetPage(name: shop, page: () => const ShopPage(), binding: ShopBinding()),
  ];
}
