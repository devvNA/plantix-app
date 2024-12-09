import 'package:get/get.dart';

import '../modules/detail_history/detail_history_binding.dart';
import '../modules/detail_history/detail_history_page.dart';

class DetailHistoryRoutes {
  DetailHistoryRoutes._();

  static const detailHistory = '/detail-history';

  static final routes = [
    GetPage(
      name: detailHistory,
      page: () => const DetailHistoryPage(),
      binding: DetailHistoryBinding(),
    ),
  ];
}
