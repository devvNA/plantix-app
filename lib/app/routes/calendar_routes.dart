import 'package:get/get.dart';

import '../modules/calendar/calendar_binding.dart';
import '../modules/calendar/calendar_page.dart';

class CalendarRoutes {
  CalendarRoutes._();

  static const calendar = '/calendar';

  static final routes = [
    GetPage(
      name: calendar,
      page: () => const CalendarPage(),
      binding: CalendarBinding(),
    ),
  ];
}
