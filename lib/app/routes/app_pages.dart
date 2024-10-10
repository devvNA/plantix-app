import 'auth_routes.dart';
import 'calendar_routes.dart';
import 'detail_lahan_routes.dart';
import 'home_routes.dart';
import 'kalkulasi_tanam_routes.dart';
import 'lahan_tanam_routes.dart';
import 'notification_routes.dart';
import 'profile_routes.dart';
import 'seed_products_routes.dart';
import 'splash_screen_routes.dart';
import 'analisa_usaha_tani_routes.dart';
import 'detail_analisa_usaha_routes.dart';
import 'artikel_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = '/splash-screen';

  static final routes = [
    ...HomeRoutes.routes,
    ...AuthRoutes.routes,
    ...SplashScreenRoutes.routes,
    ...SeedProductsRoutes.routes,
    ...NotificationRoutes.routes,
    ...ProfileRoutes.routes,
    ...LahanTanamRoutes.routes,
    ...CalendarRoutes.routes,
    ...DetailLahanRoutes.routes,
    ...KalkulasiTanamRoutes.routes,
		...AnalisaUsahaTaniRoutes.routes,
		...DetailAnalisaUsahaRoutes.routes,
		...ArtikelRoutes.routes,
  ];
}
