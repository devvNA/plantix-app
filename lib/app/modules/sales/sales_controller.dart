import 'dart:io';

import 'package:get/get.dart';
import 'package:plantix_app/app/data/models/product_model.dart';
import 'package:plantix_app/app/modules/cart/cart_controller.dart';

// Controller untuk mengelola state penjualan
class SalesController extends GetxController {
  final _products = <Product>[].obs;
  final _isLoading = false.obs;

  bool get isLoading => _isLoading.value;
  List<Product> get products => _products;

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
    _products.value = [
      Product(
        storeName: 'Toko Makmur',
        id: 1,
        name: 'Tomat Segar',
        description: 'Tomat merah segar dari kebun organik',
        price: 15000,
        stock: 50,
        images: [
          "https://images.tokopedia.net/img/cache/500-square/product-1/2018/7/4/27298008/27298008_dd20875d-361b-4613-aeed-36c1235a425f_1024_1366.jpg.webp?ect=4g",
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
          "https://images.tokopedia.net/img/cache/500-square/product-1/2018/7/4/27298008/27298008_dd20875d-361b-4613-aeed-36c1235a425f_1024_1366.jpg.webp?ect=4g",
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
          "https://images.tokopedia.net/img/cache/500-square/product-1/2018/7/4/27298008/27298008_dd20875d-361b-4613-aeed-36c1235a425f_1024_1366.jpg.webp?ect=4g",
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
          "https://images.tokopedia.net/img/cache/500-square/product-1/2018/7/4/27298008/27298008_dd20875d-361b-4613-aeed-36c1235a425f_1024_1366.jpg.webp?ect=4g",
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
          "https://images.tokopedia.net/img/cache/500-square/product-1/2018/7/4/27298008/27298008_dd20875d-361b-4613-aeed-36c1235a425f_1024_1366.jpg.webp?ect=4g",
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
          "https://images.tokopedia.net/img/cache/500-square/product-1/2018/7/4/27298008/27298008_dd20875d-361b-4613-aeed-36c1235a425f_1024_1366.jpg.webp?ect=4g",
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
          "https://images.tokopedia.net/img/cache/500-square/product-1/2018/7/4/27298008/27298008_dd20875d-361b-4613-aeed-36c1235a425f_1024_1366.jpg.webp?ect=4g",
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
          "https://images.tokopedia.net/img/cache/500-square/product-1/2018/7/4/27298008/27298008_dd20875d-361b-4613-aeed-36c1235a425f_1024_1366.jpg.webp?ect=4g",
          "https://res.cloudinary.com/dotz74j1p/image/upload/v1715660683/no-image.jpg",
          "https://res.cloudinary.com/dotz74j1p/image/upload/v1715660683/no-image.jpg",
        ],
        category: 'Sayuran',
        harvestDate: DateTime.now().subtract(Duration(days: 1)),
        isAvailable: true,
        storeAddress: 'Jl. Raya',
      ),
    ];
  }
}
