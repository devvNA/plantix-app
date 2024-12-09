import 'dart:developer';
import 'dart:io';

import 'package:get/get.dart';
import 'package:plantix_app/app/data/models/product_model.dart';
import 'package:plantix_app/app/modules/cart/cart_controller.dart';

// Controller untuk mengelola state penjualan
class SalesController extends GetxController {
  final _products = <Product>[].obs;
  final _isLoading = false.obs;

  List<Product> get products => _products;
  bool get isLoading => _isLoading.value;

  // Future<void> fetchProducts() async {
  //   try {
  //     _isLoading.value = true;
  //     final userId = FirebaseAuth.instance.currentUser?.uid;
  //     if (userId == null) return;

  //     final snapshot = await _firestore
  //         .collection('products')
  //         .where('farmerId', isEqualTo: userId)
  //         .get();

  //     _products.value =
  //         snapshot.docs.map((doc) => Product.fromJson(doc.data())).toList();
  //   } catch (e) {
  //     Get.snackbar(
  //       'Error',
  //       'Gagal mengambil data produk: $e',
  //       snackPosition: SnackPosition.BOTTOM,
  //     );
  //   } finally {
  //     _isLoading.value = false;
  //   }
  // }

  @override
  void onInit() {
    super.onInit();
    _initDummyProducts();
    Get.lazyPut<CartController>(() => CartController());
  }

