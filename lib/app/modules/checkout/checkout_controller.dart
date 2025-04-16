// ignore_for_file: unnecessary_overrides

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantix_app/app/core/extensions/snackbar_ext.dart';
import 'package:plantix_app/app/data/models/cart_model.dart';
import 'package:plantix_app/app/data/repositories/order_repository.dart';
import 'package:plantix_app/app/modules/cart/cart_controller.dart';
import 'package:plantix_app/main.dart';

class CheckoutController extends GetxController {
  List<CartModel> cartList = Get.arguments;
  final alamatController = TextEditingController(
    text: user.currentUser?.address ?? "masukkan alamat pengiriman",
  );
  final isLoading = false.obs;
  final isButtonActive = false.obs;
  final orderRepository = OrderRepository();

  String? paymentMethod;

  @override
  void onInit() {
    super.onInit();
  }

  onSelectedPayment(String paymentChoice) {
    paymentMethod = paymentChoice;
    isButtonActive.value = paymentChoice.isNotEmpty;
    update();
    log(paymentMethod!);
  }

  int totalOrderItem(int index) {
    return cartList[index].price * cartList[index].quantity;
  }

  int totalPayment() {
    int totalPembayaran = 0;
    for (var cart in cartList) {
      totalPembayaran += cart.price * cart.quantity;
    }
    return totalPembayaran;
  }

  String getCategory(int index) {
    return cartList[index].category;
  }

  String getImgUrl(int index) {
    return cartList[index].imageUrl[0];
  }

  Future<void> createOrder() async {
    isLoading.value = true;
    update();

    final result = await orderRepository.createOrder(
      cartList: cartList,
      totalPrice: totalPayment(),
      shippingAddress: alamatController.text,
      paymentMethod: paymentMethod ?? 'COD',
    );

    result.fold(
      (failure) {
        Get.context!.showCustomSnackBar(
          message: failure.message,
          isError: true,
        );
      },
      (success) {
        Get.find<CartController>().onRefresh();
      },
    );

    isLoading.value = false;
  }
}
