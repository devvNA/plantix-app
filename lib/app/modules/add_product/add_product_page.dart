// ignore_for_file: unnecessary_null_comparison

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plantix_app/app/data/models/product_model.dart';

import 'add_product_controller.dart';

class AddProductPage extends GetView<AddProductController> {
  const AddProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final descController = TextEditingController();
    final priceController = TextEditingController();
    final stockController = TextEditingController();
    final categoryController = TextEditingController();
    final images = <File>[].obs;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Produk'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Nama Produk',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Deskripsi',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Harga',
                border: OutlineInputBorder(),
                prefixText: 'Rp ',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: stockController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Stok',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: categoryController,
              decoration: const InputDecoration(
                labelText: 'Kategori',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () async {
                final result =
                    await ImagePicker().pickMultiImage(imageQuality: 70);
                if (result != null) {
                  images.value =
                      result.map((xFile) => File(xFile.path)).toList();
                }
              },
              icon: const Icon(Icons.photo_library),
              label: const Text('Pilih Foto'),
            ),
            const SizedBox(height: 8),
            Obx(() => Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (var image in images)
                      Stack(
                        children: [
                          Image.file(
                            image,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                          Positioned(
                            right: 0,
                            child: IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () => images.remove(image),
                            ),
                          ),
                        ],
                      ),
                  ],
                )),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isEmpty ||
                    priceController.text.isEmpty ||
                    stockController.text.isEmpty) {
                  Get.snackbar(
                    'Error',
                    'Mohon lengkapi semua data',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                  return;
                }

                final product = Product(
                  storeName: 'Toko Makmur',
                  id: 1,
                  name: nameController.text,
                  description: descController.text,
                  price: double.parse(priceController.text),
                  stock: int.parse(stockController.text),
                  images: [],
                  category: categoryController.text,
                  harvestDate: DateTime.now(),
                  isAvailable: true,
                  storeAddress: 'Jl. Raya',
                );

                controller.addProduct(product, images);
              },
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}
