import 'dart:math';

import 'package:get/get.dart';
import 'package:plantix_app/app/data/models/product_model.dart';

class MyProductsController extends GetxController {
  final listMyProducts = <Product>[].obs;
  final isLoading = false.obs;

  // Metode baru untuk memuat produk awal
  void loadInitialProducts() {
    listMyProducts.addAll([
      Product(
        id: 1,
        name: 'Kentang',
        description: 'Deskripsi Produk A',
        price: 100000.0,
        stock: 10,
        images: [
          "https://sesa.id/cdn/shop/files/ORGANIK-KENTANG-500GR-_1-removebg-preview_1ec2df6a-21c8-4f07-849f-945e37046afd.png?v=1684127848",
          "https://res.cloudinary.com/dotz74j1p/image/upload/v1715660683/no-image.jpg",
          "https://res.cloudinary.com/dotz74j1p/image/upload/v1715660683/no-image.jpg",
        ],
        category: 'Buah',
        harvestDate: DateTime.now(),
        isAvailable: true,
      ),
      Product(
        id: 2,
        name: 'Bawang Merah',
        description: 'Deskripsi Produk B',
        price: 150000.0,
        stock: 20,
        images: [
          "https://www.static-src.com/wcsstore/Indraprastha/images/catalog/full//94/MTA-74221492/local_bawang_merah_lokal_probolinggo_nganjuk_kediri_100_gr_bawang_super_100_gram_full01_nknflzr1.jpg",
          "https://res.cloudinary.com/dotz74j1p/image/upload/v1715660683/no-image.jpg",
          "https://res.cloudinary.com/dotz74j1p/image/upload/v1715660683/no-image.jpg",
        ],
        category: 'Sayuran',
        harvestDate: DateTime.now(),
        isAvailable: true,
      ),
      // Tambahkan lebih banyak produk jika diperlukan
    ]);
  }

  @override
  void onInit() {
    super.onInit();
    loadInitialProducts(); // Panggil metode baru di sini
  }

  // Fungsi untuk membuat produk baru
  void createProduct({
    required String name,
    required String description,
    required int stock,
    required String category,
    required double price,
    required List<String> images,
  }) {
    final newProduct = Product(
      id: Random().nextInt(1000000),
      name: name,
      description: description,
      price: price,
      stock: stock,
      images: images,
      category: category,
      harvestDate: DateTime.now(),
      isAvailable: true,
      storeName: 'Toko Baru', // Atur sesuai kebutuhan
      storeAddress: 'Alamat Toko Baru', // Atur sesuai kebutuhan
    );
    listMyProducts.add(newProduct);
  }


}
