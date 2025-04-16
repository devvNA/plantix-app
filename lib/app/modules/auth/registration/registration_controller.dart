// ignore_for_file: unnecessary_overrides

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantix_app/app/core/extensions/snackbar_ext.dart';
import 'package:plantix_app/app/core/widgets/custom_snackbar.dart';
import 'package:plantix_app/app/data/repositories/auth_repository.dart';
import 'package:plantix_app/app/routes/home_routes.dart';
import 'package:plantix_app/main.dart';

class RegistrationController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final formField = GlobalKey<FormState>();
  final notVisible = true.obs;
  final notVisibleConfirm = true.obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> doRegistration() async {
    FocusScope.of(Get.context!).unfocus();
    isLoading(true);

    if (formField.currentState!.validate()) {
      final response = await AuthRepository().registerWithEmailPassword(
        email: emailController.text,
        password: passwordController.text,
        name: nameController.text,
        avatarUrl: "",
      );

      response.fold(
        (error) {
          Get.back();
          Get.context!.showCustomSnackBar(message: error, isError: true);
        },
        (data) async {
          await user.loadUserData().then((value) {
            Get.offAllNamed(HomeRoutes.home);
            return snackbarSuccess(
              message: "Sukses",
              body: "Registrasi berhasil. Selamat datang!",
            );
          });
        },
      );
    }
    isLoading(false);
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
    nameController.dispose();
    confirmPasswordController.dispose();
  }
}
