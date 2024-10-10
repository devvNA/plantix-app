import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantix_app/app/core/theme/app_color.dart';
import 'package:plantix_app/app/core/theme/typography.dart';
import 'package:plantix_app/app/core/widgets/custom_page_header.dart';
import 'package:plantix_app/app/data/models/field_model.dart';
import 'package:plantix_app/app/routes/detail_lahan_routes.dart';

import 'lahan_tanam_controller.dart';

class LahanTanamPage extends GetView<LahanTanamController> {
  const LahanTanamPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          NotificationListener<ScrollNotification>(
            onNotification: (scrollNotification) {
              if (scrollNotification is ScrollUpdateNotification) {
                controller
                    .updateScrollStatus(scrollNotification.metrics.pixels > 0);
              }
              return false;
            },
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  elevation: 3,
                  backgroundColor: AppColors.primary,
                  leading: Obx(() => controller.isScrolled.value
                      ? GestureDetector(
                          onTap: () => Get.back(),
                          child: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                        )
                      : const SizedBox.shrink()),
                  title: Obx(() => controller.isScrolled.value
                      ? Text(
                          'Daftar Lahan Tanam',
                          style: TStyle.head3.copyWith(color: Colors.white),
                        )
                      : const SizedBox.shrink()),
                  expandedHeight: 90.0,
                  floating: false,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    collapseMode: CollapseMode.parallax,
                    background: Container(
                      color: AppColors.background,
                      child: PageHeader(
                        title: 'Daftar Lahan Tanam',
                        height: MediaQuery.of(context).size.height * 0.17,
                      ),
                    ),
                  ),
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(height: 40),
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: Obx(() => SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final lahan = controller.lahanList[index];
                            return cardField(lahan, context, index);
                          },
                          childCount: controller.lahanList.length,
                        ),
                      )),
                ),
              ],
            ),
          ),
          Obx(() {
            if (controller.lahanList.isEmpty) {
              return const Positioned(
                top: 70,
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
                        Icon(
                          Icons.error,
                          size: 24.0,
                          color: AppColors.error,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
            if (controller.isScrolled.value == false &&
                controller.lahanList.isNotEmpty) {
              return Positioned(
                top: 75,
                left: 16,
                right: 16,
                child: Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Lahan Tanam',
                          style: TStyle.head4,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Total Lahan: ${controller.lahanList.length}',
                          style: TStyle.bodyText2,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FloatingActionButton(
          elevation: 3,
          isExtended: true,
          onPressed: () => controller.getProvince().then((value) {
            controller.showAddLandBottomSheet();
          }),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Card cardField(Lahan lahan, BuildContext context, int index) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          Get.toNamed(DetailLahanRoutes.detailLahan, arguments: lahan);
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                lahan.fieldName,
                style: TStyle.head5,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    size: 20,
                    color: Colors.redAccent,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      lahan.fieldAddress
                          .split(', ')
                          .map((word) => word.capitalize)
                          .join(', '),
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
                    color: Colors.green,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "${lahan.fieldArea} m²",
                      style: TStyle.bodyText2,
                    ),
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
                  const SizedBox(
                    width: 10.0,
                  ),
                  const Icon(
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
