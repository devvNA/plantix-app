import 'package:get/get.dart';

import '../modules/lahan_tanam/lahan_tanam_binding.dart';
import '../modules/lahan_tanam/lahan_tanam_page.dart';

class LahanTanamRoutes {
  LahanTanamRoutes._();

  static const lahanTanam = '/lahan-tanam';

  static final routes = [
    GetPage(
      name: lahanTanam,
      page: () => const LahanTanamPage(),
      binding: LahanTanamBinding(),
    ),
  ];
}
