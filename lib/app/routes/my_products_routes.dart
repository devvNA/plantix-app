import 'package:get/get.dart';

import '../modules/my_products/my_products_binding.dart';
import '../modules/my_products/my_products_page.dart';

class MyProductsRoutes {
  MyProductsRoutes._();

  static const myProducts = '/my-products';

  static final routes = [
    GetPage(
      name: myProducts,
      page: () => const MyProductsPage(),
      binding: MyProductsBinding(),
    ),
  ];
}
