import 'home_routes.dart';
import 'weather_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = '/home';

  static final routes = [
    ...HomeRoutes.routes,
		...WeatherRoutes.routes,
  ];
}
