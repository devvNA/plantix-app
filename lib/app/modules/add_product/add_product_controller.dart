import 'dart:io';

import 'package:get/get.dart';
import 'package:plantix_app/app/data/models/product_model.dart';
import 'package:plantix_app/app/modules/sales/sales_controller.dart';

class AddProductController extends GetxController {
  //TODO: Implement AddProductController.


  Future<void> addProduct(Product product, List<File> imageFiles) async {
    await Get.find<SalesController>().addProduct(product, imageFiles);
  }


}
