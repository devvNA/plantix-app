import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:plantix_app/app/core/helpers/thousand_separator_formatter.dart';
import 'package:plantix_app/app/core/helpers/validator.dart';
import 'package:plantix_app/app/core/theme/typography.dart';
import 'package:plantix_app/app/core/widgets/custom_text_form.dart';
import 'package:plantix_app/app/modules/detail_analisa_usaha/detail_analisa_usaha_controller.dart';

class AddSpendBottomSheet extends GetView<DetailAnalisaUsahaController> {
  AddSpendBottomSheet({super.key});
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.36,
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 8.0,
            ),
            Text(
              'Pengeluaran',
              style: TStyle.head4,
            ),
            SizedBox(height: 16),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextFormSimple(
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
                    controller: controller.spendController,
                    label: 'Harga',
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      ThousandsSeparatorInputFormatter(),
                    ],
                    validator: Validator.required,
                  ),
                  const SizedBox(height: 12),
                  CustomTextFormSimple(
                    controller: controller.descriptionController,
                    label: 'Keterangan',
                    validator: Validator.required,
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _submitData,
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }

  _submitData() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      controller.createSpend();

      if (Get.isDialogOpen!) {
        controller.spendController.clear();
        controller.descriptionController.clear();
      }
    }
  }
}
