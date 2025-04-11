import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:plantix_app/app/core/theme/app_color.dart';
import 'package:plantix_app/app/core/theme/typography.dart';
import 'package:plantix_app/app/core/widgets/custom_loading.dart';
import 'package:plantix_app/app/data/models/shop_response_model.dart';
import 'package:plantix_app/app/modules/shop/widgets/custom_appbar.dart';
import 'package:plantix_app/app/modules/shop/widgets/products_card.dart';
import 'package:plantix_app/app/routes/detail_product_routes.dart';
import 'package:plantix_app/main.dart';

import 'shop_controller.dart';

class ShopPage extends GetView<ShopController> {
  const ShopPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Toko'),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: LoadingWidget());
        }
        return Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Semua Produk', style: TStyle.head4),
              const SizedBox(height: 8.0),
              user.hasStore
                  ? Expanded(child: _buildProductGrid())
                  : Expanded(child: _buildAllProductGrid()),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildProductGrid() {
    return StreamBuilder<List<ShopResponse>>(
      stream: controller.productsStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting &&
            snapshot.data?.isEmpty == true) {
          return const Center(child: LoadingWidget());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Terjadi kesalahan: ${snapshot.error}',
              style: TStyle.bodyText1.copyWith(color: Colors.red),
              textAlign: TextAlign.center,
            ),
          );
        }

        final products = snapshot.data ?? [];

        if (products == []) {
          return Center(
            child: Text(
              'Tidak ada produk tersedia',
              style: TStyle.bodyText1,
              textAlign: TextAlign.center,
            ),
          );
        }

        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () async {
            await controller.refreshProducts();
          },
          child: GridView.builder(
            padding: EdgeInsets.zero,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 1.0,
              crossAxisCount: 2,
              mainAxisSpacing: 6,
              crossAxisSpacing: 6,
            ),
            itemCount: products.length,
            itemBuilder: (BuildContext context, int index) {
              return ProductMarketCards(
                    onTap: () {
                      Get.toNamed(
                        DetailProductRoutes.detailProduct,
                        arguments: products[index],
                      );
                    },
                    product: products[index],
                  )
                  .animate()
                  .fadeIn(duration: 500.ms)
                  .move(duration: (index * 100).ms);
            },
          ),
        );
      },
    );
  }

  Widget _buildAllProductGrid() {
    return StreamBuilder<List<ShopResponse>>(
      stream: controller.allProductsStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting &&
            snapshot.data?.isEmpty == true) {
          return const Center(child: LoadingWidget());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Terjadi kesalahan: ${snapshot.error}',
              style: TStyle.bodyText1.copyWith(color: Colors.red),
              textAlign: TextAlign.center,
            ),
          );
        }

        final products = snapshot.data ?? [];

        if (products == []) {
          return Center(
            child: Text(
              'Tidak ada produk tersedia',
              style: TStyle.bodyText1,
              textAlign: TextAlign.center,
            ),
          );
        }

        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () async {
            await controller.refreshProducts();
          },
          child: GridView.builder(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.zero,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 1.0,
              crossAxisCount: 2,
              mainAxisSpacing: 6,
              crossAxisSpacing: 6,
            ),
            itemCount: products.length,
            itemBuilder: (BuildContext context, int index) {
              return ProductMarketCards(
                    onTap: () {
                      Get.toNamed(
                        DetailProductRoutes.detailProduct,
                        arguments: products[index],
                      );
                    },
                    product: products[index],
                  )
                  .animate()
                  .fadeIn(duration: 500.ms)
                  .move(duration: (index * 100).ms);
            },
          ),
        );
      },
    );
  }
}
