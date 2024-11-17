import 'dart:developer';

import 'package:get/get.dart';
import 'package:plantix_app/app/data/models/keranjang_model.dart';

class CheckoutController extends GetxController {
  List<CartItem> selectedItems = Get.arguments;


  void checkData() {
    final cartList = selectedItems
        .map((item) => {
              'Nama': item.product![0].name,
              'Harga': item.product![0].price,
              'Quantity': item.quantity
            })
        .toList();
    log(cartList.toString());
    log("Total Item: ${selectedItems.length}");
  }


}
