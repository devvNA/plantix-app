import 'package:get/get.dart';

import '../modules/my_store/my_store_binding.dart';
import '../modules/my_store/my_store_page.dart';

class MyStoreRoutes {
  MyStoreRoutes._();

  static const myStore = '/my-store';

  static final routes = [
    GetPage(
      name: myStore,
      page: () => const MyStorePage(),
      binding: MyStoreBinding(),
    ),
  ];
}
