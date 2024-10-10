import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantix_app/app/core/extensions/int_ext.dart';
import 'package:plantix_app/app/core/theme/app_color.dart';
import 'package:plantix_app/app/core/theme/typography.dart';
import 'package:plantix_app/app/core/widgets/custom_page_header.dart';
import 'package:plantix_app/app/data/models/analisa_usaha_model.dart';
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
                child: Obx(() => SingleChildScrollView(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        children: controller.analisaUsahaList
                            .asMap()
                            .entries
                            .map((entry) => cardField(
                                context: context,
                                index: entry.key,
                                data: AnalisaUsahaTani.fromMap(entry.value)))
                            .toList(),
                      ),
                    )),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Card cardField(
      {required BuildContext context,
      required int index,
      required AnalisaUsahaTani data}) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: InkWell(
        onTap: () {
          Get.toNamed(DetailAnalisaUsahaRoutes.detailAnalisaUsaha,
              arguments: data);
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
                      data.namaLahan,
                      style: TStyle.head5,
                    ),
                  ),
                  Chip(
                    padding: EdgeInsets.zero,
                    label: Text(
                      data.jenisTanaman,
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
              buildInfoRow(
                  Icon(Icons.calendar_month,
                      size: 20, color: Colors.green[600]),
                  "Tgl. Tanam : ",
                  data.tanggalTanam),
              buildInfoRow(
                  Icon(Icons.calendar_month,
                      size: 20, color: Colors.green[600]),
                  "Tgl. Panen : ",
                  data.tanggalPanen),
              buildInfoRow(
                  Icon(Icons.shopping_basket_rounded,
                      size: 20, color: Colors.green[600]),
                  "Jumlah Panen : ",
                  data.jumlahPanen.toString()),
              buildInfoRow(
                  Text(
                    "Rp",
                    style: TStyle.bodyText2.copyWith(
                      color: Colors.green[600],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  "Pendapatan Bersih : ",
                  (data.pendapatanBersih).currencyFormatRp),
              buildInfoRow(
                  Text(
                    "Rp",
                    style: TStyle.bodyText2.copyWith(
                      color: Colors.green[600],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  "Pengeluaran  : ",
                  (data.pengeluaran).currencyFormatRp),
              Divider(thickness: 1),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Ketuk untuk detail", style: TStyle.bodyText2),
                  SizedBox(width: 10.0),
                  Icon(Icons.arrow_forward_ios, size: 12.0),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInfoRow(Widget widget, String label, String value) {
    return Row(
      children: [
        widget,
        SizedBox(width: 8),
        Text(
          label.split(', ').map((word) => word.capitalize).join(', '),
          style: TStyle.bodyText2,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        Text(value, style: TStyle.bodyText2),
      ],
    );
  }
}