// ignore_for_file: unnecessary_overrides

import 'package:get/get.dart';
import 'package:plantix_app/app/routes/auth_routes.dart';

class SplashScreenController extends GetxController {
  //TODO: Implement SplashScreenController.

  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(milliseconds: 1500), () {
      Get.offAllNamed(AuthRoutes.login);
    });
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
