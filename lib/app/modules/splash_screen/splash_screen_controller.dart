// ignore_for_file: unnecessary_overrides

import 'dart:developer';

import 'package:get/get.dart';
import 'package:plantix_app/app/core/helpers/db_services.dart';
import 'package:plantix_app/app/routes/auth_routes.dart';
import 'package:plantix_app/app/routes/home_routes.dart';

class SplashScreenController extends GetxController {
  final storage = LocalStorageService();
  int? savedUser;

  @override
  void onInit() {
    super.onInit();
    storage.clearAll();

    getValidationData().whenComplete(() async {
      if (savedUser != null) {
        await UserManager().getUser();
        Get.offNamed(HomeRoutes.home);
      } else {
        Future.delayed(const Duration(milliseconds: 1500), () {
          Get.offAllNamed(AuthRoutes.login);
        });
      }
    });
  }

  Future<void> getValidationData() async {
    var obtainedUser = await storage.getData("LoggedInUser");
    savedUser = obtainedUser;
    log("User: $savedUser");
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
