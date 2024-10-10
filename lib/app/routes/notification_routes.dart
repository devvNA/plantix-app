import 'package:get/get.dart';

import '../modules/notification/notification_binding.dart';
import '../modules/notification/notification_page.dart';

class NotificationRoutes {
  NotificationRoutes._();

  static const notification = '/notification';

  static final routes = [
    GetPage(
      name: notification,
      page: () => const NotificationPage(),
      binding: NotificationBinding(),
    ),
  ];
}
