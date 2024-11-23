import 'package:get/get.dart';

import 'help_desk_controller.dart';

class HelpDeskBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HelpDeskController>(
      () => HelpDeskController(),
    );
  }
}
