import 'package:get/get.dart';

import '../modules/detail_lahan/detail_lahan_binding.dart';
import '../modules/detail_lahan/detail_lahan_page.dart';

class DetailLahanRoutes {
  DetailLahanRoutes._();

  static const detailLahan = '/detail-lahan';

  static final routes = [
    GetPage(
      name: detailLahan,
      page: () => const DetailLahanPage(),
      binding: DetailLahanBinding(),
    ),
  ];
}
