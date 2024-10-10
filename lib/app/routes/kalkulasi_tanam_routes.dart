import 'package:get/get.dart';

import '../modules/kalkulasi_tanam/kalkulasi_tanam_binding.dart';
import '../modules/kalkulasi_tanam/kalkulasi_tanam_page.dart';

class KalkulasiTanamRoutes {
  KalkulasiTanamRoutes._();

  static const kalkulasiTanam = '/kalkulasi-tanam';

  static final routes = [
    GetPage(
      name: kalkulasiTanam,
      page: () => const KalkulasiTanamPage(),
      binding: KalkulasiTanamBinding(),
    ),
  ];
}
