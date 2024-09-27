// ignore_for_file: unnecessary_overrides

import 'package:get/get.dart';
import 'package:taniku_app/app/routes/auth_routes.dart';

class SplashScreenController extends GetxController {
  //TODO: Implement SplashScreenController.

  @override
  void onInit() {
    super.onInit();
    _navigateToHome();
  }

  void _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 3));
    Get.offNamed(AuthRoutes.login); // Ganti dengan rute halaman utama Anda
  }

  @override
  void onClose() {
    super.onClose();
  }
}
