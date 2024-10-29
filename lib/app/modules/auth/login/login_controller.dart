// ignore_for_file: unnecessary_overrides, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantix_app/app/core/helpers/db_services.dart';
import 'package:plantix_app/app/core/widgets/custom_snackbar.dart';
import 'package:plantix_app/app/routes/home_routes.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController(text: "tani@gmail.com");
  final passwordController = TextEditingController(text: "tani12345");
  final formField = GlobalKey<FormState>();
  final storage = LocalStorageService();
  final notVisible = true.obs;
  final isTap = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  void doLogin() {
    if (formField.currentState!.validate()) {
      try {
        // UserModel loggedInUser = storage.getList<UserModel>("User")!.firstWhere(
        //       (u) =>
        //           u.email == emailController.text &&
        //           u.password == passwordController.text,
        //     );

        // // // Menyimpan data pengguna yang sedang login
        // storage.saveData("LoggedInUser", loggedInUser.id);
        // // Menampilkan informasi pengguna yang sedang login
        // log("Pengguna yang sedang login: ${loggedInUser.toString()}");

        // Navigasi ke halaman utama atau dashboard
        Get.offAllNamed(HomeRoutes.home);
        // Login berhasil
        CustomSnackBar.showCustomSuccessSnackBar(
          title: "Berhasil",
          message: "Login berhasil. Selamat datang!",
        );

        emailController.clear();
        passwordController.clear();
      } catch (e) {
        // User tidak ditemukan
        CustomSnackBar.showCustomErrorSnackBar(
          title: "Kesalahan",
          message: "Email atau kata sandi salah",
        );
      }
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
