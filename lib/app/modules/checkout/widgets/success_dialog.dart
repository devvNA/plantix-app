import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:plantix_app/app/core/theme/app_color.dart';
import 'package:plantix_app/app/core/theme/typography.dart';
import 'package:plantix_app/app/routes/list_transaction_routes.dart';

void showSuccessDialog() {
  Get.dialog(
    barrierDismissible: false,
    Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              "assets/images/icon/success-checkout.svg",
              width: 120,
              height: 120,
            ).animate().scale(duration: 400.ms, curve: Curves.elasticOut),
            const SizedBox(height: 24),
            Text(
              "Pesanan Berhasil!",
              style: TStyle.head3.copyWith(
                color: AppColors.success,
                fontWeight: FontWeight.bold,
              ),
            ).animate().fadeIn(delay: 300.ms),
            const SizedBox(height: 12),
            Text(
              "Terima kasih telah berbelanja. Pesanan Anda sedang diproses.",
              textAlign: TextAlign.center,
              style: TStyle.bodyText2.copyWith(color: Colors.grey[600]),
            ).animate().fadeIn(delay: 400.ms),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Get.back();
                Get.back();
                Get.back();
                Get.toNamed(HistoryTransactionRoutes.historyTransaction);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                minimumSize: const Size(double.infinity, 45),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                "Lihat Riwayat Pesanan",
                style: TStyle.bodyText1.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ).animate().fadeIn(delay: 500.ms).moveY(begin: 10, end: 0),
          ],
        ),
      ),
    ),
  );
}
