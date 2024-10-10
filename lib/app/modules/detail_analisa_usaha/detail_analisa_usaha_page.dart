import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantix_app/app/core/extensions/date_time_ext.dart';
import 'package:plantix_app/app/core/extensions/string_ext.dart';
import 'package:plantix_app/app/core/theme/app_color.dart';
import 'package:plantix_app/app/core/theme/typography.dart';
import 'package:plantix_app/app/core/widgets/custom_page_header.dart';

import 'detail_analisa_usaha_controller.dart';

class DetailAnalisaUsahaPage extends GetView<DetailAnalisaUsahaController> {
  const DetailAnalisaUsahaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        tooltip: "Input Pengeluaran",
        backgroundColor: AppColors.primary,
        onPressed: () => controller.showAddSpendBottomSheet(),
        child: Icon(Icons.add),
      ),
      body: Stack(
        children: [
          PageHeader(
            title: 'Detail Analisa Usaha',
            height: MediaQuery.of(context).size.height * 0.17,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.09),
              Expanded(
                  child: SingleChildScrollView(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Card(
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          children: [
                            cardField(
                              title: controller.analisaUsana!.namaLahan,
                              type: controller.analisaUsana!.jenisTanaman,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 6.0),
                    Card(
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Pengeluaran",
                              style: TStyle.head5,
                            ),
                            const SizedBox(height: 12),
                            Obx(() => Column(
                                  children: controller.pengeluaranList
                                      .map((pengeluaran) => spendProperty(
                                          title: "${pengeluaran.kategori} :",
                                          value: pengeluaran.jumlah.toString()))
                                      .toList(),
                                )),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 6.0),
                    Card(
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Obx(() {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 12),
                              analyzeProperty(
                                  title: "Total Biaya",
                                  value: controller
                                      .hitungTotalBiaya()
                                      .toString()
                                      .currencyFormatRp),
                              analyzeProperty(
                                title: "Hasil Panen",
                                value: controller.jumlahPanen != 0
                                    ? "${controller.jumlahPanen} Kg"
                                    : "0 Kg",
                              ),
                              analyzeProperty(
                                  title: "Harga Panen",
                                  value: controller.hargaPanen != 0
                                      ? "${controller.hargaPanen.value.toString().currencyFormatRp}"
                                      : "0".currencyFormatRp),
                              analyzeProperty(
                                title: "Pendapatan Kotor",
                                value: controller
                                    .hitungPendapatanKotor()
                                    .toString()
                                    .currencyFormatRp,
                              ),
                              analyzeProperty(
                                title: "Pendapatan Bersih",
                                value: controller
                                    .hitungPendapatanBersih()
                                    .toString()
                                    .currencyFormatRp,
                                color: controller.hitungPendapatanBersih() < 0
                                    ? Colors.red
                                    : AppColors.primary,
                              ),
                            ],
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              )),
            ],
          ),
        ],
      ),
    );
  }

  Widget spendProperty({required String title, required String value}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(
            Icons.remove,
            size: 12,
          ),
          const SizedBox(width: 8),
          Text(
            '${title.capitalize} ${value.currencyFormatRp}',
            style: TStyle.bodyText2,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget analyzeProperty({
    required String title,
    required String value,
    Color? color,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TStyle.bodyText2.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: TStyle.bodyText2.copyWith(
              color: color ?? AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget cardField({
    required String title,
    required String type,
  }) {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title + " ($type)",
            style: TStyle.head5,
          ),
          const SizedBox(height: 12),
          fieldProperty(
              title: 'Tgl. Tanam :',
              value: DateTime.now().toFormattedDatetime(),
              icon: Icons.calendar_month_sharp),
          const SizedBox(height: 4),
          fieldProperty(
              title: 'Tgl. Panen :',
              value: controller.analisaUsana!.tanggalPanen,
              icon: Icons.calendar_month_sharp),
          const SizedBox(height: 4),
          fieldProperty(
            title: 'Jml. Panen :',
            value: controller.jumlahPanen != 0
                ? "${controller.jumlahPanen} Kg"
                : "0 Kg",
            icon: Icons.space_dashboard_sharp,
            isPanen: true,
          ),
          const SizedBox(
            height: 6.0,
          ),
          // Text(
          //   "*Masukkan jumlah panen untuk menghitung pendapatan",
          //   style: TStyle.bodyText4,
          // ),
          // const SizedBox(
          //   height: 6.0,
          // ),
          // fieldProperty(
          //     title: 'Pendapatan :', value: "Rp. 0", icon: Icons.money_sharp),
          // const SizedBox(
          //   height: 6.0,
          // ),
          // fieldProperty(
          //     title: 'Pengeluaran :', value: "Rp. 0", icon: Icons.money_sharp),
          // const SizedBox(
          //   height: 6.0,
          // ),
        ],
      );
    });
  }

  Row fieldProperty({
    required IconData icon,
    required String title,
    required String value,
    bool? isPanen,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 15,
          color: AppColors.primary,
        ),
        const SizedBox(width: 8),
        Text(
          "$title $value",
          style: TStyle.bodyText2,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(width: 8),
        if (isPanen == true)
          SizedBox(
            height: 20,
            width: 90,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              onPressed: () => controller.showDialogHarvest(),
              child: Text(
                "input",
                style: TStyle.bodyText3.copyWith(color: Colors.white),
              ),
            ),
          ),
      ],
    );
  }
}
