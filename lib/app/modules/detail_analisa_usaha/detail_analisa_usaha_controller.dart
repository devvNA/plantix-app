import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantix_app/app/modules/detail_analisa_usaha/widgets/bottom_sheet_spend.dart';

class DetailAnalisaUsahaController extends GetxController {
  TextEditingController spendController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController harvestController = TextEditingController();

  showAddSpendBottomSheet() {
    Get.bottomSheet(AddSpendBottomSheet());
  }

  @override
  void onInit() {
    super.onInit();
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
