// ignore_for_file: unnecessary_overrides

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plantix_app/app/core/services/upload_image_service.dart.dart';
import 'package:plantix_app/app/core/widgets/custom_snackbar.dart';
import 'package:plantix_app/app/data/repositories/my_store_repository.dart';
import 'package:plantix_app/app/modules/my_store/my_store_controller.dart';
import 'package:plantix_app/app/modules/profile/profile_controller.dart';
import 'package:plantix_app/main.dart';

class BuatTokoController extends GetxController {
  final storeNameController = TextEditingController();
  final storeAddressController =
      TextEditingController(text: user.currentUser?.address ?? "");
  final imageFile = Rx<XFile?>(null);
  final formKey = GlobalKey<FormState>();
  final storeImageUrl = "".obs;
  final isLoading = false.obs;
  final store = myStore.currentStore;

  //Ambil data jika Sudah Punya Toko
  bool get isEditMode => store != null;

  @override
  void onInit() {
    super.onInit();
    if (isEditMode) {
      storeNameController.text = store!.storeName;
      storeAddressController.text = store!.address;
      storeImageUrl.value = store!.storeImageUrl;
    }
  }

  Future<void> pickImage() async {
    isLoading.value = true;
    await uploadImage(bucketName: "stores", folderPath: "profiles")
        .then((value) {
      storeImageUrl.value = value ?? "";
    });
    isLoading.value = false;
  }

  Future<void> submitStore() async {
    if (formKey.currentState!.validate()) {
      isLoading.value = true;
      if (isEditMode) {
        await updateStore();
      } else {
        await createNewStore();
      }
      isLoading.value = false;
    }
  }

  Future<void> createNewStore() async {
    final result = await MyStoreRepository().createStore(
      storeName: storeNameController.text,
      address: storeAddressController.text,
      storeImageUrl: storeImageUrl.value,
    );

    result.fold((failure) {
      snackbarError(message: failure.message);
    }, (store) {
      Get.back();
      snackbarSuccess(
        message: "Sukses",
        body: "Toko ${store.storeName} berhasil dibuat",
      );
    });
  }

  Future<void> updateStore() async {
    final result = await MyStoreRepository().updateStore(
      storeName: storeNameController.text,
      address: storeAddressController.text,
      storeImageUrl: storeImageUrl.value,
    );

    result.fold((failure) {
      snackbarError(message: failure.message);
    }, (store) {
      Get.back();
      snackbarSuccess(
        message: "Sukses",
        body: "Toko berhasil diubah",
      );
    });
  }

  @override
  void onClose() async {
    super.onClose();
    if (isEditMode) {
      final myStoreController = Get.find<MyStoreController>();
      storeNameController.dispose();
      storeAddressController.dispose();
      // myStoreController.getStore();
    } else {
      final profileController = Get.find<ProfileController>();

      storeAddressController.dispose();
      profileController.isLoading = true;
      profileController.update();
      await user.loadUserData();
      profileController.update();
      profileController.isLoading = false;
    }
  }
}
