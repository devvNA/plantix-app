// ignore_for_file: unnecessary_overrides

import 'package:get/get.dart';
import 'package:plantix_app/app/core/widgets/custom_snackbar.dart';
import 'package:plantix_app/app/data/models/store_model.dart';
import 'package:plantix_app/app/data/repositories/my_store_repository.dart';

class MyStoreController extends GetxController {
  final isLoading = false.obs;
  final saldo = 75000.0.obs;
  final processingSales = 10;
  final completedSales = 20;
  final canceledSales = 30;
  final productCount = 0;
  final store = Rx<MyStoreModel?>(null);

  @override
  void onInit() {
    super.onInit();
    getStore();
    // Get.put<MyProductsController>(MyProductsController());
    // Get.find<MyProductsController>().loadInitialProducts();
    // productCount.value = Get.find<MyProductsController>().listMyProducts.length;
    // fetchStoreDetails();
  }

  // Future<void> fetchStoreDetails() async {
  //   try {
  //     isLoading.value = true;
  //     // Misalnya, mengambil data toko dari local storage atau API
  //     StoreModel? store = await DBServices.getStore();

  //     if (store != null) {
  //       storeName.value = store.name;
  //       storeAddress.value = store.address;
  //       storeImage.value = store.imageUrl;
  //       saldo.value = store.balance;
  //       processingSales = store.salesStatus['proses'] ?? 0;
  //       completedSales = store.salesStatus['selesai'] ?? 0;
  //       canceledSales = store.salesStatus['dibatalkan'] ?? 0;
  //       productCount = store.products.length;
  //     }
  //   } catch (e) {
  //     Get.snackbar(
  //       'Error',
  //       'Gagal memuat data toko: $e',
  //       snackPosition: SnackPosition.BOTTOM,
  //     );
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  Future<void> getStore() async {
    isLoading.value = true;
    final result = await MyStoreRepository().getStore();
    result.fold((failure) => snackbarError(message: failure.message), (store) {
      this.store.value = store;
    });
    isLoading.value = false;
  }

  @override
  void onClose() {
    super.onClose();
  }
}
