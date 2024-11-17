// ignore_for_file: unnecessary_overrides

import 'dart:developer';

import 'package:get/get.dart';
import 'package:plantix_app/app/core/services/db_services.dart';
import 'package:plantix_app/app/routes/auth_routes.dart';
import 'package:plantix_app/app/routes/home_routes.dart';
import 'package:plantix_app/main.dart';

class SplashScreenController extends GetxController {
  final storage = LocalStorageService();
  String? savedUser;

  @override
  void onInit() async {
    await Future.delayed(const Duration(seconds: 1));
    getValidationData().whenComplete(() async {
      if (savedUser != null) {
        await user.loadUserData();
        Get.offNamed(HomeRoutes.home);
      } else {
        Get.offNamed(AuthRoutes.login);
      }
    });
    storage.clearAll();
    super.onInit();
  }

  Future<void> getValidationData() async {
    final session = supabase.auth.currentSession;
    savedUser = session?.accessToken;
    log("Token: ${session?.accessToken}");
    // var obtainedUser = await storage.getData("LoggedInUser");
    // savedUser = obtainedUser;
    // log("User: $savedUser");
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
