// ignore_for_file: unnecessary_overrides

import 'dart:developer' as dev;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantix_app/app/core/helpers/db_services.dart';
import 'package:plantix_app/app/core/widgets/custom_snackbar.dart';
import 'package:plantix_app/app/data/models/user_model.dart';

class RegistrationController extends GetxController {
  final storage = LocalStorageService();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final addressControllerc = TextEditingController();
  final phoneNumberController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final formField = GlobalKey<FormState>();
  final notVisible = true.obs;
  final isTap = false.obs;
  final id = 0.obs;

  @override
  void onInit() {
    super.onInit();
  }

  void onRegister() {
    // Menyimpan object
    try {
      if (formField.currentState!.validate()) {
        // Mengambil daftar pengguna yang ada

        final user = UserModel(
          id: Random().nextInt(1000000),
          name: nameController.text,
          email: emailController.text,
          address: addressControllerc.text,
          phoneNumber: phoneNumberController.text,
          password: passwordController.text,
          photoUrl: "",
        );

        // Menambahkan pengguna baru ke daftar
        storage.addToList<UserModel>("User", user);

        dev.log("Pengguna baru ditambahkan: ${user.toString()}");

        Get.back();
        CustomSnackBar.showCustomSuccessSnackBar(
          title: "Success",
          message: "Pendaftaran berhasil",
        );
        // Membersihkan form
        emailController.clear();
        passwordController.clear();
        nameController.clear();
        addressControllerc.clear();
        phoneNumberController.clear();
        confirmPasswordController.clear();
      }
    } catch (e) {
      CustomSnackBar.showCustomErrorSnackBar(
        title: "Error",
        message: "Gagal melakukan pendaftaran",
      );
    }
  }

  void showUserList() {
    // final users = storage.getList<UserModel>("User");
    dev.log("Show User: ${storage.getList<UserModel>("User").toString()}");
    // dev.log("Jumlah total pengguna: ${users?.length}");
    // dev.log(storage.getData("LoggedInUser").toString());
    // storage.clearAll();
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
