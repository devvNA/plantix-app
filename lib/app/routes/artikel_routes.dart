import 'package:get/get.dart';

import '../modules/artikel/artikel_binding.dart';
import '../modules/artikel/artikel_page.dart';
import '../modules/artikel/artikel_all/artikel_all_binding.dart';
import '../modules/artikel/artikel_all/artikel_all_page.dart';

class ArtikelRoutes {
  ArtikelRoutes._();

  static const artikel = '/artikel';
	static const artikelAll = '/artikel/artikel-all';

  static final routes = [
    GetPage(
      name: artikel,
      page: () => const ArtikelPage(),
      binding: ArtikelBinding(),
    ),
		GetPage(
      name: artikelAll,
      page: () => const ArtikelAllPage(),
      binding: ArtikelAllBinding(),
    ),
  ];
}
