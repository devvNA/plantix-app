import 'package:get/get.dart';

import 'history_transaction_controller.dart';

class HistoryTransactionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HistoryTransactionController>(
      () => HistoryTransactionController(),
    );
  }
}
