// ignore_for_file: unnecessary_overrides

import 'dart:developer';

import 'package:get/get.dart';
import 'package:plantix_app/app/data/models/analisa_usaha_model.dart';
import 'package:plantix_app/app/data/repositories/analisa_usaha_tani_repository.dart';

class AnalisaUsahaTaniController extends GetxController {
  // final analisaUsahaList = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;
  final analisaUsahaList = <FarmingProductionAnalysisModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    getAnalisaUsahaTani();
    // loadDummyData();
  }

  // void loadDummyData() {
  //   analisaUsahaList.value = [
  //     {
  //       'id': 1,
  //       'field_id': 1,
  //       'field_name': 'Sawah Utara',
  //       'plant_type': 'Padi',
  //       'planting_date': '2024-09-27',
  //       'harvest_date': '2025-01-15',
  //       'harvest_quantity': 50.0,
  //       'net_income': 5000000.0,
  //       'expenses': 2000000.0,
  //     },
  //     {
  //       'field_id': 2,
  //       'id': 2,
  //       'field_name': 'Kebun Jagung Timur',
  //       'plant_type': 'Jagung',
  //       'planting_date': '2024-10-15',
  //       'harvest_date': '2025-02-20',
  //       'harvest_quantity': 70.0,
  //       'net_income': 3500000.0,
  //       'expenses': 1500000.0,
  //     },
  //     {
  //       'id': 3,
  //       'field_id': 3,
  //       'field_name': 'Kebun Sayur Selatan',
  //       'plant_type': 'Cabai',
  //       'planting_date': '2024-11-01',
  //       'harvest_date': '2025-02-15',
  //       'harvest_quantity': 30.0,
  //       'net_income': 4500000.0,
  //       'expenses': 1800000.0,
  //     }
  //   ];
  // }

  Future<void> getAnalisaUsahaTani() async {
    isLoading.value = true;
    final response = await AnalisaUsahaTaniRepository().getAnalisaUsahaTani();
    response.fold((failure) {
      log(failure.message);
    }, (data) {
      analisaUsahaList.value = data;
    });

    isLoading.value = false;
  }

  Future onRefresh() async {
    analisaUsahaList.clear();
    await getAnalisaUsahaTani();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
