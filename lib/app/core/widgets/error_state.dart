import 'package:flutter/material.dart';
import 'package:plantix_app/app/core/theme/app_color.dart';
import 'package:plantix_app/app/core/theme/typography.dart';

class ErrorStateWidget extends StatelessWidget {
  final String message;

  const ErrorStateWidget({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              color: AppColors.error,
              size: 32.0,
            ),
            const SizedBox(height: 12.0),
            Text(
              message,
              style: TStyle.bodyText3,
            )
          ],
        ),
      ),
    );
  }
}
