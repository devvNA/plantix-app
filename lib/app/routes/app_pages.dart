import 'auth_routes.dart';
import 'home_routes.dart';
import 'splash_screen_routes.dart';
import 'weather_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = '/splash-screen';

  static final routes = [
    ...HomeRoutes.routes,
    ...WeatherRoutes.routes,
    ...AuthRoutes.routes,
    ...SplashScreenRoutes.routes,
  ];
}
