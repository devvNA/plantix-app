// ignore_for_file: unnecessary_overrides

import 'dart:developer';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plantix_app/app/data/models/histori_transaksi_model.dart';

class DetailHistoryController extends GetxController {
  final isLoading = false.obs;
  HistoriTransaksi? historiData = Get.arguments;
  final fileName = ''.obs;
  final imageFile = <XFile>[].obs;
  final imageUrls = <String>[].obs;
  final picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    log(historiData.toString());
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    // final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    final pickedFile = await picker.pickMultiImage(imageQuality: 50);
    imageFile.value = pickedFile;
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
