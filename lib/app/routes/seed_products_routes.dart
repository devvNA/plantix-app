import 'package:get/get.dart';

import '../modules/seed_products/seed_products_binding.dart';
import '../modules/seed_products/seed_products_page.dart';

class SeedProductsRoutes {
  SeedProductsRoutes._();

  static const seedProducts = '/seed-products';

  static final routes = [
    GetPage(
      name: seedProducts,
      page: () => const SeedProductsPage(),
      binding: SeedProductsBinding(),
    ),
  ];
}
