// ignore_for_file: unnecessary_overrides

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ArtikelController extends GetxController {
  // Tambahkan controller scroll dan variable isVisible
  final ScrollController scrollController = ScrollController();
  final RxBool isVisible = true.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
