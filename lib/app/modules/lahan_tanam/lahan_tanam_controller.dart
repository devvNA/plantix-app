// ignore_for_file: unnecessary_overrides

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantix_app/app/core/widgets/custom_snackbar.dart';
import 'package:plantix_app/app/data/models/field_model.dart';
import 'package:plantix_app/app/data/models/plant_model.dart';
import 'package:plantix_app/app/data/models/region/city_model.dart';
import 'package:plantix_app/app/data/models/region/district_model.dart';
import 'package:plantix_app/app/data/models/region/province_model.dart';
import 'package:plantix_app/app/data/models/region/village_model.dart';
import 'package:plantix_app/app/data/repositories/region_repository.dart';
import 'package:plantix_app/app/modules/lahan_tanam/widgets/bottom_sheet_input.dart';

class LahanTanamController extends GetxController {
  final isScrolled = false.obs;
  final formKey = GlobalKey<FormState>();
  final lahanList = <Lahan>[].obs;

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
  final plantNameController = TextEditingController();
  final plantTypeController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    lahanList.addAll(getDummyLahanList());
  }

  // Fungsi untuk memperbarui status scroll
  void updateScrollStatus(bool scrolled) {
    isScrolled.value = scrolled;
  }

  getProvince() async {
    final data = await RegionRepository().getProvince();
    provinceList.value = data;
  }

  getCity(int provinceId) async {
    final data = await RegionRepository().getCity(provinceId: provinceId);
    cityList.value = data;
  }

  getDistrict(int cityId) async {
    final data = await RegionRepository().getDistrict(cityId: cityId);
    districtList.value = data;
  }

  getVillage(int districtId) async {
    final data = await RegionRepository().getVillage(districtId: districtId);
    villageList.value = data;
  }

  // Fungsi untuk menambahkan lahan baru
  void addLahan() {
    lahanList.add(Lahan(
      id: lahanList.length + 1,
      fieldName: namaController.text,
      fieldAddress: lokasiController.text +
          ", Kel. " +
          selectedVillage.value +
          ", Kec. " +
          selectedDistrict.value +
          ", " +
          selectedCity.value +
          ", " +
          selectedProvince.value,
      fieldArea: luasLahanController.text,
      plants: Plant(
        plantName: plantNameController.text,
        plantType: plantTypeController.text,
      ),
    ));
    lahanList.refresh();

    Get.back();
    CustomSnackBar.showCustomSuccessSnackBar(
        title: 'Sukses', message: 'Lahan berhasil ditambahkan');

    _clearInputFields();
  }

  // Fungsi untuk menghapus lahan
  void deleteLahan(int id) {
    // lahanList.removeAt(index);
    lahanList.removeWhere((element) => element.id == id);
    lahanList.refresh();
    Get.back();
    CustomSnackBar.showCustomSuccessSnackBar(
        title: 'Sukses', message: 'Lahan berhasil dihapus');
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
    plantNameController.clear();
    plantTypeController.clear();
  }

  void showAddLandBottomSheet() {
    Get.bottomSheet(AddLandBottomSheet());
    if (Get.isBottomSheetOpen!) {
      selectedProvinceId = null; // Reset provinsi yang dipilih
      selectedCityId = null; // Reset kota yang dipilih
      selectedDistrictId = null; // Reset kecamatan yang dipilih
      selectedVillageId = null; // Reset desa yang dipilih
      namaController.clear();
      luasLahanController.clear();
      lokasiController.clear();
      plantNameController.clear();
      plantTypeController.clear();
    }
  }

  List<Lahan> getDummyLahanList() {
    return [
      Lahan(
        id: 1,
        fieldName: 'Lahan Contoh',
        fieldArea: '150',
        fieldAddress:
            'JL DI Panjaitan No.128, Karangreja, Purwokerto Kidul, Kec. Purwokerto Sel., Kabupaten Banyumas, Jawa Tengah 53147',
        plants: Plant(
          plantName: 'Jagung',
          plantType: 'Manis',
        ),
      ),
    ];
  }
}
