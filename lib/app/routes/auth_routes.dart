import 'package:get/get.dart';

import '../modules/auth/login/login_binding.dart';
import '../modules/auth/login/login_page.dart';
import '../modules/auth/registration/registration_binding.dart';
import '../modules/auth/registration/registration_page.dart';

class AuthRoutes {
  AuthRoutes._();

  static const login = '/auth/login';
  static const registration = '/auth/registration';

  static final routes = [
    GetPage(
      name: login,
      page: () => const LoginPage(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: registration,
      page: () => const RegistrationPage(),
      binding: RegistrationBinding(),
    ),
  ];
}
