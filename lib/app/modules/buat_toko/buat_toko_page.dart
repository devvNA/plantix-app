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
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.isEditMode ? 'Edit Toko' : 'Buat Toko'),
        centerTitle: true,
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
                              image: controller.storeImageUrl.value.isNotEmpty
                                  ? NetworkImage(controller.storeImageUrl.value)
                                  : NetworkImage(
                                      "https://res.cloudinary.com/dotz74j1p/image/upload/v1715660683/no-image.jpg",
                                    ),
                              fit: BoxFit.cover,
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                          ),
                        ),
                      );
                    }),
                  ).paddingOnly(top: 16),
                  const SizedBox(
                    height: 40.0,
                  ),
                  Form(
                    key: controller.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Apa Nama Toko Anda?",
                          style: TStyle.head5,
                        ),
                        const SizedBox(
                          height: 8.0,
                        ),
                        CustomTextForm(
                          hintText: "Nama",
                          controller: controller.storeNameController,
                          validator: Validator.required,
                        ),
                        const SizedBox(height: 16.0),
                        Text(
                          "Detail Alamat",
                          style: TStyle.head5,
                        ),
                        const SizedBox(
                          height: 8.0,
                        ),
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
    );
  }
}
