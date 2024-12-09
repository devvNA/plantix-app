// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:plantix_app/app/core/theme/app_color.dart';
import 'package:plantix_app/app/core/theme/typography.dart';

class CustomDropDown extends StatelessWidget {
  final String hintText;
  final String? value;
  void Function(String?)? onChanged;
  final List<DropdownMenuItem<String>> items;
  final String? Function(String?)? validator;
  final int? maxLines;

  CustomDropDown({
    super.key,
    required this.hintText,
    this.value,
    this.onChanged,
    required this.items,
    this.validator,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      value: value,
      decoration: InputDecoration(
        prefixIconColor: AppColors.primary,
        suffixIconColor: Colors.grey[200],
        fillColor: Colors.grey[200],
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
        hintStyle: TStyle.bodyText1.copyWith(color: Colors.grey[500]),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        isDense: true,
      ),
      validator: validator,
      onChanged: onChanged,
      items: items,
    );
  }
}

class CustomDropDownSimple extends StatelessWidget {
  const CustomDropDownSimple({
    super.key,
    this.controller,
    required this.label,
    this.validator,
    this.onChanged,
    required this.items,
    this.value,
  });

  final TextEditingController? controller;
  final String label;
  final String? Function(String?)? validator;
  final void Function(String?)? onChanged;
  final List<DropdownMenuItem<String>> items;
  final String? value;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      isExpanded: true,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      value: value,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey),
        floatingLabelStyle: TextStyle(color: AppColors.primary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.primary),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.primary),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      items: items,
      validator: validator,
      onChanged: onChanged,
    );
  }
}
