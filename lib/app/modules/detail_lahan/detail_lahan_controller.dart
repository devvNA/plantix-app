// ignore_for_file: unnecessary_overrides

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantix_app/app/core/widgets/custom_snackbar.dart';
import 'package:plantix_app/app/data/models/field_model.dart';
import 'package:plantix_app/app/data/models/plant_model.dart';
import 'package:plantix_app/app/data/repositories/field_repository.dart';
import 'package:plantix_app/app/data/repositories/plant_repository.dart';
import 'package:plantix_app/app/modules/detail_lahan/widgets/bottom_sheet_add_plant.dart';
import 'package:plantix_app/app/modules/lahan_tanam/lahan_tanam_controller.dart';

class DetailLahanController extends GetxController {
  FieldModel field = Get.arguments;
  PlantModel? plant;
  final isScrolled = false.obs;
  final plantNameController = TextEditingController();
  final plantTypeController = TextEditingController();
  final isLoading = false.obs;
  final lahanTanamController = Get.find<LahanTanamController>();

  @override
  void onInit() {
    super.onInit();
    getPlant();
  }

  // Fungsi untuk memperbarui status scroll
  void updateScrollStatus(bool scrolled) {
    isScrolled.value = scrolled;
  }

  Future<void> getPlant() async {
    isLoading.value = true;
    final result = await PlantRepository().getPlant(
      fieldId: field.id,
    );
    result.fold((failure) {
      log("no plant");
    }, (data) {
      plant = data;
    });
    isLoading.value = false;
    update();
  }

  Future<void> addPlant() async {
    isLoading.value = true;
    final result = await PlantRepository().addPlant(
      fieldId: field.id,
      name: plantNameController.text,
      type: plantTypeController.text,
    );
    result.fold((failure) => snackbarError(message: failure.message), (r) {
      Get.back();
      snackbarSuccess(
        message: "Sukses",
        body: "Tanaman berhasil ditambahkan",
      );
    });
    await getPlant();
    isLoading.value = false;
  }

  void showAddPlantBottomSheet() {
    Get.bottomSheet(
      AddPlantBottomSheet(),
      elevation: 2,
    );
    if (Get.isBottomSheetOpen!) {
      plantNameController.clear();
      plantTypeController.clear();
    }
  }

  Future<void> deleteField() async {
    isLoading.value = true;
    final result = await FieldRepository().deleteField(field.id);
    if (result) {
      if (plant != null) {
        await deletePlant();
      }
      Get.back();
      snackbarSuccess(
        message: "Sukses",
        body: "Lahan berhasil dihapus",
      );
    }
    isLoading.value = false;
  }

  Future<void> deletePlant() async {
    isLoading.value = true;
    final result = await PlantRepository().deletePlant(plant!.id);
    if (result) {
      plant = null;
      snackbarSuccess(
        message: "Sukses",
        body: "Tanaman berhasil dihapus",
      );
    }
    update();
    isLoading.value = false;
  }

  // void addPlant() {
  //   isLoading.value = true;
  //   // Perbarui list lahan
  //   final index = Get.find<LahanTanamController>()
  //       .fieldList
  //       .indexWhere((element) => element.id == field?.id);

  //   if (index != -1) {
  //     Get.find<LahanTanamController>().fieldList[index] = field!;
  //     Get.find<LahanTanamController>().fieldList.refresh();

  //     snackbarSuccess(
  //       message: "Sukses",
  //       body: "Tanaman berhasil ditambahkan",
  //     );
  //   }
  //   isLoading.value = false;
  // }

  // Fungsi untuk mengedit lahan yang sudah ada
  // void editLahan(int id) {
  //   Get.find<LahanTanamController>().fieldList.add(field);
  //   Get.find<LahanTanamController>().fieldList.refresh();
  //   snackbarSuccess(
  //     message: "Sukses",
  //     body: "Lahan berhasil diperbarui",
  //   );
  // }

  // // Fungsi untuk menghapus lahan
  // void deleteLahan(int index) {
  //   Get.find<LahanTanamController>().deleteLahan(index);
  // }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    lahanTanamController.onRefresh();
    plantNameController.dispose();
    plantTypeController.dispose();
    update();
  }
}
