// ignore_for_file: unnecessary_overrides

import 'dart:async';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:plantix_app/app/core/services/db_services.dart';
import 'package:plantix_app/app/core/widgets/custom_snackbar.dart';
import 'package:plantix_app/app/routes/auth_routes.dart';
import 'package:plantix_app/app/routes/home_routes.dart';
import 'package:plantix_app/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SplashScreenController extends GetxController {
  final storage = LocalStorageService();
  late final StreamSubscription<AuthState> authStateSubscription;
  String? savedUser;
  final isLoading = false.obs;
  final redirecting = false.obs;

  @override
  void onInit() async {
    await Future.delayed(const Duration(seconds: 1));
    // await supabase.auth.signOut();
    // getValidationData().whenComplete(() async {
    //   if (savedUser != null) {
    //     await user.loadUserData();
    //     Get.offNamed(HomeRoutes.home);
    //   } else {
    //     Get.offNamed(AuthRoutes.login);
    //   }
    // });
    authStateSubscription = supabase.auth.onAuthStateChange.listen(
      (data) async {
        try {
          // Cek jika sedang dalam proses redirect
          if (redirecting()) return;

          final session = data.session;
          redirecting.value = true;

          if (session != null) {
            await user.loadUserData();
            Get.offAllNamed(HomeRoutes.home);
          } else {
            Get.offAllNamed(AuthRoutes.login);
          }
        } catch (error) {
          redirecting.value = false;
          final message = error is AuthException
              ? error.message
              : 'Terjadi kesalahan yang tidak diharapkan';

          Get.offAllNamed(AuthRoutes.login);
          snackbarError(message: message);
        }
      },
    );

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
