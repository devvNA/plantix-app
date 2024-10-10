import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantix_app/app/core/helpers/validator.dart';
import 'package:plantix_app/app/core/theme/typography.dart';
import 'package:plantix_app/app/core/widgets/custom_text_form.dart';
import 'package:plantix_app/app/modules/detail_analisa_usaha/detail_analisa_usaha_controller.dart';

import '../../../core/theme/app_color.dart';

class DialogHarvestWidget extends GetView<DetailAnalisaUsahaController> {
  DialogHarvestWidget();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Panen',
        style: TStyle.head4,
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextForm(
                initialValue: controller.jumlahPanen.value,
                keyboardType: TextInputType.number,
                hintText: 'Jumlah',
                obscureText: false,
                validator: Validator.required,
                suffixIcon: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 13.0, horizontal: 13),
                  child: Text(
                    'kg',
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                ),
                onChanged: (value) {
                  controller.jumlahPanen.value = value;
                },
              ),
              const SizedBox(
                height: 8.0,
              ),
              CustomTextForm(
                keyboardType: TextInputType.number,
                prefixIcon: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 13.0, horizontal: 13),
                  child: Text(
                    'Rp',
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                ),
                hintText: 'Harga',
                obscureText: false,
                validator: Validator.required,
                onChanged: (value) {
                  controller.hargaPanen.value = double.parse(value);
                },
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
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      controller.setPanen(
                        double.parse(controller.jumlahPanen.value),
                        controller.hargaPanen.value,
                      );
                    }
                  },
                  child: const Text("Simpan"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
