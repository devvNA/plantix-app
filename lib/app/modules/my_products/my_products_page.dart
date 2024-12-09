import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:plantix_app/app/core/theme/app_color.dart';
import 'package:plantix_app/app/core/theme/typography.dart';
import 'package:plantix_app/app/core/widgets/custom_loading.dart';
import 'package:plantix_app/app/modules/my_products/widgets/products_sell_items.dart';
import 'package:plantix_app/app/routes/add_product_routes.dart';
import 'package:plantix_app/main.dart';

import 'my_products_controller.dart';

class MyProductsPage extends GetView<MyProductsController> {
  const MyProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primary,
        title: const Text(
          'Produk Saya',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              log(myStore.currentStore!.id.toString());
            },
            icon: const Icon(
              Icons.search,
              color: Colors.transparent,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add_business_rounded),
        label: const Text('Tambah Produk'),
        onPressed: () => Get.toNamed(AddProductRoutes.addProduct),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const LoadingWidgetBG();
        } else if (controller.listMyProducts.isEmpty) {
          return Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                "assets/images/icon/my_product_empty.svg",
                width: 200,
              ),
              const SizedBox(height: 8.0),
              Text('Belum ada produk',
                  style: TStyle.bodyText1.copyWith(color: Colors.grey)),
            ],
          ));
        } else {
          return RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () async => controller.onRefresh(),
            child: Stack(
              children: [
                GridView.builder(
                  padding: const EdgeInsets.all(12.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 9 / 12,
                    crossAxisCount: 2,
                    mainAxisSpacing: 6,
                    crossAxisSpacing: 6,
                  ),
                  itemCount: controller.listMyProducts.length,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    final product = controller.listMyProducts[index];
                    return ProductSellItems(
                      onTap: () {
                        Get.toNamed(AddProductRoutes.addProduct,
                            arguments: product);
                      },
                      product: product,
                    );
                  },
                ),
                if (controller.isLoading.value) const LoadingWidgetBG(),
              ],
            ),
          );
        }
      }),
    );
  }
}
