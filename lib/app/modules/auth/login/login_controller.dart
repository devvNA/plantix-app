// ignore_for_file: unnecessary_overrides, unnecessary_null_comparison, void_checks

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantix_app/app/core/extensions/snackbar_ext.dart';
import 'package:plantix_app/app/core/widgets/custom_snackbar.dart';
import 'package:plantix_app/app/data/repositories/auth_repository.dart';
import 'package:plantix_app/app/routes/home_routes.dart';
import 'package:plantix_app/main.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController(text: "john@gmail.com");
  final passwordController = TextEditingController(text: "john12345");
  final formField = GlobalKey<FormState>();
  // final storage = LocalStorageService();
  final notVisible = true.obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  Future doLogin() async {
    isLoading(true);

    if (formField.currentState!.validate()) {
      final response = await AuthRepository().loginWithEmailPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      response.fold((error) => Get.context!.showSnackBar(error, isError: true),
          (data) async {
        await user.loadUserData();
        log("${data.session?.user.lastSignInAt}");
        Get.offAllNamed(HomeRoutes.home);
        emailController.clear();
        passwordController.clear();
        return snackbarSuccess(
          message: "Sukses",
          body: "Login berhasil. Selamat datang!",
        );
      });
      //     .then((value) {
      //   if (value != null) {
      //     Get.offAllNamed(HomeRoutes.home);
      //     snackbarSuccess(
      //       message: "Sukses",
      //       body: "Login berhasil. Selamat datang!",
      //     );
      //     emailController.clear();
      //     passwordController.clear();
      //   }
      //   snackbarError(message: value.toString());
      // });
    }
    isLoading(false);
  }

  Future<void> getUser() async {
    try {
      // final userId = supabase.auth.currentSession!.user.id;
      // final data =
      //     await supabase.from('users').select().eq('id', userId).single();
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    emailController.dispose();
    passwordController.dispose();
  }
}
