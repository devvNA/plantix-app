import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantix_app/app/core/extensions/currency_ext.dart';
import 'package:plantix_app/app/core/theme/app_color.dart';
import 'package:plantix_app/app/core/theme/typography.dart';
import 'package:plantix_app/app/core/widgets/custom_loading.dart';
import 'package:plantix_app/app/modules/detail_product/widgets/bottom_sheet_cart.dart';

import 'detail_product_controller.dart';

class DetailProductPage extends GetView<DetailProductController> {
  const DetailProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              title: Text(controller.product.name ?? ''),
              expandedHeight: MediaQuery.sizeOf(context).height * 0.45,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: PageView.builder(
                  itemCount: controller.product.images?.length ?? 0,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Get.dialog(
                          Dialog(
                            insetPadding: EdgeInsets.zero,
                            child: Stack(
                              children: [
                                InteractiveViewer(
                                  child: Image.network(
                                    controller.product.images![index],
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: CircleAvatar(
                                    backgroundColor: Colors.black54,
                                    child: IconButton(
                                      icon: Icon(Icons.close,
                                          color: Colors.white),
                                      onPressed: () => Get.back(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      child: Image.network(
                        controller.product.images![index],
                        filterQuality: FilterQuality.low,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: LoadingWidget(size: 22),
                          );
                        },
                        errorBuilder: (BuildContext context, Object exception,
                            StackTrace? stackTrace) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.error, color: Colors.red),
                                const SizedBox(height: 4),
                                const Text(
                                  "Gagal memuat gambar",
                                  style: TStyle.bodyText5,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
              leading: Container(
                  margin: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: BackButton(
                    color: Colors.black,
                  )),
              actions: [
                Obx(() {
                  return CircleAvatar(
                    backgroundColor: Colors.white,
                    child: IconButton(
                      icon: Icon(
                        controller.isFavorite.value
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: controller.isFavorite.value
                            ? Colors.red
                            : Colors.black,
                      ),
                      onPressed: () => controller.toggleFavorite(),
                    ),
                  );
                }),
                SizedBox(width: 12),
              ],
            ),

            // Konten detail produk
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller.product.name ?? '',
                          style: TStyle.head4,
                        ),
                        SizedBox(height: 8),
                        Text(
                          (controller.product.price ?? 0).currencyFormatRp,
                          style:
                              TStyle.head3.copyWith(color: AppColors.primary),
                        ),
                        // Rating dan ulasan
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Row(
                              children: List.generate(5, (index) {
                                return Icon(
                                  Icons.star,
                                  color: index < 4 ? Colors.amber : Colors.grey,
                                  size: 16,
                                );
                              }),
                            ),
                            SizedBox(width: 8),
                            Text('(${controller.product.id} Ulasan)'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 8,
                    color: Colors.grey[100],
                  ),
                  ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                        "https://res.cloudinary.com/dotz74j1p/raw/upload/v1716044962/tje4vyigverxlotuhvpb.png",
                      ),
                    ),
                    title: Text(
                      controller.product.storeName ?? '',
                      style: TStyle.head5,
                    ),
                    subtitle: Text(
                      controller.product.storeAddress ?? '',
                      style: TStyle.bodyText3,
                    ),
                  ),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Stok", style: TStyle.bodyText3.copyWith()),
                          const SizedBox(height: 4.0),
                          Text("Kategori", style: TStyle.bodyText3.copyWith()),
                        ],
                      ),
                      const SizedBox(width: 12.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(":", style: TStyle.bodyText3.copyWith()),
                          const SizedBox(
                            height: 4.0,
                          ),
                          Text(":", style: TStyle.bodyText3.copyWith()),
                        ],
                      ),
                      const SizedBox(width: 8.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(controller.product.stock.toString(),
                              style: TStyle.bodyText3.copyWith(
                                fontWeight: FontWeight.bold,
                              )),
                          const SizedBox(
                            height: 4.0,
                          ),
                          Text(controller.product.category ?? '',
                              style: TStyle.bodyText3.copyWith(
                                fontWeight: FontWeight.bold,
                              )),
                        ],
                      ),
                    ],
                  ).paddingOnly(left: 16, bottom: 16),
                  Container(
                    height: 8,
                    color: Colors.grey[100],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Deskripsi Produk',
                          style: TStyle.head4,
                        ),
                        SizedBox(height: 8),
                        Text(
                          controller.product.description ??
                              " Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                          style: TStyle.bodyText2,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // Tombol beli
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () {
              Get.bottomSheet(
                Obx(() {
                  return BottomSheetCart(
                    quantity: controller.quantity.value,
                    onPressed: () => controller.addProductToCart(),
                    onIncrease: () => controller.quantity.value++,
                    onDecrease: () => controller.quantity.value--,
                  );
                }),
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                backgroundColor: Colors.white,
              );
              if (Get.isBottomSheetOpen!) {
                controller.quantity.value = 1;
              } else {}
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Tambah ke Keranjang',
              style: TStyle.head5.copyWith(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
