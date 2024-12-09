// ignore_for_file: unnecessary_overrides

import 'dart:developer';

import 'package:get/get.dart';
import 'package:plantix_app/app/modules/profile/profile_controller.dart';
import 'package:plantix_app/main.dart';

class MyStoreController extends GetxController {
  final isLoading = false.obs;
  final saldo = 75000.0.obs;
  final processingSales = 10;
  final completedSales = 20;
  final canceledSales = 30;
  final store = myStore.currentStore;

  final profileController = Get.find<ProfileController>();
  final productCount = 0.obs;

  @override
  void onInit() async {
    super.onInit();
    getStore();
    getProductCount();
  }

  Future<void> getProductCount() async {
    final result = await supabase
        .from('products')
        .select()
        .eq('store_id', myStore.currentStore!.id)
        .count();
    log('product_count: ${result.count}');
    productCount.value = result.count;
  }

  Future getStore() async {
    isLoading(true);
    await myStore.loadStoreData();
    isLoading(false);
  }

  @override
  void onClose() async {
    super.onClose();

    profileController.isLoading = true;
    profileController.update();
    profileController.isLoading = false;
  }
}
