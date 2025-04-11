// ignore_for_file: unnecessary_overrides

import 'dart:developer';

import 'package:get/get.dart';
import 'package:plantix_app/app/core/extensions/currency_ext.dart';
import 'package:plantix_app/app/core/services/db_services.dart';
import 'package:plantix_app/app/core/widgets/custom_snackbar.dart';
import 'package:plantix_app/app/data/models/cart_model.dart';
import 'package:plantix_app/app/data/models/keranjang_model.dart';
import 'package:plantix_app/app/data/repositories/cart_repository.dart';

class CartController extends GetxController {
  final storage = LocalStorageService();
  final cartProductList = <CartModel>[].obs;
  final totalPrice = 0.0.obs;
  final groupedCartItems = <String, List<CartModel>>{}.obs;
  final isLoading = false.obs;

  // Menambahkan variabel untuk menyimpan item yang dipilih
  final selectedStores = <String>{}.obs;
  final selectedProducts = <int>{}.obs;

  // Fungsi untuk mendapatkan jumlah item yang dipilih
  int get selectedProductCount => selectedProducts.length;

  @override
  void onInit() {
    super.onInit();
    getCart();
  }

  Future<void> getCart() async {
    isLoading.value = true;
    final result = await CartRepository().getCartByID();
    result.fold(
      (failure) => snackbarError(message: "Kesalahan", body: failure.message),
      (cart) => cartProductList.addAll(cart),
    );
    isLoading.value = false;
  }

  void loadCartFromStorage() {
    cartProductList.value = storage.getList<CartModel>('cart') ?? [];
  }

  // Fungsi untuk increment quantity
  Future<void> incrementQuantity(int itemId) async {
    try {
      final index = cartProductList.indexWhere(
        (item) => item.productId == itemId,
      );

      if (index != -1) {
        final updatedQuantity = (cartProductList[index].quantity ?? 0) + 1;
        cartProductList[index].quantity = updatedQuantity;

        // Update juga di database
        final result = await CartRepository().updateCartQuantity(
          cartId: cartProductList[index].cartId,
          quantity: updatedQuantity,
        );

        result.fold(
          (failure) =>
              snackbarError(message: "Kesalahan", body: failure.message),
          (_) {
            cartProductList.refresh();
            // Perbarui total harga jika item yang diubah adalah item yang dipilih
            if (selectedProducts.contains(itemId)) {
              totalPrice.value = calculateSelectedItemsTotal();
            }
          },
        );
      }
    } catch (e) {
      snackbarError(
        message: "Kesalahan",
        body: "Gagal menambah quantity produk",
      );
    }
  }

  // Fungsi untuk decrement quantity
  Future<void> decrementQuantity(int itemId) async {
    try {
      final index = cartProductList.indexWhere(
        (item) => item.productId == itemId,
      );

      if (index != -1 && (cartProductList[index].quantity ?? 0) > 1) {
        final updatedQuantity = (cartProductList[index].quantity ?? 0) - 1;
        cartProductList[index].quantity = updatedQuantity;

        // Update juga di database
        final result = await CartRepository().updateCartQuantity(
          cartId: cartProductList[index].cartId,
          quantity: updatedQuantity,
        );

        result.fold(
          (failure) =>
              snackbarError(message: "Kesalahan", body: failure.message),
          (_) {
            cartProductList.refresh();
            // Perbarui total harga jika item yang diubah adalah item yang dipilih
            if (selectedProducts.contains(itemId)) {
              totalPrice.value = calculateSelectedItemsTotal();
            }
          },
        );
      }
    } catch (e) {
      snackbarError(
        message: "Kesalahan",
        body: "Gagal mengurangi quantity produk",
      );
    }
  }

  double calculateTotalPrice() {
    return cartProductList.fold(0.0, (sum, item) {
      num itemPrice = (item.price) * (item.quantity ?? 1);
      return sum + itemPrice;
    });
  }

