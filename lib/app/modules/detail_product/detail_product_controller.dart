import 'package:get/get.dart';
import 'package:plantix_app/app/core/widgets/custom_snackbar.dart';
import 'package:plantix_app/app/data/models/product_model.dart';
import 'package:plantix_app/app/modules/cart/cart_controller.dart';

class DetailProductController extends GetxController {
  Product product = Get.arguments;
  final isFavorite = false.obs;
  final quantity = 1.obs;

  @override
  void onInit() {
    super.onInit();
  }

  void toggleFavorite() {
    isFavorite.toggle();
  }

  void addProductToCart() {
    Get.lazyPut(() => CartController());
    Get.find<CartController>().addToCart(product, quantity.value);
    Get.back();
    CustomSnackBar.showCustomSuccessSnackBar(
      duration: Duration(seconds: 1),
      title: "Berhasil",
      message: "Produk berhasil ditambahkan ke keranjang",
    );
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
