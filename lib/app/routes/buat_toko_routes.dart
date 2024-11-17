import 'package:get/get.dart';

import '../modules/buat_toko/buat_toko_binding.dart';
import '../modules/buat_toko/buat_toko_page.dart';

class BuatTokoRoutes {
  BuatTokoRoutes._();

  static const buatToko = '/buat-toko';

  static final routes = [
    GetPage(
      name: buatToko,
      page: () => const BuatTokoPage(),
      binding: BuatTokoBinding(),
    ),
  ];
}
