import 'package:get/get.dart';

import '../modules/sales/sales_binding.dart';
import '../modules/sales/sales_page.dart';

class SalesRoutes {
  SalesRoutes._();

  static const sales = '/sales';

  static final routes = [
    GetPage(
      name: sales,
      page: () => const SalesPage(),
      binding: SalesBinding(),
    ),
  ];
}
