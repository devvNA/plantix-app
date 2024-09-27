import 'package:get/get.dart';

import '../modules/weather/weather_binding.dart';
import '../modules/weather/weather_page.dart';

class WeatherRoutes {
  WeatherRoutes._();

  static const weather = '/weather';

  static final routes = [
    GetPage(
      name: weather,
      page: () => const WeatherPage(),
      binding: WeatherBinding(),
    ),
  ];
}
