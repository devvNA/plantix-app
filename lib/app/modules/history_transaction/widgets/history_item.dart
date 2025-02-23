// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantix_app/app/core/extensions/currency_ext.dart';
import 'package:plantix_app/app/core/extensions/date_time_ext.dart';
import 'package:plantix_app/app/core/theme/app_color.dart';
import 'package:plantix_app/app/core/theme/typography.dart';
import 'package:plantix_app/app/data/models/histori_transaksi_model.dart';

class HistoryItem extends StatelessWidget {
  final VoidCallback? onTap;
  final HistoriTransaksi historiData;

  const HistoryItem({
    super.key,
    this.onTap,
    required this.historiData,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      splashColor: AppColors.primary.withOpacity(0.25),
      onTap: onTap ?? () {},
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: const BoxDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "#${historiData.id}",
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(
                  height: 5.0,
                ),
                const Text(
                  " • ",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 5.0,
                ),
                Text(
                  historiData.tanggal.toFormattedDate(),
                  style: const TextStyle(fontSize: 11),
                ),
                const Spacer(),
                Visibility(
                  visible: historiData.status != "Dibatalkan",
                  child: ChipPaymentStatus(historiData: historiData),
                )
              ],
            ),
            const SizedBox(
              height: 5.0,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        historiData.detail[0].productName,
                        // "Perdana 10GB",
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 8.0,
                    ),
                    Text(
                      historiData.total.currencyFormatRp,
                      style: const TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 3.0,
                ),
                Row(
                  children: [
                    Text(
                      "${historiData.detail.length.toString()} item",
                      style: const TextStyle(
                        fontSize: 11.0,
                      ),
                    ),
                    const SizedBox(
                      width: 5.0,
                    ),
                    PaymentChipType(historiData: historiData),
                    const SizedBox(
                      width: 4.0,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ChipPaymentStatus extends StatelessWidget {
  const ChipPaymentStatus({
    super.key,
    required this.historiData,
  });

  final HistoriTransaksi historiData;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
        decoration: BoxDecoration(
          color: historiData.statusPembayaran == "Lunas"
              ? AppColors.success
              : AppColors.error,
          borderRadius: const BorderRadius.all(
            Radius.circular(
              32.0,
            ),
          ),
        ),
        child: Text(
          historiData.statusPembayaran.capitalize!,
          style: const TextStyle(
            fontSize: 9,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class PaymentChipType extends StatelessWidget {
  const PaymentChipType({
    super.key,
    required this.historiData,
  });

  final HistoriTransaksi historiData;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: historiData.tipePayment == "COD"
            ? const Color.fromARGB(255, 229, 174, 10)
            : const Color.fromARGB(255, 53, 70, 165),
        borderRadius: const BorderRadius.all(
          Radius.circular(
            32.0,
          ),
        ),
      ),
      child: Text(
        historiData.tipePayment,
        style: TStyle.bodyText5.copyWith(
          color: Colors.white,
        ),
      ),
    );
  }
}
