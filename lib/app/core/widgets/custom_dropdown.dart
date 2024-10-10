// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:plantix_app/app/core/theme/app_color.dart';
import 'package:plantix_app/app/core/theme/typography.dart';

class CustomDropdown extends StatelessWidget {
  final String hintText;
  final String? value;
  void Function(String?)? onChanged;
  final List<DropdownMenuItem<String>> items;
  final String? Function(String?)? validator;
  final int? maxLines;

  CustomDropdown({
    Key? key,
    required this.hintText,
    this.value,
    this.onChanged,
    required this.items,
    this.validator,
    this.maxLines,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      isExpanded: true,
      decoration: InputDecoration(
        label: Text(hintText),
        contentPadding: const EdgeInsets.all(12),
        prefixIconColor: AppColors.primary,
        suffixIconColor: Colors.grey[400],
        fillColor: const Color(0xFFE7E5E5),
        filled: true,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: AppColors.primary),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
        hintText: hintText,
      ),
      focusColor: const Color(0xFFE7E5E5),
      style: TStyle.bodyText2,
      elevation: 3,
      borderRadius: BorderRadius.circular(8),
      dropdownColor: const Color(0xFFF0F0F0),
      value: value,
      validator: validator,
      onChanged: onChanged,
      items: items,
    );
  }
}
