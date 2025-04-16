// ignore_for_file: unnecessary_overrides

import 'package:get/get.dart';
import 'package:plantix_app/app/core/extensions/snackbar_ext.dart';
import 'package:plantix_app/app/data/models/product_model.dart';
import 'package:plantix_app/app/data/repositories/my_store_repository.dart';
import 'package:plantix_app/app/modules/my_store/my_store_controller.dart';
import 'package:plantix_app/main.dart';

class MyProductsController extends GetxController {
  final listMyProducts = <ProductModel>[].obs;
  final isLoading = false.obs;
  final myStoreRepo = MyStoreRepository();
  final myStoreController = Get.find<MyStoreController>();

  @override
  void onInit() {
    super.onInit();

    getProductsByStoreId();
  }

  Future<void> getProductsByStoreId() async {
    isLoading.value = true;
    final result = await myStoreRepo.getProductsByStoreId(
      storeId: myStore.currentStore!.id,
    );
    result.fold(
      (failure) {
        Get.back();
        Get.context!.showCustomSnackBar(message: failure.message, isError: true);
      },
      (products) {
        listMyProducts.addAll(products);
      },
    );
    isLoading.value = false;
  }

  Future<void> onRefresh() async {
    listMyProducts.clear();
    await getProductsByStoreId();
  }

  @override
  void onClose() {
    listMyProducts.clear();
    myStoreController.getProductCount();

    super.onClose();
  }
}
