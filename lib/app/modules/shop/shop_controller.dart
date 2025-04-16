// ignore_for_file: unnecessary_overrides

import 'dart:async';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:plantix_app/app/data/models/shop_response_model.dart';
import 'package:plantix_app/app/data/repositories/shop_repository.dart';
import 'package:plantix_app/main.dart';

class ShopController extends GetxController {
  final isLoading = true.obs;
  final listProductsSearch = <ShopResponse>[].obs;
  final shopRepo = ShopRepository();

  // Stream produk untuk diakses oleh UI
  Stream<List<ShopResponse>>? _productsStream;
  Stream<List<ShopResponse>>? _allProductsStream;

  /// Getter untuk mengakses stream produk
  Stream<List<ShopResponse>> get productsStream =>
      _productsStream ?? shopRepo.streamProducts(myStore.currentStore!.id);

  Stream<List<ShopResponse>> get allProductsStream =>
      _allProductsStream ?? shopRepo.streamAllProducts();

  // get products => _products;

  @override
  void onInit() async {
    super.onInit();
    await getProductsSearch(
      storeId: user.hasStore ? myStore.currentStore!.id : null,
    );
    isLoading.value = false;
  }

  @override
  void onReady() {
    super.onReady();
  }

  /// Mengambil data produk untuk pencarian berdasarkan status kepemilikan toko
  Future<void> getProductsSearch({int? storeId}) async {
    final result =
        user.hasStore
            ? await shopRepo.getProductExceptStore(storeId!)
            : await shopRepo.getAllProduct();

    result.fold((failure) => log(failure.message), (products) {
      listProductsSearch
        ..clear()
        ..addAll(products);
    });
  }

  Future<void> refreshProducts() async {
    isLoading.value = true;
    await Future.delayed(Duration(milliseconds: 350)).then((value) {
      getProductsSearch();
    });
    isLoading.value = false;
  }

  Future<void> deleteProduct(String productId) async {
    // try {
    //   _isLoading.value = true;
    //   // await _firestore.collection('products').doc(productId).delete();
    //   _products.removeWhere((product) => product.id == productId);
    //   Get.snackbar(
    //     'Sukses',
    //     'Produk berhasil dihapus',
    //     snackPosition: SnackPosition.BOTTOM,
    //   );
    // } catch (e) {
    //   Get.snackbar(
    //     'Error',
    //     'Gagal menghapus produk: $e',
    //     snackPosition: SnackPosition.BOTTOM,
    //   );
    // } finally {
    //   _isLoading.value = false;
    // }
  }

  // Future<void> updateProduct(Product product) async {
  //   try {
  //     isLoading.value = true;
  //     // await _firestore
  //     //     .collection('products')
  //     //     .doc(product.id)
  //     //     .update(product.toJson());

  //     final index = _products.indexWhere((p) => p.id == product.id);
  //     if (index != -1) {
  //       _products[index] = product;
  //     }
  //     Get.back();
  //     Get.snackbar(
  //       'Sukses',
  //       'Produk berhasil diperbarui',
  //       snackPosition: SnackPosition.BOTTOM,
  //     );
  //   } catch (e) {
  //     Get.snackbar(
  //       'Error',
  //       'Gagal memperbarui produk: $e',
  //       snackPosition: SnackPosition.BOTTOM,
  //     );
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }
}