  Future<void> addProduct(Product product, List<File> imageFiles) async {
    try {
      _isLoading.value = true;
      final imageUrls = await uploadImages(imageFiles);

      final newProduct = Product(
        storeName: 'Toko Makmur',
        storeAddress: 'Jl. Raya',
        id: DateTime.now().hashCode,
        name: product.name,
        description: product.description,
        price: product.price,
        stock: product.stock,
        images: imageUrls,
        // farmerId: FirebaseAuth.instance.currentUser!.uid,
        category: product.category,
        harvestDate: product.harvestDate,
        isAvailable: true,
      );

      // await _firestore
      //     .collection('products')
      //     .doc(newProduct.id)
      //     .set(newProduct.toJson());

      _products.add(newProduct);
      Get.back();
      Get.snackbar(
        'Sukses',
        'Produk berhasil ditambahkan',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal menambahkan produk: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> refreshProducts() async {
    _isLoading.value = true;
    _products.clear();
    await Future.delayed(Duration(milliseconds: 300)).then((value) {
      _initDummyProducts();
    });
    _isLoading.value = false;
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

  Future<void> updateProduct(Product product) async {
    try {
      _isLoading.value = true;
      // await _firestore
      //     .collection('products')
      //     .doc(product.id)
      //     .update(product.toJson());

      final index = _products.indexWhere((p) => p.id == product.id);
      if (index != -1) {
        _products[index] = product;
      }
      Get.back();
      Get.snackbar(
        'Sukses',
        'Produk berhasil diperbarui',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memperbarui produk: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  Future<List<String>> uploadImages(List<File> images) async {
    List<String> imageUrls = [];
    // for (var image in images) {
    //   final ref = _storage
    //       .ref()
    //       .child('products/${DateTime.now().millisecondsSinceEpoch}');
    //   await ref.putFile(image);
    //   final url = await ref.getDownloadURL();
    //   imageUrls.add(url);
    // }
    return imageUrls;
  }

  void _initDummyProducts() {
    try {
      _isLoading.value = true;
      _products.value = [
        Product(
          storeName: 'Toko Makmur',
          id: 1,
          name: 'Tomat Segar',
          description: 'Tomat merah segar dari kebun organik'
              ' Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.'
              'Tomat merah segar dari kebun organik'
              ' Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.'
              'Tomat merah segar dari kebun organik'
              ' Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.'
              'Tomat merah segar dari kebun organik'
              ' Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.'
              'Tomat merah segar dari kebun organik'
              ' Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.'
              'Tomat merah segar dari kebun organik'
              ' Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.'
              'Tomat merah segar dari kebun organik'
              ' Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.'
              'Tomat merah segar dari kebun organik'
              ' Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
          price: 15000,
          stock: 50,
          images: [
            "https://upload.wikimedia.org/wikipedia/commons/thumb/8/89/Tomato_je.jpg/1200px-Tomato_je.jpg",
            "https://res.cloudinary.com/dotz74j1p/image/upload/v1715660683/no-image.jpg",
            "https://res.cloudinary.com/dotz74j1p/image/upload/v1715660683/no-image.jpg",
          ],
          category: 'Sayuran',
          harvestDate: DateTime.now().subtract(Duration(days: 2)),
          isAvailable: true,
          storeAddress: 'Jl. Raya',
        ),
        Product(
          storeName: 'Toko Makmur',
          id: 2,
          name: 'Wortel Organik',
          description: 'Wortel segar tanpa pestisida',
          price: 10000,
          stock: 40,
          images: [
            "https://cdn.rri.co.id/berita/Manado/o/1712207466422-ryc1krod/4r9frfbfn1nf0q1.png",
            "https://res.cloudinary.com/dotz74j1p/image/upload/v1715660683/no-image.jpg",
            "https://res.cloudinary.com/dotz74j1p/image/upload/v1715660683/no-image.jpg",
          ],
          category: 'Sayuran',
          harvestDate: DateTime.now().subtract(Duration(days: 3)),
          isAvailable: true,
          storeAddress: 'Jl. Raya',
        ),
        Product(
          storeName: 'Toko Makmur',
          id: 3,
          name: 'Cabai Merah',
          description: 'Cabai merah segar dan berkualitas',
          price: 25000,
          stock: 30,
          images: [
            "https://res.cloudinary.com/dk0z4ums3/image/upload/v1626688028/attached_image/biji-cabai-dapat-menyebabkan-usus-buntu-ini-faktanya.jpg",
            "https://res.cloudinary.com/dotz74j1p/image/upload/v1715660683/no-image.jpg",
            "https://res.cloudinary.com/dotz74j1p/image/upload/v1715660683/no-image.jpg",
          ],
          category: 'Sayuran',
          harvestDate: DateTime.now().subtract(Duration(days: 1)),
          isAvailable: true,
          storeAddress: 'Jl. Raya',
        ),
        Product(
          storeName: 'Toko Subur',
          id: 4,
          name: 'Kentang',
          description: 'Kentang segar dari dataran tinggi',
          price: 12000,
          stock: 60,
          images: [
            "https://sesa.id/cdn/shop/files/ORGANIK-KENTANG-500GR-_1-removebg-preview_1ec2df6a-21c8-4f07-849f-945e37046afd.png?v=1684127848",
            "https://res.cloudinary.com/dotz74j1p/image/upload/v1715660683/no-image.jpg",
            "https://res.cloudinary.com/dotz74j1p/image/upload/v1715660683/no-image.jpg",
          ],
          category: 'Sayuran',
          harvestDate: DateTime.now().subtract(Duration(days: 2)),
          isAvailable: true,
          storeAddress: 'Jl. Raya',
        ),
        Product(
          storeName: 'Toko Tani',
          id: 5,
          name: 'Bawang Merah',
          description: 'Bawang merah kualitas super',
          price: 30000,
          stock: 25,
          images: [
            "https://www.static-src.com/wcsstore/Indraprastha/images/catalog/full//94/MTA-74221492/local_bawang_merah_lokal_probolinggo_nganjuk_kediri_100_gr_bawang_super_100_gram_full01_nknflzr1.jpg",
            "https://res.cloudinary.com/dotz74j1p/image/upload/v1715660683/no-image.jpg",
            "https://res.cloudinary.com/dotz74j1p/image/upload/v1715660683/no-image.jpg",
          ],
          category: 'Bumbu',
          harvestDate: DateTime.now().subtract(Duration(days: 4)),
          isAvailable: true,
          storeAddress: 'Jl. Raya',
        ),
        Product(
          storeName: 'Toko Hasil Tani',
          id: 6,
          name: 'Jagung Manis',
          description: 'Jagung manis segar langsung dari petani',
          price: 8000,
          stock: 100,
          images: [
            "https://sesa.id/cdn/shop/files/Jagung-manis-kupas-1-kg-2S-removebg-preview.png?v=1684122381",
            "https://res.cloudinary.com/dotz74j1p/image/upload/v1715660683/no-image.jpg",
            "https://res.cloudinary.com/dotz74j1p/image/upload/v1715660683/no-image.jpg",
          ],
          category: 'Sayuran',
          harvestDate: DateTime.now().subtract(Duration(days: 1)),
          isAvailable: true,
          storeAddress: 'Jl. Raya',
        ),
        Product(
          storeName: 'Toko Segar',
          id: 7,
          name: 'Brokoli',
          description: 'Brokoli organik segar',
          price: 18000,
          stock: 35,
          images: [
            "https://shopee.co.id/inspirasi-shopee/wp-content/uploads/2021/09/ezgif.com-gif-maker-2021-09-21T150620.635.webp",
            "https://res.cloudinary.com/dotz74j1p/image/upload/v1715660683/no-image.jpg",
            "https://res.cloudinary.com/dotz74j1p/image/upload/v1715660683/no-image.jpg",
          ],
          category: 'Sayuran',
          harvestDate: DateTime.now().subtract(Duration(days: 2)),
          isAvailable: true,
          storeAddress: 'Jl. Raya',
        ),
        Product(
          storeName: 'Toko Tani Makmur',
          id: 8,
          name: 'Kol',
          description: 'Kol segar berkualitas',
          price: 7000,
          stock: 45,
          images: [
            "https://images.tokopedia.net/img/cache/500-square/VqbcmM/2021/7/30/05a0a966-5ae2-422d-8bf8-4b73a7efc329.jpg",
            "https://res.cloudinary.com/dotz74j1p/image/upload/v1715660683/no-image.jpg",
            "https://res.cloudinary.com/dotz74j1p/image/upload/v1715660683/no-image.jpg",
          ],
          category: 'Sayuran',
          harvestDate: DateTime.now().subtract(Duration(days: 1)),
          isAvailable: true,
          storeAddress: 'Jl. Raya',
        ),
      ];
    } catch (e) {
      log(e.toString());
    } finally {
      _isLoading.value = false;
    }
  }
}
