import 'package:get/get.dart';

import '../modules/history_transaction/history_transaction_binding.dart';
import '../modules/history_transaction/history_transaction_page.dart';

class HistoryTransactionRoutes {
  HistoryTransactionRoutes._();

  static const historyTransaction = '/history-transaction';

  static final routes = [
    GetPage(
      name: historyTransaction,
      page: () => const HistoryTransactionPage(),
      binding: HistoryTransactionBinding(),
    ),
  ];
}
