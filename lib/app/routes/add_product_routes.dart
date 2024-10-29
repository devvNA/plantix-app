import 'package:get/get.dart';

import '../modules/add_product/add_product_binding.dart';
import '../modules/add_product/add_product_page.dart';

class AddProductRoutes {
  AddProductRoutes._();

  static const addProduct = '/add-product';

  static final routes = [
    GetPage(
      name: addProduct,
      page: () => const AddProductPage(),
      binding: AddProductBinding(),
    ),
  ];
}
