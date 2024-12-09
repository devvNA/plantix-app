import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:plantix_app/app/core/theme/app_color.dart';
import 'package:plantix_app/app/core/theme/typography.dart';
import 'package:plantix_app/app/core/widgets/custom_loading.dart';
import 'package:plantix_app/app/modules/sales/widgets/custom_appbar.dart';
import 'package:plantix_app/app/modules/sales/widgets/products_card.dart';
import 'package:plantix_app/app/routes/detail_product_routes.dart';

import 'sales_controller.dart';

class SalesPage extends GetView<SalesController> {
  const SalesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Toko'),
      body: Obx(() {
        return controller.isLoading
            ? const Center(child: LoadingWidget())
            : controller.products.isEmpty
                ? const Center(child: Text('Belum ada produk'))
                : RefreshIndicator(
                    color: AppColors.primary,
                    onRefresh: () async {
                      controller.refreshProducts();
                    },
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(18.0),
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Semua Produk',
                            style: TStyle.head4,
                          ),
                          const SizedBox(
                            height: 8.0,
                          ),
                          GridView.builder(
                            padding: EdgeInsets.zero,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              childAspectRatio: 1.0,
                              crossAxisCount: 2,
                              mainAxisSpacing: 6,
                              crossAxisSpacing: 6,
                            ),
                            itemCount: controller.products.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (BuildContext context, int index) {
                              return ProductMarketCards(
                                onTap: () {
                                  Get.toNamed(DetailProductRoutes.detailProduct,
                                      arguments: controller.products[index]);
                                },
                                product: controller.products[index],
                              )
                                  .animate()
                                  .fadeIn(
                                    duration: 500.ms,
                                  )
                                  .move(
                                    duration: (index * 100).ms,
                                  );
                            },
                          )
                        ],
                      ),
                    ),
                  );
      }),
    );
  }
}
