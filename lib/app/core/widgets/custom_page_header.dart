import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantix_app/app/core/theme/app_color.dart';
import 'package:plantix_app/app/core/theme/typography.dart';

class PageHeader extends StatelessWidget {
  final String title;
  final double? height;

  const PageHeader({super.key, required this.title, this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.none,
      height: height ?? 120,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.primary,
            AppColors.secondary.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => Get.back(),
              child: Row(
                children: [
                  const Icon(Icons.arrow_back, color: Colors.white),
                  const SizedBox(width: 12.0),
                ],
              ),
            ),
            Expanded(
              child: Text(
                title,
                style: TStyle.head3.copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
