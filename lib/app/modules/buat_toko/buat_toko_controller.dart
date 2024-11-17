import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plantix_app/app/core/widgets/custom_snackbar.dart';

class BuatTokoController extends GetxController {
  final storeNameController = TextEditingController();
  final storeAddressController = TextEditingController();
  final imageFile = Rx<XFile?>(null);
  final formKey = GlobalKey<FormState>();


  void onCreateStore() {
    if (formKey.currentState!.validate()) {
      log("valid");
      snackbarSuccess(
        message: "Sukses",
        body: "Toko berhasil dibuat",
      );
      Get.back();
    }
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    imageFile.value = pickedFile;
  }


}
