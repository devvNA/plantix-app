import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantix_app/app/core/extensions/currency_ext.dart';
import 'package:plantix_app/app/core/extensions/date_time_ext.dart';
import 'package:plantix_app/app/core/theme/app_color.dart';
import 'package:plantix_app/app/core/theme/typography.dart';
import 'package:plantix_app/app/core/widgets/custom_loading.dart';
import 'package:plantix_app/app/core/widgets/custom_page_header.dart';
import 'package:plantix_app/app/data/models/analisa_usaha_model.dart';
import 'package:plantix_app/app/routes/detail_analisa_usaha_routes.dart';

import 'analisa_usaha_tani_controller.dart';

class AnalisaUsahaTaniPage extends GetView<AnalisaUsahaTaniController> {
  const AnalisaUsahaTaniPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        return SafeArea(
          child: Stack(
            children: [
              PageHeader(
                title: 'Analisa Usaha',
                height: MediaQuery.of(context).size.height * 0.13,
              ),
              if (controller.analisaUsahaList.isEmpty)
                const Positioned(
                  top: 75,
                  left: 16,
                  right: 16,
                  child: Card(
                    elevation: 4,
                    margin: EdgeInsets.all(16),
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Anda belum memiliki lahan',
                            style: TStyle.bodyText1,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.error, size: 24.0, color: AppColors.error),
                        ],
                      ),
                    ),
                  ),
                ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.09),
                  Expanded(
                    child: Obx(() {
                      final data = controller.analisaUsahaList;
                      return RefreshIndicator(
                        color: AppColors.primary,
                        onRefresh: controller.onRefresh,
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            children:
                                data
                                    .asMap()
                                    .entries
                                    .map(
                                      (entry) => cardField(
                                        context: context,
                                        index: entry.key,
                                        data: data[entry.key],
                                      ),
                                    )
                                    .toList(),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
              if (controller.isLoading.value) const LoadingWidgetBG(),
            ],
          ),
        );
      }),
    );
  }

  Card cardField({
    required BuildContext context,
    required int index,
    required FarmingProductionAnalysisModel data,
  }) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: InkWell(
        onTap:
            controller.analisaUsahaList[index].plantType == ""
                ? null
                : () {
                  Get.toNamed(
                    DetailAnalisaUsahaRoutes.detailAnalisaUsaha,
                    arguments: data,
                  );
                },
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            spacing: 4,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(child: Text(data.fieldName, style: TStyle.head5)),
                  Chip(
                    padding: EdgeInsets.zero,
                    label: Text(
                      data.plantType == ""
                          ? "Belum ada data tanaman"
                          : data.plantType,
                      style: TStyle.bodyText3.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ).paddingAll(4),
                    backgroundColor:
                        data.plantType == ""
                            ? AppColors.error
                            : AppColors.secondary,
                  ).paddingZero,
                ],
              ),
              const SizedBox(height: 4.0),
              buildInfoRow(
                Icon(Icons.calendar_month, size: 20, color: Colors.green[600]),
                "Tgl. Tanam : ",
                data.plantingDate!.toFormattedDate(),
              ),
              buildInfoRow(
                Icon(Icons.calendar_month, size: 20, color: Colors.green[600]),
                "Tgl. Panen : ",
                data.harvestDate!.toFormattedDate(),
              ),
              buildInfoRow(
                Icon(
                  Icons.shopping_basket_rounded,
                  size: 20,
                  color: Colors.green[600],
                ),
                "Jumlah Panen : ",
                "${data.harvestQuantity.toString()} kg",
              ),
              buildInfoRow(
                Text(
                  "Rp",
                  style: TStyle.bodyText2.copyWith(
                    color: Colors.green[600],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                "Pendapatan Bersih : ",
                (data.netIncome).currencyFormatRp,
              ),
              buildInfoRow(
                Text(
                  "Rp",
                  style: TStyle.bodyText2.copyWith(
                    color: Colors.green[600],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                "Pengeluaran  : ",
                (data.expenses).currencyFormatRp,
              ),
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
        Expanded(
          child: Text(
            label.split(', ').map((word) => word.capitalize).join(', '),
            style: TStyle.bodyText2,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Text(value, style: TStyle.bodyText2),
      ],
    );
  }
}
