import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantix_app/app/core/helpers/validator.dart';
import 'package:plantix_app/app/core/theme/typography.dart';
import 'package:plantix_app/app/core/widgets/custom_loading.dart';
import 'package:plantix_app/app/core/widgets/custom_text_form.dart';

import 'buat_toko_controller.dart';

class BuatTokoPage extends GetView<BuatTokoController> {
  const BuatTokoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Cek apakah ada perubahan pada form
        if (controller.hasUnsavedChanges()) {
          // Tampilkan dialog konfirmasi
          final result = await _showSaveChangesDialog(context);
          // Jika result true, berarti user ingin menyimpan perubahan
          if (result == true) {
            controller.submitStore();
            return false; // Jangan tutup halaman dulu, biarkan submitStore() yang menangani
          }
          // Jika false, user tidak ingin menyimpan perubahan
          return result ?? false;
        }
        return true; // Tidak ada perubahan, langsung kembali
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(controller.isEditMode ? 'Edit Toko' : 'Buat Toko'),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () async {
              // Cek apakah ada perubahan pada form
              if (controller.hasUnsavedChanges()) {
                // Tampilkan dialog konfirmasi
                final result = await _showSaveChangesDialog(context);
                if (result == true) {
                  controller.submitStore();
                } else if (result == false) {
                  Get.back();
                }
                // Jika null, user membatalkan dialog, tidak lakukan apa-apa
              } else {
                Get.back();
              }
            },
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () {
              controller.submitStore();
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              controller.isEditMode ? 'Simpan' : 'Buat Toko',
              style: TStyle.head5.copyWith(color: Colors.white),
            ),
          ),
        ),
        body: Obx(() {
          return Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Obx(() {
                        return InkWell(
                          borderRadius: BorderRadius.circular(8.0),
                          onTap: () => controller.pickImage(),
                          child: Ink(
                            height: 160.0,
                            width: 160.0,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0x19000000),
                                  blurRadius: 16,
                                  offset: Offset(0, 11),
                                ),
                              ],
                              image: DecorationImage(
                                image:
                                    controller.storeImageUrl.value.isNotEmpty
                                        ? NetworkImage(
                                          controller.storeImageUrl.value,
                                        )
                                        : NetworkImage(
                                          "https://res.cloudinary.com/dotz74j1p/image/upload/v1715660683/no-image.jpg",
                                        ),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                            ),
                          ),
                        );
                      }),
                    ).paddingOnly(top: 16),
                    const SizedBox(height: 40.0),
                    Form(
                      key: controller.formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Apa Nama Toko Anda?", style: TStyle.head5),
                          const SizedBox(height: 8.0),
                          CustomTextForm(
                            hintText: "Nama",
                            controller: controller.storeNameController,
                            validator: Validator.required,
                          ),
                          const SizedBox(height: 16.0),
                          Text("Detail Alamat", style: TStyle.head5),
                          const SizedBox(height: 8.0),
                          CustomTextForm(
                            maxLines: 5,
                            hintText: "Alamat",
                            controller: controller.storeAddressController,
                            validator: Validator.required,
                            helperText: "Tulis No, Rumah, Blok, RT/RW, dll",
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (controller.isLoading.value) LoadingWidgetBG(),
            ],
          );
        }),
      ),
    );
  }

  Future<bool?> _showSaveChangesDialog(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          elevation: 3,
          clipBehavior: Clip.antiAlias,
          title: const Text('Simpan Perubahan?'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'Anda memiliki perubahan yang belum disimpan. Apakah anda ingin menyimpan perubahan ini?',
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
              ),
              child: const Text("Tidak"),
              onPressed: () {
                Get.back();
                Get.back();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Get.back();
                
              },
              child: const Text("Simpan"),
            ),
          ],
        );
      },
    );
  }
}
