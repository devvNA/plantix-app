import 'dart:developer';

import 'package:get/get.dart';
import 'package:plantix_app/app/core/extensions/currency_ext.dart';
import 'package:plantix_app/app/core/services/db_services.dart';
import 'package:plantix_app/app/core/widgets/custom_snackbar.dart';
import 'package:plantix_app/app/data/models/keranjang_model.dart';
import 'package:plantix_app/app/data/models/product_model.dart';

class CartController extends GetxController {
  final storage = LocalStorageService();
  final cartProductList = <CartItem>[].obs;
  final totalPrice = 0.0.obs;

  // Menambahkan variabel untuk menyimpan item yang dipilih
  final selectedStores = <String>{}.obs;
  final selectedProducts = <int>{}.obs;

  // Fungsi untuk mendapatkan jumlah item yang dipilih
  int get selectedProductCount => selectedProducts.length;

  @override
  void onInit() {
    super.onInit();
    // Get.closeAllSnackbars();
    // ScaffoldMessenger.of(Get.context!).hideCurrentSnackBar();
    // Getback
    loadCartFromStorage();
  }

  Future<void> addToCart(Product product, int quantity) async {
    try {
      final existingItemIndex =
          cartProductList.indexWhere((item) => item.product!.id == product.id);
      // log(existingItemIndex.toString());

      if (existingItemIndex != -1) {
        cartProductList[existingItemIndex].quantity =
            (cartProductList[existingItemIndex].quantity ?? 0) + 1;
      } else {
        cartProductList.add(CartItem(product: product, quantity: quantity));
      }

      await storage.saveList('cart', cartProductList);
      totalPrice.value = calculateTotalPrice();
    } catch (e) {
      log(e.toString());
    }
  }

  void loadCartFromStorage() {
    cartProductList.value = storage.getList<CartItem>('cart') ?? [];
  }

  // Fungsi untuk increment quantity
  Future<void> incrementQuantity(int itemId) async {
    try {
      final index =
          cartProductList.indexWhere((item) => item.product!.id == itemId);

      if (index != -1) {
        cartProductList[index].quantity =
            (cartProductList[index].quantity ?? 0) + 1;
        cartProductList.refresh();
        await storage.saveList('cart', cartProductList);
        totalPrice.value = calculateTotalPrice();
      }

      // Perbarui total harga jika item yang diubah adalah item yang dipilih
      if (selectedProducts.contains(itemId)) {
        totalPrice.value = calculateSelectedItemsTotal();
      }
    } catch (e) {
      log(e.toString());
      snackbarError(
        message: "Kesalahan",
        body: "Gagal menambah quantity produk",
      );
    }
  }

  // Fungsi untuk decrement quantity
  Future<void> decrementQuantity(int itemId) async {
    try {
      final index =
          cartProductList.indexWhere((item) => item.product!.id == itemId);

      if (index != -1 && (cartProductList[index].quantity ?? 0) > 1) {
        cartProductList[index].quantity =
            (cartProductList[index].quantity ?? 0) - 1;
        cartProductList.refresh();
        await storage.saveList('cart', cartProductList);
        totalPrice.value = calculateTotalPrice();
      }

      // Perbarui total harga jika item yang diubah adalah item yang dipilih
      if (selectedProducts.contains(itemId)) {
        totalPrice.value = calculateSelectedItemsTotal();
      }
    } catch (e) {
      log(e.toString());
      snackbarError(
        message: "Kesalahan",
        body: "Gagal menambah quantity produk",
      );
    }
  }

  double calculateTotalPrice() {
    return cartProductList.fold(0.0, (sum, item) {
      double itemPrice = (item.product!.price ?? 0) * (item.quantity ?? 1);
      return sum + itemPrice;
    });
  }

  // Fungsi untuk menghapus produk dari keranjang
  Future<void> deleteProduct(CartItem data) async {
    final index = cartProductList
        .indexWhere((item) => item.product!.id == data.product!.id);
    cartProductList.removeAt(index);
    cartProductList.refresh();
    // await storage.removeFromList<CartItem>('cart', index);

    snackbarSuccess(
      message: "Sukses",
      body: "Produk berhasil dihapus",
      duration: 800,
      bottom: cartProductList.isEmpty ? 90 : 220,
    );
  }

  // Fungsi untuk menghapus item yang dipilih
  Future<void> deleteSelectedItems() async {
    cartProductList
        .removeWhere((item) => selectedProducts.contains(item.product!.id));
    cartProductList.refresh();
    await storage.saveList('cart', cartProductList);
    totalPrice.value = calculateTotalPrice();
  }

