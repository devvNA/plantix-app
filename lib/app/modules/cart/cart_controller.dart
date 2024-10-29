import 'dart:developer';

import 'package:get/get.dart';
import 'package:plantix_app/app/core/extensions/int_ext.dart';
import 'package:plantix_app/app/core/helpers/db_services.dart';
import 'package:plantix_app/app/core/widgets/custom_snackbar.dart';
import 'package:plantix_app/app/data/models/keranjang_model.dart';
import 'package:plantix_app/app/data/models/product_model.dart';

class CartController extends GetxController {
  final storage = LocalStorageService();
  final cartProductList = <CartItem>[].obs;
  final totalPrice = 0.0.obs;

  // Menambahkan variabel untuk menyimpan item yang dipilih
  final selectedStores = <String>{}.obs;
  final selectedItems = <int>{}.obs;

  @override
  void onInit() {
    super.onInit();
    loadCartFromStorage();
  }

  Future<void> addToCart(Product product, int quantity) async {
    try {
      final existingItemIndex = cartProductList
          .indexWhere((item) => item.product![0].id == product.id);
      // log(existingItemIndex.toString());

      if (existingItemIndex != -1) {
        cartProductList[existingItemIndex].quantity =
            (cartProductList[existingItemIndex].quantity ?? 0) + 1;
      } else {
        cartProductList.add(CartItem(product: [product], quantity: quantity));
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

  double calculateTotalPrice() {
    return cartProductList.fold(0.0, (sum, item) {
      double itemPrice = item.product![0].price * (item.quantity ?? 1);
      return sum + itemPrice;
    });
  }

  // Fungsi untuk menghapus produk dari keranjang
  Future<void> deleteProduct(CartItem data) async {
    final index = cartProductList
        .indexWhere((item) => item.product![0].id == data.product![0].id);
    cartProductList.removeAt(index);
    cartProductList.refresh();
    // await storage.removeFromList<CartItem>('cart', index);

    CustomSnackBar.showCustomSuccessSnackBar(
        title: 'Sukses', message: 'Produk berhasil dihapus');
  }

  Future<void> checkData() async {
    log(storage.getList<CartItem>('cart')!.length.toString());
    var cartList = storage
        .getList<CartItem>('cart')!
        .map((product) => {
              'Nama': product.product![0].name,
              'Harga': product.product![0].price,
              'Quantity': product.quantity
            })
        .toList();
    log(cartList.toString());
    log(calculateTotalPrice().currencyFormatRp);
  }

  Future<void> increaseQuantity(CartItem data) async {
    try {
      final index = cartProductList
          .indexWhere((item) => item.product![0].id == data.product![0].id);

      if (index != -1) {
        cartProductList[index].quantity =
            (cartProductList[index].quantity ?? 0) + 1;
        cartProductList.refresh();
        await storage.saveList('cart', cartProductList);
        totalPrice.value = calculateTotalPrice();
      }
    } catch (e) {
      log(e.toString());
      CustomSnackBar.showCustomErrorSnackBar(
          title: 'Error', message: 'Gagal menambah quantity produk');
    }
  }

  Future<void> decreaseQuantity(CartItem data) async {
    try {
      final index = cartProductList
          .indexWhere((item) => item.product![0].id == data.product![0].id);

      if (index != -1 && (cartProductList[index].quantity ?? 0) > 1) {
        cartProductList[index].quantity =
            (cartProductList[index].quantity ?? 0) - 1;
        cartProductList.refresh();
        await storage.saveList('cart', cartProductList);
        totalPrice.value = calculateTotalPrice();
      }
    } catch (e) {
      log(e.toString());
      CustomSnackBar.showCustomErrorSnackBar(
          title: 'Error', message: 'Gagal menambah quantity produk');
    }
  }

  Map<String, List<CartItem>> getGroupedCartItems() {
    Map<String, List<CartItem>> groupedItems = {};

    for (var item in cartProductList) {
      final storeName = item.product![0].storeName;
      if (!groupedItems.containsKey(storeName)) {
        groupedItems[storeName] = [];
      }
      groupedItems[storeName]!.add(item);
    }

    return groupedItems;
  }

  // Method untuk menghitung total per toko
  double calculateStoreTotal(List<CartItem> items) {
    return items.fold(0.0, (sum, item) {
      return sum + (item.product![0].price * (item.quantity ?? 1));
    });
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  // Fungsi untuk mengecek apakah toko dipilih
  bool isStoreSelected(String storeName) {
    return selectedStores.contains(storeName);
  }

  // Fungsi untuk toggle pilihan toko
  void toggleStoreSelection(String storeName) {
    if (selectedStores.contains(storeName)) {
      // Hapus pilihan toko dan semua item dari toko tersebut
      selectedStores.remove(storeName);

      // Hapus semua item yang terkait dengan toko ini
      final storeItems = cartProductList
          .where((item) => item.product![0].storeName == storeName)
          .map((item) => item.product![0].id);

      selectedItems.removeAll(storeItems);
    } else {
      // Pilih toko dan semua item dari toko tersebut
      selectedStores.add(storeName);

      // Pilih semua item yang terkait dengan toko ini
      final storeItems = cartProductList
          .where((item) => item.product![0].storeName == storeName)
          .map((item) => item.product![0].id);

      selectedItems.addAll(storeItems.map((e) => e));
    }

    // Perbarui total harga setelah toko dipilih/tidak dipilih
    totalPrice.value = calculateSelectedItemsTotal();
  }

  // Fungsi untuk mengecek apakah item dipilih
  bool isItemSelected(int itemId) {
    return selectedItems.contains(itemId);
  }

  // Fungsi untuk toggle pilihan item
  void toggleItemSelection(int itemId) {
    final item = cartProductList.firstWhere(
      (item) => item.product![0].id == itemId,
    );
    final storeName = item.product![0].storeName;

    if (selectedItems.contains(itemId)) {
      selectedItems.remove(itemId);

      // Jika tidak ada item yang dipilih dari toko tersebut, hapus pilihan toko
      final hasSelectedStoreItems = cartProductList
          .where((item) => item.product![0].storeName == storeName)
          .any((item) => selectedItems.contains(item.product![0].id));

      if (!hasSelectedStoreItems) {
        selectedStores.remove(storeName);
      }
    } else {
      selectedItems.add(itemId);

      // Jika semua item dari toko dipilih, pilih toko juga
      final allStoreItemsSelected = cartProductList
          .where((item) => item.product![0].storeName == storeName)
          .every((item) => selectedItems.contains(item.product![0].id));

      if (allStoreItemsSelected) {
        selectedStores.add(storeName);
      }
    }

    // Perbarui total harga setelah item dipilih/tidak dipilih
    totalPrice.value = calculateSelectedItemsTotal();
  }

  // Fungsi untuk menghitung total harga item yang dipilih
  double calculateSelectedItemsTotal() {
    return cartProductList
        .where((item) => selectedItems.contains(item.product![0].id))
        .fold(0.0, (sum, item) {
      return sum + (item.product![0].price * (item.quantity ?? 1));
    });
  }

  // Fungsi untuk increment quantity
  Future<void> incrementQuantity(int itemId) async {
    try {
      final index =
          cartProductList.indexWhere((item) => item.product![0].id == itemId);

      if (index != -1) {
        cartProductList[index].quantity =
            (cartProductList[index].quantity ?? 0) + 1;
        cartProductList.refresh();
        await storage.saveList('cart', cartProductList);
        totalPrice.value = calculateTotalPrice();
      }

      // Perbarui total harga jika item yang diubah adalah item yang dipilih
      if (selectedItems.contains(itemId)) {
        totalPrice.value = calculateSelectedItemsTotal();
      }
    } catch (e) {
      log(e.toString());
      CustomSnackBar.showCustomErrorSnackBar(
          title: 'Error', message: 'Gagal menambah quantity produk');
    }
  }

  // Fungsi untuk decrement quantity
  Future<void> decrementQuantity(int itemId) async {
    try {
      final index =
          cartProductList.indexWhere((item) => item.product![0].id == itemId);

      if (index != -1 && (cartProductList[index].quantity ?? 0) > 1) {
        cartProductList[index].quantity =
            (cartProductList[index].quantity ?? 0) - 1;
        cartProductList.refresh();
        await storage.saveList('cart', cartProductList);
        totalPrice.value = calculateTotalPrice();
      }

      // Perbarui total harga jika item yang diubah adalah item yang dipilih
      if (selectedItems.contains(itemId)) {
        totalPrice.value = calculateSelectedItemsTotal();
      }
    } catch (e) {
      log(e.toString());
      CustomSnackBar.showCustomErrorSnackBar(
          title: 'Error', message: 'Gagal menambah quantity produk');
    }
  }

  // Fungsi untuk mendapatkan jumlah item yang dipilih
  int get selectedItemCount => selectedItems.length;

  // Fungsi untuk checkout item yang dipilih
  Future<void> checkoutSelectedItems() async {
    log(selectedItems.toString());
    if (selectedItems.isEmpty) {
      CustomSnackBar.showCustomErrorSnackBar(
        title: 'Error',
        message: 'Pilih minimal satu produk untuk checkout',
      );
      return;
    }

    // Implementasi checkout akan ditambahkan di sini
    // Misalnya navigasi ke halaman checkout dengan membawa data item yang dipilih
    // final selectedProducts = cartProductList
    //     .where((item) => selectedItems.contains(item.product![0].id))
    //     .toList();

    // Get.toNamed('/checkout', arguments: selectedProducts);
  }

  // Fungsi untuk membersihkan semua pilihan
  void clearSelection() {
    selectedStores.clear();
    selectedItems.clear();
  }
}
