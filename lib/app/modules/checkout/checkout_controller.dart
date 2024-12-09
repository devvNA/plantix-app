// ignore_for_file: unnecessary_overrides

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantix_app/app/data/models/keranjang_model.dart';
import 'package:plantix_app/main.dart';

class CheckoutController extends GetxController {
  List<CartItem> cartList = Get.arguments;
  final alamatController =
      TextEditingController(text: user.currentUser?.address ?? "");
  final isLoading = false.obs;
  final isButtonActive = false.obs;

  String? paymentMethod;
  List<DropdownMenuItem<String>> get paymentDropDownItems {
    List<DropdownMenuItem<String>> paymentItems = [
      const DropdownMenuItem(value: "COD", child: Text("COD")),
      const DropdownMenuItem(value: "Transfer", child: Text("Transfer")),
    ];
    return paymentItems;
  }

  @override
  void onInit() {
    super.onInit();
  }

  onSelectedPayment(String paymentChoice) {
    paymentMethod = paymentChoice;
    isButtonActive.value = paymentChoice.isNotEmpty;
    update();
    log(paymentChoice);
  }

  double totalOrderItem(int index) {
    return cartList[index].product!.price! * cartList[index].quantity!;
  }

  double totalPayment() {
    double totalPembayaran = 0;
    for (var cart in cartList) {
      totalPembayaran += cart.product!.price! * cart.quantity!;
    }
    return totalPembayaran;
  }

  String getCategory(int index) {
    return cartList[index].product!.category ?? "";
  }

  String getImgUrl(int index) {
    return cartList[index].product!.images?[0] ?? "";
  }

  Future<void> purchaseOrder() async {
    isLoading.value = true;
    // final response = await PemesananUseCase(
    //         repository: PemesananRepositoryImpl(
    //             remoteDataSource: PemesananRemoteDataSourceImpl()))
    //     .postPemesanan(
    //   idUser: outlet!.id,
    //   tanggal: DateTime.now().toFormattedDateWithDay(),
    //   tipePayment: selectedPayment!,
    //   total: totalPayment(),
    // );
    // Get.put(HistoryController());

    // response.fold(
    //   (failure) {
    //     Get.back();
    //     log("Error: ${failure.message}");
    //     CustomSnackBar.showCustomErrorSnackBar(
    //       title: "Gagal",
    //       message: failure.message,
    //     );
    //   },
    //   (message) {
    //     messageServer = message;
    //     log(message);
    //     // CustomSnackBar.showCustomSuccessSnackBar(
    //     //   title: "Berhasil",
    //     //   message: message,
    //     // );
    //   },
    // );
    redirectHistory();
    isLoading.value = false;
  }

  redirectHistory() {
    Get.back();
    // Get.find<CartController>().onRefreshKeranjang();
    Get.back();
    Get.back();

    // Get.find<HistoryTransactionController>().onRefreshHistoriPemesanan();

    // Get.back();
  }

  void checkData() {
    final cartData = cartList
        .map((item) => {
              'Nama': item.product!.name,
              'Harga': item.product!.price,
              'Quantity': item.quantity
            })
        .toList();
    log(cartData.toString());
    log("Total Item: ${cartList.length}");
  }
}
