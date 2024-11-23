import 'package:get/get.dart';

import '../modules/help_desk/help_desk_binding.dart';
import '../modules/help_desk/help_desk_page.dart';

class HelpDeskRoutes {
  HelpDeskRoutes._();

  static const helpDesk = '/help-desk';

  static final routes = [
    GetPage(
      name: helpDesk,
      page: () => const HelpDeskPage(),
      binding: HelpDeskBinding(),
    ),
  ];
}
