import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantix_app/app/core/extensions/currency_ext.dart';
import 'package:plantix_app/app/core/extensions/date_time_ext.dart';
import 'package:plantix_app/app/core/theme/app_color.dart';
import 'package:plantix_app/app/core/theme/typography.dart';
import 'package:plantix_app/app/core/widgets/custom_loading.dart';
import 'package:plantix_app/app/core/widgets/custom_page_header.dart';

import 'detail_analisa_usaha_controller.dart';

class DetailAnalisaUsahaPage extends GetView<DetailAnalisaUsahaController> {
  const DetailAnalisaUsahaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Obx(
        () => AnimatedSlide(
          duration: const Duration(milliseconds: 300),
          offset: controller.isVisible.value ? Offset.zero : const Offset(0, 2),
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: controller.isVisible.value ? 1 : 0,
            child: FloatingActionButton(
              tooltip: "Input Pengeluaran",
              backgroundColor: AppColors.primary,
              onPressed: () {
                controller.showAddSpendBottomSheet();
              },
              child: Icon(Icons.add),
            ),
          ),
        ),
      ),
      body: GetBuilder<DetailAnalisaUsahaController>(builder: (controller) {
        return Stack(
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
                  child: RefreshIndicator(
                    color: AppColors.primary,
                    onRefresh: () async {
                      controller.onRefresh();
                    },
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      controller: controller.scrollController,
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          Card(
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: cardField(
                                title: controller.analisaUsana!.fieldName,
                                type: controller.analisaUsana!.plantType,
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
                                  Obx(() {
                                    return controller.pengeluaranList.isEmpty
                                        ? const Center(
                                            child: Text(
                                              "Belum ada data pengeluaran",
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          )
                                        : Column(
                                            children: controller.pengeluaranList
                                                .map((pengeluaran) => spendProperty(
                                                    title:
                                                        "${pengeluaran.spendName} :",
                                                    value: pengeluaran.amount
                                                        .toString(),
                                                    spendId: pengeluaran.id))
                                                .toList(),
                                          );
                                  })
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 6.0),
                          Card(
                            elevation: 3,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 12),
                                  analyzeProperty(
                                    title: "Total Biaya",
                                    value: controller
                                        .hitungTotalBiaya()
                                        .toString()
                                        .currencyFormatRp,
                                  ),
                                  analyzeProperty(
                                    title: "Hasil Panen",
                                    value: controller.jmlPanen != 0
                                        ? "${controller.jmlPanen} Kg"
                                        : "0 Kg",
                                  ),
                                  analyzeProperty(
                                      title: "Harga Panen",
                                      value: controller.hargaPanen != 0
                                          ? controller
                                              .hargaPanen!.currencyFormatRp
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
                                    color:
                                        controller.hitungPendapatanBersih() < 0
                                            ? Colors.red
                                            : AppColors.primary,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (controller.isLoading.value) const LoadingWidgetBG(),
          ],
        );
      }),
    );
  }

  Widget spendProperty({
    required String title,
    required String value,
    required int spendId,
  }) {
    return Padding(
      padding: EdgeInsets.all(4),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.remove_circle_outline,
              size: 16,
              color: AppColors.primary,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              title.capitalize!,
              style: TStyle.bodyText2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            value.currencyFormatRp,
            style: TStyle.bodyText2.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          IconButton(
            constraints: BoxConstraints(),
            splashRadius: 20,
            onPressed: () => controller.deleteSpend(spendId),
            icon: Icon(
              Icons.delete,
              color: AppColors.error,
              size: 20,
            ),
          )
        ],
      ),
    );
  }

  Widget analyzeProperty({
    required String title,
    required String value,
    Color? color,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: (color ?? AppColors.primary).withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: TStyle.bodyText2.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TStyle.bodyText2.copyWith(
                fontWeight: FontWeight.bold,
                color: color ?? AppColors.primary,
              ),
              overflow: TextOverflow.ellipsis,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$title ($type)",
          style: TStyle.head5,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 12),
        fieldProperty(
            title: 'Tgl. Tanam :',
            value: controller.analisaUsana!.plantingDate!.toFormattedDate(),
            icon: Icons.calendar_month_sharp),
        const SizedBox(height: 4),
        fieldProperty(
            title: 'Tgl. Panen :',
            value: controller.analisaUsana!.harvestDate!.toFormattedDate(),
            icon: Icons.calendar_month_sharp),
        const SizedBox(height: 4),
        fieldProperty(
          title: 'Jml. Panen :',
          value: "${controller.jmlPanen.toString()} Kg",
          icon: Icons.space_dashboard_sharp,
          isPanen: true,
        ),
        const SizedBox(
          height: 6.0,
        ),
      ],
    );
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
        Expanded(
          child: Text(
            "$title $value",
            style: TStyle.bodyText2,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
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
