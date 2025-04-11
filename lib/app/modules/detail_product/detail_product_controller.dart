import 'dart:developer';

import 'package:get/get.dart';
import 'package:plantix_app/app/core/widgets/custom_snackbar.dart';
// import 'package:plantix_app/app/core/widgets/custom_snackbar.dart';
// import 'package:plantix_app/app/data/models/product_model.dart';
import 'package:plantix_app/app/data/models/shop_response_model.dart';
import 'package:plantix_app/app/data/repositories/cart_repository.dart'
    show CartRepository;
// import 'package:plantix_app/app/modules/cart/cart_controller.dart';

class DetailProductController extends GetxController {
  ShopResponse product = Get.arguments;
  final isFavorite = false.obs;
  final quantity = 1.obs;
  final cartRepo = CartRepository();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  Future<void> addToCart() async {
    final result = await cartRepo.addToCart(
      productId: product.id,
      quantity: quantity.value,
    );
    result.fold((failure) => log(failure.message), (success) {
      log(success.toString());
      Get.back();
      snackbarSuccess(
        message: "Sukses",
        body: "Produk berhasil ditambahkan ke keranjang",
        duration: 800,
      );
    });
  }

  void toggleFavorite() {
    isFavorite.toggle();
  }

  // void addProductToCart() {
  //   // Get.lazyPut(() => CartController());
  //   // Get.find<CartController>().addToCart(product, quantity.value);
  //   // Get.back();
  //   // snackbarSuccess(
  //   //   message: "Sukses",
  //   //   body: "Produk berhasil ditambahkan ke keranjang",
  //   //   duration: 800,
  //   // );
  // }
}
