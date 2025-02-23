import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:plantix_app/app/core/helpers/thousand_separator_formatter.dart';
import 'package:plantix_app/app/core/helpers/validator.dart';
import 'package:plantix_app/app/core/theme/typography.dart';
import 'package:plantix_app/app/core/widgets/custom_text_form.dart';
import 'package:plantix_app/app/modules/detail_analisa_usaha/detail_analisa_usaha_controller.dart';

import '../../../core/theme/app_color.dart';

class DialogHarvestWidget extends GetView<DetailAnalisaUsahaController> {
  DialogHarvestWidget({super.key});
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
                CustomTextFormSimple(
                  controller: controller.jmlPanenController,
                  keyboardType: TextInputType.number,
                  label: 'Jumlah',
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
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
                ),
                const SizedBox(
                  height: 8.0,
                ),
                CustomTextFormSimple(
                  controller: controller.hargaPanenController,
                  label: 'Harga',
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    ThousandsSeparatorInputFormatter(),
                  ],
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
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        controller.setPanen();
                      }
                    },
                    child: const Text("Simpan"),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
