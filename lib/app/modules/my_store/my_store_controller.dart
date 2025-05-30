// ignore_for_file: unnecessary_overrides

import 'dart:developer';

import 'package:get/get.dart';
import 'package:plantix_app/app/data/models/store_model.dart';
import 'package:plantix_app/app/modules/profile/profile_controller.dart';
import 'package:plantix_app/main.dart';

/// Controller untuk mengelola halaman Toko Saya
class MyStoreController extends GetxController {
  final isLoading = false.obs;
  final saldo = 75000.0.obs;
  final processingSales = 10;
  final completedSales = 20;
  final canceledSales = 30;

  /// Data toko yang sedang aktif
  final Rx<MyStoreModel?> storeData = Rx<MyStoreModel?>(null);
  MyStoreModel? get store => storeData.value;

  final profileController = Get.find<ProfileController>();
  final productCount = 0.obs;

  // Dummy data untuk dashboard
  var totalSales = 1500000.obs;
  var totalProducts = 50.obs;
  var totalOrders = 120.obs;
  var totalCancelled = 10.obs;

  // Dummy data untuk grafik penjualan
  var salesData =
      [
        {'month': 'Jan', 'sales': 300000},
        {'month': 'Feb', 'sales': 400000},
        {'month': 'Mar', 'sales': 500000},
        {'month': 'Apr', 'sales': 600000},
      ].obs;

  @override
  void onInit() {
    super.onInit();

    // Listener untuk perubahan pada StoreManager
    listenToStoreChanges();

    // Menambahkan listener untuk mendeteksi perubahan pada worker
    ever(storeData, (_) {
      // Ketika data toko berubah, update juga jumlah produk
      if (store != null) {
        getProductCount();
      }
    });
  }

  /// Mendengarkan perubahan pada StoreManager
  void listenToStoreChanges() {
    // Menambahkan listener ke stream toko pada StoreManager
    myStore.storeStream.listen((updatedStore) {
      if (updatedStore != null &&
          (storeData.value == null ||
              storeData.value!.id != updatedStore.id ||
              storeData.value!.updatedAt != updatedStore.updatedAt)) {
        log('Store data updated in StoreManager: ${updatedStore.storeName}');
        storeData.value = updatedStore;
      }
    });
  }

  /// Memuat ulang data toko dari repository
  Future<void> refreshStoreData() async {
    isLoading(true);
    await myStore.loadStoreData();
    storeData.value = myStore.currentStore;
    isLoading(false);
  }

  /// Mendapatkan jumlah produk dari toko
  Future<void> getProductCount() async {
    if (store == null) return;

    try {
      final result =
          await supabase
              .from('products')
              .select()
              .eq('store_id', store!.id)
              .count();
      log('product_count: ${result.count}');
      productCount.value = result.count;
    } catch (e) {
      log('Error fetching product count: $e');
      productCount.value = 0;
    }
  }

  @override
  void onReady() {
    super.onReady();
    // Memastikan data terupdate ketika halaman muncul kembali
    refreshStoreData();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
