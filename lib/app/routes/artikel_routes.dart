import 'package:get/get.dart';

import '../modules/artikel/artikel_binding.dart';
import '../modules/artikel/artikel_page.dart';

class ArtikelRoutes {
  ArtikelRoutes._();

  static const artikel = '/artikel';

  static final routes = [
    GetPage(
      name: artikel,
      page: () => const ArtikelPage(),
      binding: ArtikelBinding(),
    ),
  ];
}
