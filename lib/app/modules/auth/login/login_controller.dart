// ignore_for_file: unnecessary_overrides, unnecessary_null_comparison, void_checks

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantix_app/app/core/extensions/snackbar_ext.dart';
import 'package:plantix_app/app/core/services/db_services.dart';
import 'package:plantix_app/app/core/widgets/custom_snackbar.dart';
import 'package:plantix_app/app/data/repositories/auth_repository.dart';
import 'package:plantix_app/app/routes/home_routes.dart';
import 'package:plantix_app/main.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formField = GlobalKey<FormState>();
  final storage = LocalStorageService();
  final notVisible = true.obs;
  final isLoading = false.obs;
  final rememberMe = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadSavedCredentials();
  }

  /// Memuat kredensial yang tersimpan dari storage
  void _loadSavedCredentials() {
    try {
      rememberMe.value = storage.getData('REMEMBER_ME') ?? false;
      if (rememberMe.value) {
        emailController.text = storage.getData('REMEMBER_ME_EMAIL') ?? '';
        passwordController.text = storage.getData('REMEMBER_ME_PASSWORD') ?? '';
        log("email : ${emailController.text}");
        log("password : ${passwordController.text}");
      }
    } catch (e) {
      log('Error loading credentials: $e');
    }
  }

  /// Menyimpan kredensial ke storage
  void _saveCredentials() {
    try {
      if (rememberMe.value) {
        storage.saveData('REMEMBER_ME', true);
        storage.saveData('REMEMBER_ME_EMAIL', emailController.text.trim());
        storage.saveData(
          'REMEMBER_ME_PASSWORD',
          passwordController.text.trim(),
        );
      } else {
        _clearSavedCredentials();
      }
    } catch (e) {
      log('Error saving credentials: $e');
    }
  }

  /// Menghapus kredensial dari storage
  void _clearSavedCredentials() {
    try {
      storage.removeData('REMEMBER_ME');
      storage.removeData('REMEMBER_ME_EMAIL');
      storage.removeData('REMEMBER_ME_PASSWORD');
    } catch (e) {
      log('Error clearing credentials: $e');
    }
  }

  Future<void> doLogin() async {
    try {
      FocusScope.of(Get.context!).unfocus();
      isLoading(true);

      // Simpan kredensial sebelum login
      _saveCredentials();

      final response = await AuthRepository().loginWithEmailPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      response.fold(
        (error) {
          Get.back();
          Get.context!.showSnackBar(
            message: error,
            isError: true,
          );
        },
        (data) async {
          await user.loadUserData();
          if (user.hasStore) {
            await myStore.loadStoreData();
          }
          Get.offAllNamed(HomeRoutes.home);
          return snackbarSuccess(
            message: "Sukses",
            body: "Login berhasil. Selamat datang!",
          );
        },
      );
    } catch (e) {
      log('Error during login: $e');
      snackbarError(message: "Terjadi kesalahan saat login");
    } finally {
      isLoading(false);
    }
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