  // Fungsi untuk mengecek data keranjang
  Future<void> checkData() async {
    log(storage.getList<CartItem>('cart')!.length.toString());
    var cartList = storage
        .getList<CartItem>('cart')!
        .map((product) => {
              'Nama': product.product!.name,
              'Harga': product.product!.price,
              'Quantity': product.quantity
            })
        .toList();
    log(cartList.toString());
    log("Total Bayar: ${calculateTotalPrice().currencyFormatRp}");
  }

  Map<String, List<CartItem>> getGroupedCartItems() {
    Map<String, List<CartItem>> groupedItems = {};

    for (var item in cartProductList) {
      final storeName = item.product!.storeName;
      if (!groupedItems.containsKey(storeName)) {
        groupedItems[storeName ?? ''] = [];
      }
      groupedItems[storeName ?? '']!.add(item);
    }

    return groupedItems;
  }

  // Method untuk menghitung total per toko
  double calculateStoreTotal(List<CartItem> items) {
    return items.fold(0.0, (sum, item) {
      return sum + ((item.product!.price ?? 0) * (item.quantity ?? 1));
    });
  }

  // Fungsi untuk mengecek apakah toko dipilih
  bool isStoreSelected(String storeName) {
    return selectedStores.contains(storeName);
  }

  // Fungsi untuk mengecek apakah item dipilih
  bool isItemSelected(int itemId) {
    return selectedProducts.contains(itemId);
  }

  // Fungsi untuk toggle pilihan toko
  void toggleStoreSelection(String storeName) {
    log(storeName);
    if (selectedStores.contains(storeName)) {
      // Hapus pilihan toko dan semua item dari toko tersebut
      selectedStores.remove(storeName);

      // Hapus semua item yang terkait dengan toko ini
      final storeItems = cartProductList
          .where((item) => item.product!.storeName == storeName)
          .map((item) => item.product!.id);

      selectedProducts.removeAll(storeItems);
    } else {
      // Pilih toko dan semua item dari toko tersebut
      selectedStores.add(storeName);

      // Pilih semua item yang terkait dengan toko ini
      final storeItems = cartProductList
          .where((item) => item.product!.storeName == storeName)
          .map((item) => item.product!.id);

      selectedProducts.addAll(storeItems.map((e) => e));
    }

    // Perbarui total harga setelah toko dipilih/tidak dipilih
    totalPrice.value = calculateSelectedItemsTotal();
  }

  // Fungsi untuk toggle pilihan item
  void toggleItemSelection(int itemId) {
    final item = cartProductList.firstWhere(
      (item) => item.product!.id == itemId,
    );
    final storeName = item.product!.storeName;

    if (selectedProducts.contains(itemId)) {
      selectedProducts.remove(itemId);

      // Jika tidak ada item yang dipilih dari toko tersebut, hapus pilihan toko
      final hasSelectedStoreItems = cartProductList
          .where((item) => item.product!.storeName == storeName)
          .any((item) => selectedProducts.contains(item.product!.id));

      if (!hasSelectedStoreItems) {
        selectedStores.remove(storeName);
      }
    } else {
      selectedProducts.add(itemId);

      // Jika semua item dari toko dipilih, pilih toko juga
      final allStoreItemsSelected = cartProductList
          .where((item) => item.product!.storeName == storeName)
          .every((item) => selectedProducts.contains(item.product!.id));

      if (allStoreItemsSelected) {
        selectedStores.add(storeName ?? '');
      }
    }

    // Perbarui total harga setelah item dipilih/tidak dipilih
    totalPrice.value = calculateSelectedItemsTotal();
  }

  // Fungsi untuk menghitung total harga item yang dipilih
  double calculateSelectedItemsTotal() {
    return cartProductList
        .where((item) => selectedProducts.contains(item.product!.id))
        .fold(0.0, (sum, item) {
      return sum + ((item.product!.price ?? 0) * (item.quantity ?? 1));
    });
  }

  // Fungsi untuk checkout item yang dipilih
  List<CartItem> checkoutSelectedItems() {
    // if (selectedProducts.isEmpty) {
    //   CustomSnackBar.showCustomErrorSnackBar(
    //     title: 'Error',
    //     message: 'Pilih minimal satu produk untuk checkout',
    //   );
    //   return [];
    // }

    // Implementasi checkout akan ditambahkan di sini
    // Misalnya navigasi ke halaman checkout dengan membawa data item yang dipilih
    final selectedItems = cartProductList
        .where((item) => selectedProducts.contains(item.product!.id))
        .toList();

    // Get.toNamed('/checkout', arguments: selectedProducts);
    log(selectedProducts.toString());
    log(selectedItems.toString());
    // deleteSelectedItems();
    // cartProductList.clear();
    clearSelection();
    return selectedItems;
  }

  // Fungsi untuk membersihkan semua pilihan
  void clearSelection() {
    selectedStores.clear();
    selectedProducts.clear();
  }
}
