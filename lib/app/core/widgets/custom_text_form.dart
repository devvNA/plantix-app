import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:plantix_app/app/core/theme/app_color.dart';

class CustomTextForm extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;
  final TextInputType? keyboardType;
  final bool? obscureText;
  final int? maxLines;
  final Widget? suffixIcon;
  final bool? enabled;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final Function()? onTap;
  final Function()? onEditingComplete;
  final Function()? onTapOutside;
  final String? prefixText;
  final String? suffixText;
  final String? initialValue;
  final String? helperText;
  final List<TextInputFormatter>? inputFormatters;

  const CustomTextForm({
    super.key,
    this.controller,
    required this.hintText,
    this.validator,
    this.prefixIcon,
    this.keyboardType,
    this.obscureText,
    this.maxLines,
    this.suffixIcon,
    this.enabled,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.onEditingComplete,
    this.onTapOutside,
    this.prefixText,
    this.suffixText,
    this.initialValue,
    this.helperText,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: enabled ?? true,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: controller,
      maxLines: maxLines ?? 1,
      obscureText: obscureText ?? false,
      scrollPadding: EdgeInsets.only(bottom: MediaQuery.sizeOf(context).height),
      cursorColor: AppColors.primary,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        suffixIcon: suffixIcon,
        prefixIconColor: AppColors.primary,
        suffixIconColor: Colors.grey[400],
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
        prefixIcon:
            prefixIcon != null
                ? Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 10),
                  child: prefixIcon,
                )
                : null,
      ),
      validator: validator,
    );
  }
}

class CustomTextFormSimple extends StatelessWidget {
  final TextEditingController? controller;
  final String label;
  final int? maxLines;
  final String? prefixText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final String? suffixText;
  final void Function()? onTap;
  final Function(String)? onChanged;
  final bool? readOnly;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final List<TextInputFormatter>? inputFormatters;
  final String? initialValue;

  const CustomTextFormSimple({
    super.key,
    this.controller,
    required this.label,
    this.maxLines,
    this.prefixText,
    this.keyboardType,
    this.validator,
    this.suffixText,
    this.onTap,
    this.readOnly,
    this.suffixIcon,
    this.prefixIcon,
    this.inputFormatters,
    this.initialValue,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      inputFormatters: inputFormatters,
      readOnly: readOnly ?? false,
      onTap: onTap,
      onChanged: onChanged,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixText: prefixText,
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
        suffixText: suffixText,
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
      ),
    );
  }
}
