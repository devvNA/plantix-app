import 'package:get/get.dart';

import '../modules/analisa_usaha_tani/analisa_usaha_tani_binding.dart';
import '../modules/analisa_usaha_tani/analisa_usaha_tani_page.dart';

class AnalisaUsahaTaniRoutes {
  AnalisaUsahaTaniRoutes._();

  static const analisaUsahaTani = '/analisa-usaha-tani';

  static final routes = [
    GetPage(
      name: analisaUsahaTani,
      page: () => const AnalisaUsahaTaniPage(),
      binding: AnalisaUsahaTaniBinding(),
    ),
  ];
}
