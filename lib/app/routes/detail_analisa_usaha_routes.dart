import 'package:get/get.dart';

import '../modules/detail_analisa_usaha/detail_analisa_usaha_binding.dart';
import '../modules/detail_analisa_usaha/detail_analisa_usaha_page.dart';

class DetailAnalisaUsahaRoutes {
  DetailAnalisaUsahaRoutes._();

  static const detailAnalisaUsaha = '/detail-analisa-usaha';

  static final routes = [
    GetPage(
      name: detailAnalisaUsaha,
      page: () => const DetailAnalisaUsahaPage(),
      binding: DetailAnalisaUsahaBinding(),
    ),
  ];
}
