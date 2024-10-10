// ignore_for_file: unnecessary_overrides

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantix_app/app/routes/home_routes.dart';

class RegistrationController extends GetxController {
  final emailController = TextEditingController(text: "tani@gmail.com");
  final passwordController = TextEditingController(text: "3242dsfs");
  final nameController = TextEditingController(text: "Tani");
  final addressControllerc = TextEditingController(text: "Jl. Raya No. 1");
  final formField = GlobalKey<FormState>();
  final notVisible = true.obs;
  final isTap = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  void doLogin() {
    printInfo(info: emailController.text);
    printInfo(info: passwordController.text);
    Get.offAllNamed(HomeRoutes.home);
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