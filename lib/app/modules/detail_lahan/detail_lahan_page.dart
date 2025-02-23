import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantix_app/app/core/extensions/date_time_ext.dart';
import 'package:plantix_app/app/core/theme/app_color.dart';
import 'package:plantix_app/app/core/theme/typography.dart';
import 'package:plantix_app/app/core/widgets/custom_alert_dialog.dart';
import 'package:plantix_app/app/core/widgets/custom_loading.dart';
import 'package:plantix_app/app/core/widgets/custom_page_header.dart';

import 'detail_lahan_controller.dart';

class DetailLahanPage extends GetView<DetailLahanController> {
  const DetailLahanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton:
          GetBuilder<DetailLahanController>(builder: (controller) {
        return Visibility(
          visible: controller.plant == null,
          child: FloatingActionButton.extended(
            backgroundColor: AppColors.primary,
            icon: const Icon(Icons.add_circle_outline_rounded),
            label: const Text('Tambah Tanaman'),
            onPressed: () {
              controller.showAddPlantBottomSheet();
            },
          ),
        );
      }),
      body: Obx(() {
        return Stack(
          children: [
            PageHeader(
              title: 'Detail Lahan',
              height: MediaQuery.of(context).size.height * 0.17,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.09),
                Expanded(
                    child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Card(
                        elevation: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 10,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Data Lahan",
                                    style: TStyle.head4,
                                  ),
                                  Spacer(),
                                  // InkWell(
                                  //   onTap: () {
                                  //     controller.editLahan(controller.field.id);
                                  //   },
                                  //   customBorder: CircleBorder(),
                                  //   child: Ink(
                                  //     decoration: ShapeDecoration(
                                  //       color: AppColors.primary,
                                  //       shape: CircleBorder(),
                                  //     ),
                                  //     child: Padding(
                                  //       padding: EdgeInsets.all(8.0),
                                  //       child: Icon(
                                  //         Icons.edit,
                                  //         size: 14.0,
                                  //         color: Colors.white,
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                  const SizedBox(
                                    width: 6.0,
                                  ),
                                  if (controller.plant == null)
                                    InkWell(
                                      onTap: () {
                                        CustomAlertDialog.customAlertDialog(
                                            yes: controller.isLoading.value
                                                ? "Loading..."
                                                : "Ya",
                                            context: context,
                                            title: "Konfirmasi",
                                            description:
                                                "Apakah anda yakin ingin menghapus lahan ini?",
                                            onPressYes: () {
                                              controller
                                                  .deleteField()
                                                  .then((value) {
                                                Get.back();
                                              });
                                            },
                                            onPressNo: () {
                                              Get.back();
                                            });
                                      },
                                      customBorder: CircleBorder(),
                                      child: Ink(
                                        decoration: ShapeDecoration(
                                          color: Colors.red,
                                          shape: CircleBorder(),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Icon(
                                            Icons.delete_forever,
                                            size: 14.0,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 2.0),
                              buildFieldData(
                                title: "Nama Lahan",
                                description: controller.field.fieldName,
                              ),
                              buildFieldData(
                                title: "Luas Lahan (m²)",
                                description: controller.field.size.toString(),
                              ),
                              buildFieldData(
                                title: "Tanggal Dibuat",
                                description: controller.field.createdAt!
                                    .toFormattedDate(),
                              ),
                              buildFieldData(
                                title: "Alamat",
                                description: controller.field.address,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      Card(
                        elevation: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Data Tanam",
                                    style: TStyle.head4,
                                  ),
                                  if (controller.plant != null)
                                    InkWell(
                                      onTap: () {
                                        CustomAlertDialog.customAlertDialog(
                                            yes: controller.isLoading.value
                                                ? "Loading..."
                                                : "Ya",
                                            context: context,
                                            title: "Konfirmasi",
                                            description:
                                                "Apakah anda yakin ingin menghapus tanaman ini?",
                                            onPressYes: () {
                                              controller
                                                  .deletePlant()
                                                  .then((value) {
                                                Get.back();
                                              });
                                            },
                                            onPressNo: () {
                                              Get.back();
                                            });
                                      },
                                      customBorder: CircleBorder(),
                                      child: Ink(
                                        decoration: ShapeDecoration(
                                          color: Colors.red,
                                          shape: CircleBorder(),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Icon(
                                            Icons.delete_forever,
                                            size: 14.0,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    )
                                ],
                              ),
                              const SizedBox(
                                height: 12.0,
                              ),
                              controller.plant == null
                                  ? emptyCard()
                                  : cardField(
                                      title: controller.plant?.plantName ?? '-',
                                      type: controller.plant?.plantType ?? '-',
                                    ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
              ],
            ),
            if (controller.isLoading.value) LoadingWidgetBG(),
          ],
        );
      }),
    );
  }

  Column buildFieldData({
    required String title,
    required String description,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TStyle.bodyText2.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 2.0,
        ),
        Text(
          description,
          style: TStyle.bodyText2,
        ),
      ],
    );
  }

  Card cardField({
    required String title,
    required String type,
  }) {
    return Card(
      clipBehavior: Clip.hardEdge,
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "$title ($type)",
              style: TStyle.head5,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(
                  Icons.calendar_month_sharp,
                  size: 20,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "Tgl. Tanam : ${controller.plant?.createdAt?.toFormattedDate()}",
                    style: TStyle.bodyText2,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(
                  Icons.calendar_month_sharp,
                  size: 20,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "Tgl. Panen : ${controller.plant?.createdAt?.add(Duration(days: 100)).toFormattedDate()}",
                    style: TStyle.bodyText2,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(
                  Icons.space_dashboard_sharp,
                  size: 20,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "Jml. Panen : -",
                    style: TStyle.bodyText2,
                  ),
                ),
              ],
            ),
            Divider(
              thickness: 1,
            ),
          ],
        ),
      ),
    );
  }

  Card emptyCard() {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Text(
            "Anda belum memiliki data tanam !",
            style: TStyle.head5.copyWith(
              color: Colors.grey[700],
            ),
          ),
        ),
      ),
    );
  }
}
