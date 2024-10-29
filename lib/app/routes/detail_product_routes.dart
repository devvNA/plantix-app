import 'package:get/get.dart';

import '../modules/detail_product/detail_product_binding.dart';
import '../modules/detail_product/detail_product_page.dart';

class DetailProductRoutes {
  DetailProductRoutes._();

  static const detailProduct = '/detail-product';

  static final routes = [
    GetPage(
      name: detailProduct,
      page: () => const DetailProductPage(),
      binding: DetailProductBinding(),
    ),
  ];
}
