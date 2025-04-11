// ignore_for_file: unnecessary_overrides

import 'dart:async';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:plantix_app/app/data/models/shop_response_model.dart';
import 'package:plantix_app/app/data/repositories/shop_repository.dart';
import 'package:plantix_app/main.dart';

class ShopController extends GetxController {
  final isLoading = false.obs;
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

  void _initDummyProducts() {
    try {
      isLoading.value = true;
      // _products.value = [
      //   Product(
      //     storeName: 'Toko Makmur',
      //     id: 1,
      //     name: 'Tomat Segar',
      //     description:
      //         'Tomat merah segar dari kebun organik'
      //         ' Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.'
      //         'Tomat merah segar dari kebun organik'
      //         ' Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.'
      //         'Tomat merah segar dari kebun organik'
      //         ' Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.'
      //         'Tomat merah segar dari kebun organik'
      //         ' Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.'
      //         'Tomat merah segar dari kebun organik'
      //         ' Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.'
      //         'Tomat merah segar dari kebun organik'
      //         ' Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.'
      //         'Tomat merah segar dari kebun organik'
      //         ' Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.'
      //         'Tomat merah segar dari kebun organik'
      //         ' Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
      //     price: 15000,
      //     stock: 50,
      //     images: [
      //       "https://upload.wikimedia.org/wikipedia/commons/thumb/8/89/Tomato_je.jpg/1200px-Tomato_je.jpg",
      //       "https://res.cloudinary.com/dotz74j1p/image/upload/v1715660683/no-image.jpg",
      //       "https://res.cloudinary.com/dotz74j1p/image/upload/v1715660683/no-image.jpg",
      //     ],
      //     category: 'Sayuran',
      //     harvestDate: DateTime.now().subtract(Duration(days: 2)),
      //     isAvailable: true,
      //     storeAddress: 'Jl. Raya',
      //   ),
      //   Product(
      //     storeName: 'Toko Makmur',
      //     id: 2,
      //     name: 'Wortel Organik',
      //     description: 'Wortel segar tanpa pestisida',
      //     price: 10000,
      //     stock: 40,
      //     images: [
      //       "https://cdn.rri.co.id/berita/Manado/o/1712207466422-ryc1krod/4r9frfbfn1nf0q1.png",
      //       "https://res.cloudinary.com/dotz74j1p/image/upload/v1715660683/no-image.jpg",
      //       "https://res.cloudinary.com/dotz74j1p/image/upload/v1715660683/no-image.jpg",
      //     ],
      //     category: 'Sayuran',
      //     harvestDate: DateTime.now().subtract(Duration(days: 3)),
      //     isAvailable: true,
      //     storeAddress: 'Jl. Raya',
      //   ),
      //   Product(
      //     storeName: 'Toko Makmur',
      //     id: 3,
      //     name: 'Cabai Merah',
      //     description: 'Cabai merah segar dan berkualitas',
      //     price: 25000,
      //     stock: 30,
      //     images: [
      //       "https://res.cloudinary.com/dk0z4ums3/image/upload/v1626688028/attached_image/biji-cabai-dapat-menyebabkan-usus-buntu-ini-faktanya.jpg",
      //       "https://res.cloudinary.com/dotz74j1p/image/upload/v1715660683/no-image.jpg",
      //       "https://res.cloudinary.com/dotz74j1p/image/upload/v1715660683/no-image.jpg",
      //     ],
      //     category: 'Sayuran',
      //     harvestDate: DateTime.now().subtract(Duration(days: 1)),
      //     isAvailable: true,
      //     storeAddress: 'Jl. Raya',
      //   ),
      //   Product(
      //     storeName: 'Toko Subur',
      //     id: 4,
      //     name: 'Kentang',
      //     description: 'Kentang segar dari dataran tinggi',
      //     price: 12000,
      //     stock: 60,
      //     images: [
      //       "https://sesa.id/cdn/shop/files/ORGANIK-KENTANG-500GR-_1-removebg-preview_1ec2df6a-21c8-4f07-849f-945e37046afd.png?v=1684127848",
      //       "https://res.cloudinary.com/dotz74j1p/image/upload/v1715660683/no-image.jpg",
      //       "https://res.cloudinary.com/dotz74j1p/image/upload/v1715660683/no-image.jpg",
      //     ],
      //     category: 'Sayuran',
      //     harvestDate: DateTime.now().subtract(Duration(days: 2)),
      //     isAvailable: true,
      //     storeAddress: 'Jl. Raya',
      //   ),
      //   Product(
      //     storeName: 'Toko Tani',
      //     id: 5,
      //     name: 'Bawang Merah',
      //     description: 'Bawang merah kualitas super',
      //     price: 30000,
      //     stock: 25,
      //     images: [
      //       "https://www.static-src.com/wcsstore/Indraprastha/images/catalog/full//94/MTA-74221492/local_bawang_merah_lokal_probolinggo_nganjuk_kediri_100_gr_bawang_super_100_gram_full01_nknflzr1.jpg",
      //       "https://res.cloudinary.com/dotz74j1p/image/upload/v1715660683/no-image.jpg",
      //       "https://res.cloudinary.com/dotz74j1p/image/upload/v1715660683/no-image.jpg",
      //     ],
      //     category: 'Bumbu',
      //     harvestDate: DateTime.now().subtract(Duration(days: 4)),
      //     isAvailable: true,
      //     storeAddress: 'Jl. Raya',
      //   ),
      //   Product(
      //     storeName: 'Toko Hasil Tani',
      //     id: 6,
      //     name: 'Jagung Manis',
      //     description: 'Jagung manis segar langsung dari petani',
      //     price: 8000,
      //     stock: 100,
      //     images: [
      //       "https://sesa.id/cdn/shop/files/Jagung-manis-kupas-1-kg-2S-removebg-preview.png?v=1684122381",
      //       "https://res.cloudinary.com/dotz74j1p/image/upload/v1715660683/no-image.jpg",
      //       "https://res.cloudinary.com/dotz74j1p/image/upload/v1715660683/no-image.jpg",
      //     ],
      //     category: 'Sayuran',
      //     harvestDate: DateTime.now().subtract(Duration(days: 1)),
      //     isAvailable: true,
      //     storeAddress: 'Jl. Raya',
      //   ),
      //   Product(
      //     storeName: 'Toko Segar',
      //     id: 7,
      //     name: 'Brokoli',
      //     description: 'Brokoli organik segar',
      //     price: 18000,
      //     stock: 35,
      //     images: [
      //       "https://shopee.co.id/inspirasi-shopee/wp-content/uploads/2021/09/ezgif.com-gif-maker-2021-09-21T150620.635.webp",
      //       "https://res.cloudinary.com/dotz74j1p/image/upload/v1715660683/no-image.jpg",
      //       "https://res.cloudinary.com/dotz74j1p/image/upload/v1715660683/no-image.jpg",
      //     ],
      //     category: 'Sayuran',
      //     harvestDate: DateTime.now().subtract(Duration(days: 2)),
      //     isAvailable: true,
      //     storeAddress: 'Jl. Raya',
      //   ),
      //   Product(
      //     storeName: 'Toko Tani Makmur',
      //     id: 8,
      //     name: 'Kol',
      //     description: 'Kol segar berkualitas',
      //     price: 7000,
      //     stock: 45,
      //     images: [
      //       "https://images.tokopedia.net/img/cache/500-square/VqbcmM/2021/7/30/05a0a966-5ae2-422d-8bf8-4b73a7efc329.jpg",
      //       "https://res.cloudinary.com/dotz74j1p/image/upload/v1715660683/no-image.jpg",
      //       "https://res.cloudinary.com/dotz74j1p/image/upload/v1715660683/no-image.jpg",
      //     ],
      //     category: 'Sayuran',
      //     harvestDate: DateTime.now().subtract(Duration(days: 1)),
      //     isAvailable: true,
      //     storeAddress: 'Jl. Raya',
      //   ),
      // ];
    } catch (e) {
      log(e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
