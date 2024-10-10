import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantix_app/app/core/helpers/validator.dart';
import 'package:plantix_app/app/core/theme/typography.dart';
import 'package:plantix_app/app/core/widgets/custom_text_form.dart';
import 'package:plantix_app/app/modules/detail_analisa_usaha/detail_analisa_usaha_controller.dart';

import '../../../core/theme/app_color.dart';

class DialogHarvestWidget extends GetView<DetailAnalisaUsahaController> {
  DialogHarvestWidget();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Jumlah Panen',
        style: TStyle.head4,
      ),
      content: SingleChildScrollView(
        child: Column(
          children: [
            CustomTextForm(
              controller: controller.harvestController,
              hintText: 'Harga',
              obscureText: false,
              validator: Validator.required,
            ),
            const SizedBox(
              height: 12.0,
            ),
            SizedBox(
              height: 35,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {},
                child: const Text("Simpan"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
