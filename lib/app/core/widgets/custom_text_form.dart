import 'package:flutter/material.dart';
import 'package:plantix_app/app/core/theme/app_color.dart';
import 'package:plantix_app/app/core/theme/typography.dart';

class CustomTextForm extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final bool? obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final Function()? onTap;
  final Function()? onEditingComplete;
  final Function()? onTapOutside;
  final String? Function(String?)? validator;
  final String? prefixText;
  final String? suffixText;
  final int? maxLines;
  final TextInputType? keyboardType;
  final String? initialValue;
  final String? helperText;
  final bool? enabled;

  const CustomTextForm({
    super.key,
    this.controller,
    required this.hintText,
    this.obscureText,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.onEditingComplete,
    this.onTapOutside,
    this.validator,
    this.suffixText,
    this.prefixText,
    this.maxLines,
    this.keyboardType,
    this.initialValue,
    this.helperText,
    this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: enabled ?? true,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      initialValue: initialValue,
      keyboardType: keyboardType ?? TextInputType.text,
      style: TStyle.bodyText1,
      obscureText: obscureText ?? false,
      controller: controller,
      maxLines: maxLines,
      cursorColor: AppColors.primary,
      // scrollPadding: EdgeInsets.only(
      //     bottom: MediaQuery.of(context).viewInsets.bottom +
      //         MediaQuery.of(context).size.height),
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        helperText: helperText,
        prefixText: prefixText,
        hintText: hintText,
        hintStyle: TStyle.bodyText1.copyWith(color: Colors.grey[500]),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        prefixIconColor: AppColors.primary,
        suffixIconColor: Colors.grey[200],
        fillColor: Colors.grey[200],
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
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        suffixText: suffixText,
      ),
      onChanged: onChanged,
      validator: validator,
    );
  }
}

class CustomTextFormWithIcon extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? Function(String?)? validator;
  final IconData? prefixIcon;
  final TextInputType? keyboardType;
  final bool? obscureText;
  final int? maxLines;
  final EdgeInsetsGeometry? contentPadding;
  final Widget? suffixIcon;
  final bool? enabled;

  const CustomTextFormWithIcon({
    super.key,
    this.controller,
    this.hintText,
    this.validator,
    this.prefixIcon,
    this.keyboardType,
    this.obscureText,
    this.maxLines,
    this.contentPadding,
    this.suffixIcon,
    this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: enabled ?? true,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: controller,
      maxLines: maxLines ?? 1,
      obscureText: obscureText ?? false,
      scrollPadding:
          EdgeInsets.only(bottom: MediaQuery.of(context).size.height),
      cursorColor: AppColors.primary,
      keyboardType: keyboardType,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        suffixIcon: suffixIcon,
        contentPadding: contentPadding ?? EdgeInsets.symmetric(horizontal: 0),
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
        prefixIcon: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 10),
          child: Icon(prefixIcon ?? Icons.abc),
        ),
      ),
      validator: validator,
    );
  }
}
