// ignore_for_file: unnecessary_null_comparison

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:plantix_app/app/core/helpers/thousand_separator_formatter.dart';
import 'package:plantix_app/app/core/theme/typography.dart';
import 'package:plantix_app/app/core/widgets/custom_dropdown.dart';
import 'package:plantix_app/app/core/widgets/custom_loading.dart';
import 'package:plantix_app/app/core/widgets/custom_text_form.dart';

import 'add_product_controller.dart';

class AddProductPage extends GetView<AddProductController> {
  const AddProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.isEditMode ? 'Edit Produk' : 'Tambah Produk'),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: controller.checkImageData,
            icon: Icon(
              Icons.check,
              color: Colors.transparent,
            ),
          ),
        ],
      ),
      body: Obx(() => Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildImagePicker(),
                      const SizedBox(height: 24),
                      CustomTextFormSimple(
                        controller: controller.nameController,
                        label: 'Nama Produk',
                        validator: (v) =>
                            v!.isEmpty ? 'Nama produk wajib diisi' : null,
                      ),
                      const SizedBox(height: 16),
                      CustomTextFormSimple(
                        controller: controller.descController,
                        label: 'Deskripsi',
                        maxLines: 3,
                        validator: (v) =>
                            v!.isEmpty ? 'Deskripsi wajib diisi' : null,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: CustomTextFormSimple(
                              controller: controller.priceController,
                              label: 'Harga per kg',
                              prefixText: 'Rp ',
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                ThousandsSeparatorInputFormatter(),
                              ],
                              validator: (v) =>
                                  v!.isEmpty ? 'Harga wajib diisi' : null,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: CustomTextFormSimple(
                              controller: controller.stockController,
                              label: 'Stok',
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              validator: (v) =>
                                  v!.isEmpty ? 'Deskripsi wajib diisi' : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      CustomDropDownSimple(
                        value: controller.categoryController.text.isEmpty
                            ? null
                            : controller.categoryController.text,
                        items: [
                          DropdownMenuItem(
                            value: 'Sayuran',
                            child: Text('Sayuran'),
                          ),
                          DropdownMenuItem(
                            value: 'Buah',
                            child: Text('Buah'),
                          ),
                          DropdownMenuItem(
                            value: 'Lainnya',
                            child: Text('Lainnya'),
                          ),
                        ],
                        label: 'Kategori',
                        validator: (v) =>
                            v == null ? 'Kategori wajib diisi' : null,
                        onChanged: (value) {
                          controller.categoryController.text = value ?? '';
                        },
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : controller.onSubmit,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          controller.isLoading.value
                              ? 'Menyimpan...'
                              : 'Simpan Produk',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (controller.isLoading.value) const LoadingWidgetBG(),
            ],
          )),
    );
  }

  Widget _buildImagePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Ink(
          height: 200,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                offset: Offset(3, 3),
                blurRadius: 6,
              ),
            ],
          ),
          child: Obx(() =>
              controller.images.isEmpty && controller.imageUrls.isEmpty
                  ? _buildImagePickerButton()
                  : _buildImagePreview()),
        ),
        if (controller.images.isNotEmpty) ...[
          const SizedBox(height: 12),
          Text(
            '${controller.images.length} foto dipilih',
            style: TStyle.bodyText2,
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }

  Widget _buildImagePickerButton() {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () async {
        controller.chooseImage();
      },
      child: Ink(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_photo_alternate_outlined,
                size: 40, color: Colors.grey[400]),
            const SizedBox(height: 8),
            Text(
              'Tambah Foto Produk',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePreview() {
    return Stack(
      children: [
        PageView.builder(
          clipBehavior: Clip.hardEdge,
          scrollDirection: Axis.horizontal,
          itemCount: controller.isEditMode
              ? controller.imageUrls.length
              : controller.images.length,
          itemBuilder: (context, index) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: controller.isEditMode
                  ? Image.network(
                      controller.imageUrls[index],
                      fit: BoxFit.cover,
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: LoadingWidget(size: 22),
                        );
                      },
                      errorBuilder: (BuildContext context, Object exception,
                          StackTrace? stackTrace) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.error, color: Colors.red),
                              const SizedBox(height: 4),
                              const Text(
                                "Gagal memuat gambar",
                                style: TStyle.bodyText5,
                              ),
                            ],
                          ),
                        );
                      },
                    )
                  : Image.file(
                      File(controller.images[index].path),
                      fit: BoxFit.cover,
                    ),
            );
          },
        ),
        Positioned(
          top: 8,
          right: 8,
          child: Material(
            clipBehavior: Clip.hardEdge,
            color: Colors.black26,
            shape: CircleBorder(),
            child: IconButton(
              onPressed: () {
                if (controller.isEditMode) {
                  controller.imageUrls.clear();
                } else {
                  controller.images.clear();
                }
              },
              icon: const Icon(
                Icons.close,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
