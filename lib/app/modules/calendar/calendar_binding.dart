import 'package:get/get.dart';
import 'package:plantix_app/app/modules/calendar/calendar_controller.dart';

class CalendarBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CalendarController>(
      () => CalendarController(),
    );
  }
}
