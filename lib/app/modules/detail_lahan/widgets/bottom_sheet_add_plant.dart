import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:plantix_app/app/core/helpers/validator.dart';
import 'package:plantix_app/app/core/theme/typography.dart';
import 'package:plantix_app/app/core/widgets/custom_text_form.dart';
import 'package:plantix_app/app/modules/detail_lahan/detail_lahan_controller.dart';

class AddPlantBottomSheet extends GetView<DetailLahanController> {
  AddPlantBottomSheet({super.key});
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 8.0,
            ),
            Text(
              'Tambah Tanaman',
              style: TStyle.head4,
            ),
            SizedBox(height: 16),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextForm(
                    controller: controller.plantNameController,
                    hintText: 'Tanaman',
                    obscureText: false,
                    validator: Validator.required,
                  ),
                  const SizedBox(height: 12),
                  CustomTextForm(
                    controller: controller.plantTypeController,
                    hintText: 'Jenis Tanaman',
                    obscureText: false,
                    validator: Validator.required,
                  ),
                  const SizedBox(height: 22),
                  Obx(() {
                    return ElevatedButton(
                      onPressed:
                          controller.isLoading.value ? null : _submitData,
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        controller.isLoading.value ? "Loading..." : "Simpan",
                        style: TStyle.bodyText2.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().moveY(
          begin: 100,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
  }

  void _submitData() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      controller.addPlant();
    }
  }
}
