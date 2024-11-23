import 'package:flutter/material.dart';
import 'package:plantix_app/app/core/theme/app_color.dart';

extension ContextExtension on BuildContext {
  void showSnackBar(
    String message, {
    bool isError = false,
    Duration duration = const Duration(milliseconds: 1500),
  }) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor:
            isError ? Theme.of(this).colorScheme.error : AppColors.success,
        duration: duration,
      ),
    );
  }
}
