import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantix_app/app/core/extensions/int_ext.dart';
import 'package:plantix_app/app/core/theme/app_color.dart';
import 'package:plantix_app/app/core/theme/typography.dart';
import 'package:plantix_app/app/core/widgets/custom_page_header.dart';
import 'package:plantix_app/app/routes/detail_analisa_usaha_routes.dart';

import 'analisa_usaha_tani_controller.dart';

class AnalisaUsahaTaniPage extends GetView<AnalisaUsahaTaniController> {
  const AnalisaUsahaTaniPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageHeader(
            title: 'Analisa Usaha',
            height: MediaQuery.of(context).size.height * 0.17,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.09),
              Expanded(
                  child: SingleChildScrollView(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    cardField(context: context, index: 0),
                  ],
                ),
              )),
            ],
          ),
        ],
      ),
    );
  }

  Card cardField({required BuildContext context, required int index}) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: InkWell(
        onTap: () {
          Get.toNamed(DetailAnalisaUsahaRoutes.detailAnalisaUsaha);
        },
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "Lahan Contoh",
                      style: TStyle.head5,
                    ),
                  ),
                  Chip(
                    padding: EdgeInsets.zero,
                    label: Text(
                      "Padi",
                      style: TStyle.bodyText3.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    backgroundColor: AppColors.primary,
                  ).paddingZero
                ],
              ),
              SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    Icons.calendar_month,
                    size: 20,
                    color: Colors.green[600],
                  ),
                  SizedBox(width: 8),
                  Text(
                    "Tgl. Tanam : "
                        .split(', ')
                        .map((word) => word.capitalize)
                        .join(', '),
                    style: TStyle.bodyText2,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    "27-09-2024",
                    style: TStyle.bodyText2,
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(
                    Icons.calendar_month,
                    size: 20,
                    color: Colors.green[600],
                  ),
                  SizedBox(width: 8),
                  Text(
                    "Tgl. Panen : "
                        .split(', ')
                        .map((word) => word.capitalize)
                        .join(', '),
                    style: TStyle.bodyText2,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    "-",
                    style: TStyle.bodyText2,
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(
                    Icons.shopping_cart_checkout_sharp,
                    size: 20,
                    color: Colors.green[600],
                  ),
                  SizedBox(width: 8),
                  Text(
                    "Jumlah Panen : "
                        .split(', ')
                        .map((word) => word.capitalize)
                        .join(', '),
                    style: TStyle.bodyText2,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    "-",
                    style: TStyle.bodyText2,
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(
                    Icons.attach_money_rounded,
                    size: 20,
                    color: Colors.green[600],
                  ),
                  SizedBox(width: 8),
                  Text(
                    "Pendapatan : "
                        .split(', ')
                        .map((word) => word.capitalize)
                        .join(', '),
                    style: TStyle.bodyText2,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    50000.currencyFormatRp,
                    style: TStyle.bodyText2,
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(
                    Icons.attach_money_rounded,
                    size: 20,
                    color: Colors.green[600],
                  ),
                  SizedBox(width: 8),
                  Text(
                    "Pengeluaran : "
                        .split(', ')
                        .map((word) => word.capitalize)
                        .join(', '),
                    style: TStyle.bodyText2,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    25000.currencyFormatRp,
                    style: TStyle.bodyText2,
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(
                    Icons.attach_money_rounded,
                    size: 20,
                    color: Colors.green[600],
                  ),
                  SizedBox(width: 8),
                  Text(
                    "Analisa Usaha : "
                        .split(', ')
                        .map((word) => word.capitalize)
                        .join(', '),
                    style: TStyle.bodyText2,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    0.currencyFormatRp,
                    style: TStyle.bodyText2,
                  ),
                ],
              ),
              Divider(
                thickness: 1,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Ketuk untuk detail",
                    style: TStyle.bodyText2,
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 12.0,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
