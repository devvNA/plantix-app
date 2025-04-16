// ignore_for_file: unnecessary_overrides

import 'package:get/get.dart';
import 'package:plantix_app/app/core/extensions/snackbar_ext.dart';
import 'package:plantix_app/app/core/widgets/custom_snackbar.dart';
import 'package:plantix_app/app/data/repositories/profile_repository.dart';
import 'package:plantix_app/app/modules/profile/profile_controller.dart';
import 'package:plantix_app/main.dart';

class EditProfileController extends GetxController {
  final _profileRepo = ProfileRepository();
  final isLoading = false.obs;
  final profileController = Get.find<ProfileController>();

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> updateName(String name) async {
    final result = await _profileRepo.updateUserData(name: name);
    result.fold((failure) => Get.snackbar('Error', failure.toString()), (
      updatedUser,
    ) {
      Get.context!.showCustomSnackBar(
        message: "Nama berhasil diubah",
        isError: false,
      );
      onRefresh();
    });
  }

  Future<void> updateEmail(String email) async {
    final result = await _profileRepo.updateUserEmail(email);
    result.fold(
      (failure) => Get.context!.showCustomSnackBar(
        message: failure.message,
        isError: true,
      ),
      (updatedUser) {
        Get.context!.showCustomSnackBar(
          message:
              "Silakan periksa email $email Anda untuk konfirmasi perubahan alamat email",
          duration: 3.seconds,
        );
        onRefresh();
      },
    );
  }

  Future<void> updateAddress(String address) async {
    final result = await _profileRepo.updateUserData(address: address);
    result.fold((failure) => snackbarError(message: failure.message), (
      updatedUser,
    ) {
      Get.context!.showCustomSnackBar(
        message: "Alamat berhasil diubah",
        isError: false,
      );
      onRefresh();
    });
  }

  Future<void> updatePhone(String phone) async {
    final result = await _profileRepo.updateUserData(phoneNumber: phone);
    result.fold(
      (failure) => Get.context!.showCustomSnackBar(
        message: failure.message,
        isError: true,
      ),
      (updatedUser) {
        Get.context!.showCustomSnackBar(
          message: "Nomor telepon berhasil diubah",
          isError: false,
        );
        onRefresh();
      },
    );
  }

  Future<void> onRefresh() async {
    isLoading.value = true;
    await user.loadUserData();
    isLoading.value = false;
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() async {
    super.onClose();

    profileController.isLoading = true;
    profileController.update();
    await user.loadUserData();
    profileController.update();
    profileController.isLoading = false;
  }
}
