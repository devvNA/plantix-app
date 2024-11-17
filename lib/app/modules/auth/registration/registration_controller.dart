// ignore_for_file: unnecessary_overrides

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantix_app/app/core/extensions/snackbar_ext.dart';
import 'package:plantix_app/app/core/widgets/custom_snackbar.dart';
import 'package:plantix_app/app/data/repositories/auth_repository.dart';
import 'package:plantix_app/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegistrationController extends GetxController {
  // final storage = LocalStorageService();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final addressControllerc = TextEditingController();
  final phoneNumberController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final formField = GlobalKey<FormState>();
  final notVisible = true.obs;
  final isLoading = false.obs;
  final id = 0.obs;

  @override
  void onInit() {
    super.onInit();
  }

  doRegistration() async {
    isLoading(true);

    if (formField.currentState!.validate()) {
      final response = await AuthRepository().registerWithEmailPassword(
        name: nameController.text,
        address: addressControllerc.text,
        phoneNumber: phoneNumberController.text,
        photoUrl:
            "https://www.shutterstock.com/image-vector/vector-flat-illustration-grayscale-avatar-600nw-2281862025.jpg",
        email: emailController.text,
        password: passwordController.text,
        // phone: phoneNumberController.text,
      );

      response.fold((error) => Get.context!.showSnackBar(error, isError: true),
          (data) async {
        Get.back();
        await supabase.auth.signOut(scope: SignOutScope.global).then(
          (_) {
            snackbarSuccess(
              message: "Sukses",
              body: "Registrasi berhasil. Silahkan login!",
            );
          },
        );

        emailController.clear();
        passwordController.clear();
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

  // void onRegister() {
  //   isLoading(true);
  //   // Menyimpan object
  //   try {
  //     if (formField.currentState!.validate()) {
  //       // Mengambil daftar pengguna yang ada

  //       final user = UserModel(
  //         hasStore: false,
  //         id: Random().nextInt(1000000),
  //         name: nameController.text,
  //         email: emailController.text,
  //         address: addressControllerc.text,
  //         phoneNumber: phoneNumberController.text,
  //         password: passwordController.text,
  //         photoUrl: "",
  //       );

  //       // Menambahkan pengguna baru ke daftar
  //       // storage.addToList<UserModel>("User", user);

  //       dev.log("Pengguna baru ditambahkan: ${user.toString()}");

  //       Get.back();

  //       snackbarSuccess(
  //         message: "Sukses",
  //         body: "Pendaftaran berhasil",
  //       );

  //       // Membersihkan form
  //       emailController.clear();
  //       passwordController.clear();
  //       nameController.clear();
  //       addressControllerc.clear();
  //       phoneNumberController.clear();
  //       confirmPasswordController.clear();
  //     }
  //   } catch (e) {
  //     snackbarError(
  //       message: "Kesalahan",
  //       body: "Gagal melakukan pendaftaran",
  //     );
  //   }
  //   isLoading(false);
  // }

  void showUserList() {
    // final users = storage.getList<UserModel>("User");
    // dev.log("Show User: ${storage.getList<UserModel>("User").toString()}");
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
