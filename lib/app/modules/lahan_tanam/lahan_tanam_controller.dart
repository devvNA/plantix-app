// ignore_for_file: unnecessary_overrides

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantix_app/app/core/widgets/custom_snackbar.dart';
import 'package:plantix_app/app/data/models/field_model.dart';
import 'package:plantix_app/app/data/models/region/city_model.dart';
import 'package:plantix_app/app/data/models/region/district_model.dart';
import 'package:plantix_app/app/data/models/region/province_model.dart';
import 'package:plantix_app/app/data/models/region/village_model.dart';
import 'package:plantix_app/app/data/repositories/field_repository.dart';
import 'package:plantix_app/app/data/repositories/region_repository.dart';
import 'package:plantix_app/app/modules/lahan_tanam/widgets/bottom_sheet_input.dart';

class LahanTanamController extends GetxController {
  final isScrolled = false.obs;
  final formKey = GlobalKey<FormState>();
  final fieldList = <FieldModel>[].obs;
  final isLoading = false.obs;
  final isLoadingProvince = false.obs;
  final isLoadingCity = false.obs;
  final isLoadingDistrict = false.obs;
  // final isLoadingVillage = false.obs;

  final provinceList = <ProvinceModel>[].obs;
  final cityList = <CityModel>[].obs;
  final districtList = <DistrictModel>[].obs;
  final villageList = <VillageModel>[].obs;

  final namaController = TextEditingController();
  final luasLahanController = TextEditingController();
  final lokasiController = TextEditingController();

  String? selectedProvinceId;
  String? selectedCityId;
  String? selectedDistrictId;
  String? selectedVillageId;

  final selectedProvince = ''.obs;
  final selectedCity = ''.obs;
  final selectedDistrict = ''.obs;
  final selectedVillage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // lahanList.addAll(getDummyLahanList());
    getLahan();
  }

  // Fungsi untuk menambahkan lahan baru
  Future<void> addLahan() async {
    isLoading.value = true;
    final data = await FieldRepository().createField(
      fieldName: namaController.text,
      size: double.parse(luasLahanController.text),
      address:
          "${lokasiController.text}, Kecamatan ${selectedDistrict.value}, ${selectedCity.value}, ${selectedProvince.value}."
              .split(', ')
              .map((word) => word.capitalize)
              .join(', '),
    );

    data.fold(
      (failure) => snackbarError(message: "Gagal", body: failure.message),
      (value) {
        Get.back();
        onRefresh();
        snackbarSuccess(message: "Sukses", body: "Lahan berhasil ditambahkan");
      },
    );
    _clearInputFields();
    isLoading.value = false;
  }

  Future<void> getLahan() async {
    isLoading.value = true;
    final data = await FieldRepository().getMyFields();
    data.fold(
      (failure) {
        return snackbarError(message: "Gagal", body: failure.message);
      },
      (value) {
        fieldList.addAll(value);
      },
    );
    fieldList.refresh();
    isLoading.value = false;
  }

  Future onRefresh() async {
    fieldList.clear();
    await getLahan();
  }

  // Fungsi untuk memperbarui status scroll
  void updateScrollStatus(bool scrolled) {
    isScrolled.value = scrolled;
  }

  getProvince() async {
    isLoadingProvince.value = true;
    final data = await RegionRepository().getProvince();
    provinceList.value = data;
    isLoadingProvince.value = false;
  }

  getCity(int provinceId) async {
    isLoadingCity.value = true;
    final data = await RegionRepository().getCity(provinceId: provinceId);
    cityList.value = data;
    isLoadingCity.value = false;
  }

  getDistrict(int cityId) async {
    isLoadingDistrict.value = true;
    final data = await RegionRepository().getDistrict(cityId: cityId);
    districtList.value = data;
    isLoadingDistrict.value = false;
  }

  // getVillage(int districtId) async {
  //   isLoading.value = true;
  //   final data = await RegionRepository().getVillage(districtId: districtId);
  //   villageList.value = data;
  //   isLoading.value = false;
  // }

  // void addLahan() {
  //   isLoading.value = true;
  //   lahanList.add(Lahan(
  //     id: lahanList.length + 1,
  //     fieldName: namaController.text,
  //     fieldAddress:
  //         "${lokasiController.text}, Kecamatan ${selectedDistrict.value}, ${selectedCity.value}, ${selectedProvince.value}",
  //     fieldArea: luasLahanController.text,
  //     // plants: PlantModel(
  //     //   plantName: plantNameController.text,
  //     //   plantType: plantTypeController.text,
  //     // ),
  //   ));
  //   lahanList.refresh();

  //   Get.back();
  //   snackbarSuccess(
  //     message: "Sukses",
  //     body: "Lahan berhasil ditambahkan",
  //   );

  //   _clearInputFields();
  //   isLoading.value = false;
  // }

  // Fungsi untuk menghapus lahan
  void deleteLahan(int id) {
    isLoading.value = true;
    // lahanList.removeAt(index);
    // lahanList.removeWhere((element) => element.id == id);
    // lahanList.refresh();
    Get.back();
    snackbarSuccess(message: "Sukses", body: "Lahan berhasil dihapus");
    isLoading.value = false;
  }

  // Membersihkan field input setelah penambahan lahan
  void _clearInputFields() {
    selectedProvinceId = null; // Reset provinsi yang dipilih
    provinceList.clear(); // Kosongkan daftar provinsi
    selectedCityId = null; // Reset kota yang dipilih
    cityList.clear(); // Kosongkan daftar kota
    selectedDistrictId = null; // Reset kecamatan yang dipilih
    districtList.clear(); // Kosongkan daftar kecamatan
    selectedVillageId = null; // Reset desa yang dipilih
    villageList.clear(); // Kosongkan daftar desa

    namaController.clear();
    luasLahanController.clear();
    lokasiController.clear();
    // plantNameController.clear();
    // plantTypeController.clear();
  }

  void showAddLandBottomSheet() {
    Get.bottomSheet(AddLandBottomSheet(), elevation: 3);
    if (Get.isBottomSheetOpen!) {
      selectedProvinceId = null; // Reset provinsi yang dipilih
      selectedCityId = null; // Reset kota yang dipilih
      selectedDistrictId = null; // Reset kecamatan yang dipilih
      selectedVillageId = null; // Reset desa yang dipilih
      namaController.clear();
      luasLahanController.clear();
      lokasiController.clear();
      // plantNameController.clear();
      // plantTypeController.clear();
    }
  }

  // List<Lahan> getDummyLahanList() {
  //   return [
  //     Lahan(
  //         id: 1,
  //         fieldName: 'Lahan Contoh',
  //         fieldArea: '150',
  //         fieldAddress:
  //             'JL DI Panjaitan No.128, Karangreja, Purwokerto Kidul, Kec. Purwokerto Sel., Kabupaten Banyumas, Jawa Tengah 53147'
  // plants: PlantModel(
  //   plantName: 'Jagung',
  //   plantType: 'Manis',
  // ),
  //         ),
  //   ];
  // }

  @override
  void onClose() {
    super.onClose();
  }
}
