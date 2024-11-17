import 'add_product_routes.dart';
import 'analisa_usaha_tani_routes.dart';
import 'artikel_routes.dart';
import 'auth_routes.dart';
import 'buat_toko_routes.dart';
import 'calendar_routes.dart';
import 'cart_routes.dart';
import 'checkout_routes.dart';
import 'detail_analisa_usaha_routes.dart';
import 'detail_lahan_routes.dart';
import 'detail_product_routes.dart';
import 'home_routes.dart';
import 'kalkulasi_tanam_routes.dart';
import 'lahan_tanam_routes.dart';
import 'list_transaction_routes.dart';
import 'my_store_routes.dart';
import 'notification_routes.dart';
import 'profile_routes.dart';
import 'sales_routes.dart';
import 'splash_screen_routes.dart';
import 'my_products_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = '/splash-screen';

  static final routes = [
    ...HomeRoutes.routes,
    ...AuthRoutes.routes,
    ...SplashScreenRoutes.routes,
    ...NotificationRoutes.routes,
    ...ProfileRoutes.routes,
    ...LahanTanamRoutes.routes,
    ...CalendarRoutes.routes,
    ...DetailLahanRoutes.routes,
    ...KalkulasiTanamRoutes.routes,
    ...AnalisaUsahaTaniRoutes.routes,
    ...DetailAnalisaUsahaRoutes.routes,
    ...ArtikelRoutes.routes,
    ...SalesRoutes.routes,
    ...AddProductRoutes.routes,
    ...CartRoutes.routes,
    ...MyStoreRoutes.routes,
    ...DetailProductRoutes.routes,
    ...CheckoutRoutes.routes,
    ...HistoryTransactionRoutes.routes,
    ...BuatTokoRoutes.routes,
		...MyProductsRoutes.routes,
  ];
}
