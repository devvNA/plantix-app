// ignore_for_file: unnecessary_overrides

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plantix_app/app/core/extensions/snackbar_ext.dart';
import 'package:plantix_app/app/core/helpers/thousand_separator_formatter.dart';
import 'package:plantix_app/app/core/widgets/custom_snackbar.dart';
import 'package:plantix_app/app/data/models/product_model.dart';
import 'package:plantix_app/app/data/repositories/my_store_repository.dart';
import 'package:plantix_app/app/modules/my_products/my_products_controller.dart';
import 'package:plantix_app/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddProductController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final descController = TextEditingController();
  final priceController = TextEditingController();
  final stockController = TextEditingController();
  final categoryController = TextEditingController();

  final imageUrls = <String>[].obs;
  final images = <XFile>[].obs;
  final isLoading = false.obs;
  final picker = ImagePicker();

  final myStoreRepo = MyStoreRepository();

  // Ambil data jika Sudah Punya Produk
  ProductsModel? product = Get.arguments;
  bool get isEditMode => product != null;

  @override
  void onInit() {
    super.onInit();
    if (isEditMode) {
      log(product!.toJson().toString());
      nameController.text = product!.name;
      descController.text = product!.description;
      priceController.text = product!.price.toString();
      stockController.text = product!.stock.toString();
      categoryController.text = product!.category;
      imageUrls.assignAll(product!.imageUrl);
      log(imageUrls.toString());
    }
  }

  Future<void> onSubmit() async {
    final price = ThousandsSeparatorInputFormatter.getUnformattedValue(
        priceController.text);

    if (formKey.currentState!.validate()) {
      isLoading.value = true;
      if (isEditMode) {
        await onSubmitUpdateProduct(price);
      } else {
        if (images.isEmpty) {
          Get.context!.showSnackBar('Gambar produk wajib diisi', isError: true);
          isLoading.value = false;
          return;
        }
        await onSubmitCreateProduct(price);
      }
      isLoading.value = false;
    }
  }

  Future onSubmitCreateProduct(String price) async {
    await onUploadMultipleImageProducts();
    final result = await myStoreRepo.addProductToStore(
      storeId: myStore.currentStore!.id,
      name: nameController.text,
      description: descController.text,
      price: int.parse(price),
      stock: int.parse(stockController.text),
      category: categoryController.text,
      imageUrl: imageUrls,
    );

    result.fold(
        (failure) => Get.context!.showSnackBar(failure.message, isError: true),
        (data) {
      Get.back();
      snackbarSuccess(message: 'Sukses', body: 'Produk berhasil ditambahkan');
    });
  }

  Future<void> onSubmitUpdateProduct(String price) async {
    await onUploadMultipleImageProducts();
    final result = await myStoreRepo.updateProduct(
      productId: product!.id,
      name: nameController.text,
      description: descController.text,
      price: int.parse(price),
      stock: int.parse(stockController.text),
      category: categoryController.text,
      imageUrl: imageUrls,
    );
    result.fold(
        (failure) => Get.context!.showSnackBar(failure.message, isError: true),
        (data) {
      Get.back();
      snackbarSuccess(message: 'Sukses', body: 'Produk berhasil diubah');
    });
  }

  Future<void> chooseImage() async {
    final result = await picker.pickMultiImage(
      maxHeight: 800,
      maxWidth: 800,
      imageQuality: 80,
    );
    if (result.isEmpty) return;

    images.value = result.map((xFile) => XFile(xFile.path)).toList();
  }

  Future<void> onUploadMultipleImageProducts() async {
    try {
      for (var imageFile in images) {
        final bytes = await imageFile.readAsBytes();
        final fileExt = imageFile.path.split('.').last;
        final fileName =
            '${DateTime.now().toIso8601String()}_${imageUrls.length}.$fileExt';
        final filePath = 'product images/$fileName';

        await supabase.storage.from('stores').uploadBinary(
              filePath,
              bytes,
              fileOptions: FileOptions(contentType: imageFile.mimeType),
            );

        final imageUrl = await supabase.storage
            .from('stores')
            .createSignedUrl(filePath, 157680000);

        imageUrls.add(imageUrl);
      }
    } on StorageException catch (error) {
      Get.context!.showSnackBar(error.message, isError: true);
      return;
    } catch (error) {
      Get.context!.showSnackBar(error.toString(), isError: true);
      return;
    }

    // final result = await uploadMultipleImage(
    //     bucketName: 'stores', folderPath: "product images");
    // imageUrls.addAll(result ?? []);
  }

  checkImageData() {
    // log("store_id: ${myStore.currentStore!.id}, ${myStore.currentStore!.id.runtimeType.toString()}");
    log(imageUrls.length.toString());
    log(priceController.text);
    // log(images.toString());
    // for (var image in imageUrls) {
    //   log(image);
    // }
    // for (var image in images) {
    //   log(image.path);
    // }
  }

  @override
  void onClose() async {
    nameController.dispose();
    descController.dispose();
    priceController.dispose();
    stockController.dispose();
    categoryController.dispose();

    images.clear();
    imageUrls.clear();

    await Get.find<MyProductsController>().onRefresh();

    super.onClose();
  }
}
