import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:plantix_app/app/core/theme/app_color.dart';
import 'package:plantix_app/app/core/theme/typography.dart';

class BottomSheetCart extends StatelessWidget {
  int? quantity;
  final void Function()? onPressed;
  final void Function()? onDecrease;
  final void Function()? onIncrease;

  BottomSheetCart({
    super.key,
    this.quantity = 1,
    this.onPressed,
    this.onDecrease,
    this.onIncrease,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            children: [
              Text('Jumlah',
                  style: TStyle.bodyText2.copyWith(
                    fontWeight: FontWeight.bold,
                  )),
              Spacer(),
              InkWell(
                onTap: onDecrease,
                child: const Icon(
                  Icons.remove,
                  size: 20.0,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 8.0),
              Text("$quantity",
                  style:
                      TStyle.bodyText2.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(width: 8.0),
              InkWell(
                onTap: onIncrease,
                child: const Icon(
                  Icons.add,
                  size: 20.0,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: onPressed,
            child: Text("Masukkan ke keranjang",
                style: TStyle.head5.copyWith(
                  color: Colors.white,
                )),
          ),
        ],
      ).animate().moveY(
            begin: 100,
            duration: Duration(milliseconds: 100),
            curve: Curves.easeInOut,
          ),
    );
  }
}
