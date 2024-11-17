import 'package:get/get.dart';
import 'package:plantix_app/app/core/services/db_services.dart';
import 'package:plantix_app/app/data/models/store_model.dart';
import 'package:plantix_app/app/modules/my_products/my_products_controller.dart';

class MyStoreController extends GetxController {
  final isLoading = true.obs;
  final storeName = 'Toko John'.obs;
  final storeAddress = 'Jl. Raya No. 123'.obs;
  final storeImage =
      "https://res.cloudinary.com/dotz74j1p/image/upload/v1715660683/no-image.jpg"
          .obs;
  final saldo = 75000.0.obs;
  final processingSales = 10.obs;
  final completedSales = 20.obs;
  final canceledSales = 30.obs;
  final productCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    Get.put<MyProductsController>(MyProductsController());
    // Get.find<MyProductsController>().loadInitialProducts();
    productCount.value = Get.find<MyProductsController>().listMyProducts.length;
    fetchStoreDetails();
  }

  Future<void> fetchStoreDetails() async {
    try {
      isLoading.value = true;
      // Misalnya, mengambil data toko dari local storage atau API
      StoreModel? store = await DBServices.getStore();

      if (store != null) {
        storeName.value = store.name;
        storeAddress.value = store.address;
        storeImage.value = store.imageUrl;
        saldo.value = store.balance;
        processingSales.value = store.salesStatus['proses'] ?? 0;
        completedSales.value = store.salesStatus['selesai'] ?? 0;
        canceledSales.value = store.salesStatus['dibatalkan'] ?? 0;
        productCount.value = store.products.length;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memuat data toko: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
