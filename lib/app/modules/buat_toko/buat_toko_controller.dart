// ignore_for_file: unnecessary_overrides

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plantix_app/app/core/exceptions/exceptions.dart';
import 'package:plantix_app/app/core/services/upload_image_service.dart.dart';
import 'package:plantix_app/app/core/widgets/custom_snackbar.dart';
import 'package:plantix_app/app/data/models/store_model.dart';
import 'package:plantix_app/app/data/repositories/my_store_repository.dart';
import 'package:plantix_app/app/modules/profile/profile_controller.dart';
import 'package:plantix_app/main.dart';

/// Controller untuk mengelola halaman buat dan edit toko
class BuatTokoController extends GetxController {
  // Form controllers
  final storeNameController = TextEditingController();
  final storeAddressController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  // Data state
  final imageFile = Rx<XFile?>(null);
  final storeImageUrl = "".obs;
  final isLoading = false.obs;
  final Rx<MyStoreModel?> _store = Rx<MyStoreModel?>(null);
  MyStoreModel? get store => _store.value;

  // Variabel untuk melacak perubahan pada form
  final hasChanges = false.obs;
  String _initialStoreName = "";
  String _initialStoreAddress = "";
  String _initialImageUrl = "";

  // Repositori untuk mengakses data toko
  final _repository = MyStoreRepository();

  //Ambil data jika Sudah Punya Toko
  bool get isEditMode => store != null;

  @override
  void onInit() {
    super.onInit();
    // Kosongkan field di sini
    _resetFormFields();
    _loadInitialData();

    // Tambahkan listener untuk memantau perubahan pada form
    _setupFormListeners();
  }

  /// Menyiapkan listener untuk memantau perubahan pada form
  void _setupFormListeners() {
    storeNameController.addListener(_checkFormChanges);
    storeAddressController.addListener(_checkFormChanges);
    // Untuk image perlu dimonitor melalui value change pada storeImageUrl
    ever(storeImageUrl, (_) => _checkFormChanges());
  }

  /// Memeriksa apakah ada perubahan pada form
  void _checkFormChanges() {
    if (isEditMode) {
      hasChanges.value =
          storeNameController.text != _initialStoreName ||
          storeAddressController.text != _initialStoreAddress ||
          storeImageUrl.value != _initialImageUrl;
    } else {
      // Untuk mode buat toko baru, cek apakah ada isian
      hasChanges.value =
          storeNameController.text.isNotEmpty ||
          storeAddressController.text.isNotEmpty ||
          storeImageUrl.value.isNotEmpty;
    }
  }

  /// Memeriksa apakah ada perubahan yang perlu disimpan
  /// Mengembalikan true jika ada perubahan, false jika tidak ada
  bool hasUnsavedChanges() {
    return hasChanges.value;
  }

  /// Reset semua field form ke kondisi kosong
  void _resetFormFields() {
    storeNameController.clear();
    storeAddressController.clear();
    storeImageUrl.value = "";
    imageFile.value = null;
    hasChanges.value = false;
  }

  /// Memuat data awal untuk form
  Future<void> _loadInitialData() async {
    isLoading(true);

    // Isi form dengan data toko jika dalam mode edit
    _store.value = myStore.currentStore;

    if (isEditMode) {
      storeNameController.text = store!.storeName;
      storeAddressController.text = store!.address;
      storeImageUrl.value = store!.storeImageUrl;

      // Simpan nilai awal untuk perbandingan
      _initialStoreName = store!.storeName;
      _initialStoreAddress = store!.address;
      _initialImageUrl = store!.storeImageUrl;
    } else {
      // Isi alamat dengan alamat user saat ini jika dalam mode buat toko
      final userAddress = user.currentUser?.address ?? "";
      storeAddressController.text = userAddress;

      // Simpan nilai awal untuk perbandingan
      _initialStoreName = "";
      _initialStoreAddress = userAddress;
      _initialImageUrl = "";
    }

    isLoading(false);

    // Setelah mengambil data, atur hasChanges ke false
    hasChanges.value = false;
  }

  /// Memilih gambar dari galeri
  Future<void> pickImage() async {
    try {
      isLoading.value = true;
      final result = await uploadImage(
        bucketName: "stores",
        folderPath: "profiles",
      );
      if (result != null) {
        storeImageUrl.value = result;
      }
    } catch (e) {
      snackbarError(message: "Gagal memilih gambar: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// Menyimpan data toko ke server
  Future<void> submitStore() async {
    if (!formKey.currentState!.validate()) return;

    try {
      isLoading.value = true;
      final result =
          isEditMode ? await _updateStore() : await _createNewStore();

      result.fold((failure) => snackbarError(message: failure.message), (
        store,
      ) {
        // Perbarui data di StoreManager
        _refreshStoreData(store);

        // Reset status perubahan setelah berhasil menyimpan
        hasChanges.value = false;

        Get.back();
        snackbarSuccess(
          message: "Sukses",
          body:
              isEditMode
                  ? "Toko berhasil diubah"
                  : "Toko ${store.storeName} berhasil dibuat",
        );
      });
    } finally {
      isLoading.value = false;
    }
  }

  /// Membuat toko baru
  Future<Either<Failure, MyStoreModel>> _createNewStore() async {
    return await _repository.createStore(
      storeName: storeNameController.text,
      address: storeAddressController.text,
      storeImageUrl: storeImageUrl.value,
    );
  }

  /// Memperbarui data toko yang sudah ada
  Future<Either<Failure, MyStoreModel>> _updateStore() async {
    return await _repository.updateStore(
      storeName: storeNameController.text,
      address: storeAddressController.text,
      storeImageUrl: storeImageUrl.value,
    );
  }

  /// Memperbarui data toko di manager dan controller lain
  Future<void> _refreshStoreData(MyStoreModel store) async {
    // Memperbarui data di Manager secara langsung tanpa API call tambahan
    myStore.updateStoreLocalData(store);

    // Memastikan data profil terupdate (untuk status has_store)
    await user.loadUserData();

    // Memperbarui controller profil jika ada
    if (Get.isRegistered<ProfileController>()) {
      final profileController = Get.find<ProfileController>();
      profileController.update();
    }
  }

  @override
  void onClose() {
    // Pembersihan resources
    storeNameController.dispose();
    storeAddressController.dispose();
    super.onClose();
  }
}
