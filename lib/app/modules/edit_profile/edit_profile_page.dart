import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:plantix_app/app/core/theme/app_color.dart';
import 'package:plantix_app/app/core/theme/typography.dart';
import 'package:plantix_app/app/core/widgets/custom_loading.dart';
import 'package:plantix_app/app/core/widgets/custom_text_form.dart';
import 'package:plantix_app/main.dart';

import 'edit_profile_controller.dart';

class EditProfilePage extends GetView<EditProfileController> {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Edit Profil'),
          centerTitle: true,
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: LoadingWidget(),
            );
          }
          return RefreshIndicator(
            onRefresh: () async {
              controller.onRefresh();
            },
            child: ListView(
              children: [
                const SizedBox(
                  height: 8.0,
                ),
                _buildProfileItem(
                  context: context,
                  label: "Nama Lengkap",
                  value: user.currentUser!.name,
                ),
                Divider(
                  thickness: 2,
                ),
                _buildProfileItem(
                  context: context,
                  label: "Email",
                  value: user.currentUser!.email,
                ),
                Divider(
                  thickness: 2,
                ),
                _buildProfileItem(
                  context: context,
                  label: "Alamat",
                  value: user.currentUser?.address ?? "",
                ),
                Divider(
                  thickness: 2,
                ),
                _buildProfileItem(
                  context: context,
                  label: "No. Telp",
                  value: user.currentUser?.phoneNumber.toString() ?? "",
                ),
                Divider(
                  thickness: 2,
                ),
              ],
            ),
          );
        }));
  }

  Widget _buildProfileItem({
    required BuildContext context,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TStyle.bodyText2.copyWith(
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                Text(
                  value,
                  style: TStyle.bodyText1,
                ),
              ],
            ),
          ),
          TextButton(
            style: TextButton.styleFrom(
              minimumSize: Size(50, 25),
              padding: EdgeInsets.zero,
              side: BorderSide(color: AppColors.primary),
            ),
            onPressed: () => _showEditDialog(context, label, value),
            child: Text(
              "Edit",
              style: TStyle.bodyText3.copyWith(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(
    BuildContext context,
    String label,
    String currentValue,
  ) {
    final TextEditingController textController =
        TextEditingController(text: currentValue);

    final ValueNotifier<bool> isValueChanged = ValueNotifier<bool>(false);

    textController.addListener(() {
      isValueChanged.value = textController.text != currentValue;
    });

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit $label'),
        content: CustomTextForm(
          keyboardType: label == 'No. Telp' ? TextInputType.number : null,
          inputFormatters: label == 'No. Telp'
              ? [
                  FilteringTextInputFormatter.digitsOnly,
                ]
              : null,
          hintText: label,
          controller: textController,
          maxLines: label == 'Alamat' ? 3 : 1,
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.grey,
            ),
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Batal',
              style: TStyle.bodyText2.copyWith(color: Colors.grey),
            ),
          ),
          ValueListenableBuilder<bool>(
            valueListenable: isValueChanged,
            builder: (context, changed, child) {
              return TextButton(
                onPressed: changed
                    ? () {
                        switch (label) {
                          case 'Nama Lengkap':
                            controller.updateName(textController.text);
                            break;
                          case 'Email':
                            controller.updateEmail(textController.text);
                            break;
                          case 'Alamat':
                            controller.updateAddress(textController.text);
                            break;
                          case 'No. Telp':
                            controller.updatePhone(textController.text);
                            break;
                        }
                        Navigator.pop(context);
                      }
                    : null,
                style: TextButton.styleFrom(),
                child: Text(
                  'Simpan',
                  style: TStyle.bodyText2.copyWith(
                    color: changed ? AppColors.primary : Colors.grey,
                    fontWeight: changed ? FontWeight.bold : null,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