  // Fungsi untuk menghapus produk dari keranjang
  Future<void> deleteProduct(CartModel data) async {
    try {
      final result = await CartRepository().deleteCartItem(data.cartId);

      result.fold(
        (failure) => snackbarError(message: "Kesalahan", body: failure.message),
        (_) {
          final index = cartProductList.indexWhere(
            (item) => item.cartId == data.cartId,
          );

          if (index != -1) {
            // Hapus dari daftar yang dipilih jika ada
            if (selectedProducts.contains(data.productId)) {
              selectedProducts.remove(data.productId);
            }

            cartProductList.removeAt(index);
            cartProductList.refresh();

            snackbarSuccess(
              message: "Sukses",
              body: "Produk berhasil dihapus",
              duration: 800,
              bottom: cartProductList.isEmpty ? 90 : 220,
            );
          }
        },
      );
    } catch (e) {
      snackbarError(message: "Kesalahan", body: "Gagal menghapus produk");
    }
  }

  // Fungsi untuk menghapus item yang dipilih
  Future<void> deleteSelectedItems() async {
    cartProductList.removeWhere(
      (item) => selectedProducts.contains(item.productId),
    );
    cartProductList.refresh();
    await storage.saveList('cart', cartProductList);
    totalPrice.value = calculateTotalPrice();
  }

  // Fungsi untuk mengecek data keranjang
  Future<void> checkData() async {
    log(storage.getList<CartItem>('cart')!.length.toString());
    var cartList =
        storage
            .getList<CartItem>('cart')!
            .map(
              (product) => {
                'Nama': product.product!.name,
                'Harga': product.product!.price,
                'Quantity': product.quantity,
              },
            )
            .toList();
    log(cartList.toString());
    log("Total Bayar: ${calculateTotalPrice().currencyFormatRp}");
  }

  Map<String, List<CartModel>> getGroupedCartItems() {
    Map<String, List<CartModel>> groupedItems = {};

    for (var item in cartProductList) {
      final storeName = item.storeName;
      if (!groupedItems.containsKey(storeName)) {
        groupedItems[storeName.toString()] = [];
      }
      groupedItems[storeName.toString()]!.add(item);
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
          .where((item) => item.storeName == storeName)
          .map((item) => item.productId);

      selectedProducts.removeAll(storeItems);
    } else {
      // Pilih toko dan semua item dari toko tersebut
      selectedStores.add(storeName);

      // Pilih semua item yang terkait dengan toko ini
      final storeItems = cartProductList
          .where((item) => item.storeName == storeName)
          .map((item) => item.productId);

      selectedProducts.addAll(storeItems.map((e) => e));
    }

    // Perbarui total harga setelah toko dipilih/tidak dipilih
    totalPrice.value = calculateSelectedItemsTotal();
  }

  // Fungsi untuk toggle pilihan item
  void toggleItemSelection(int itemId) {
    final item = cartProductList.firstWhere((item) => item.productId == itemId);
    final storeName = item.storeName;

    if (selectedProducts.contains(itemId)) {
      selectedProducts.remove(itemId);

      // Jika tidak ada item yang dipilih dari toko tersebut, hapus pilihan toko
      final hasSelectedStoreItems = cartProductList
          .where((item) => item.storeName == storeName)
          .any((item) => selectedProducts.contains(item.productId));

      if (!hasSelectedStoreItems) {
        selectedStores.remove(storeName);
      }
    } else {
      selectedProducts.add(itemId);

      // Jika semua item dari toko dipilih, pilih toko juga
      final allStoreItemsSelected = cartProductList
          .where((item) => item.storeName == storeName)
          .every((item) => selectedProducts.contains(item.productId));

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
        .where((item) => selectedProducts.contains(item.productId))
        .fold(0.0, (sum, item) {
          return sum + ((item.price) * (item.quantity ?? 1));
        });
  }

  // Fungsi untuk checkout item yang dipilih
  List<CartModel> checkoutSelectedItems() {
    // if (selectedProducts.isEmpty) {
    //   CustomSnackBar.showCustomErrorSnackBar(
    //     title: 'Error',
    //     message: 'Pilih minimal satu produk untuk checkout',
    //   );
    //   return [];
    // }

    // Implementasi checkout akan ditambahkan di sini
    // Misalnya navigasi ke halaman checkout dengan membawa data item yang dipilih
    final selectedItems =
        cartProductList
            .where((item) => selectedProducts.contains(item.productId))
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
