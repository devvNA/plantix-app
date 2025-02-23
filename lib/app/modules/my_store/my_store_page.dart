import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantix_app/app/core/theme/app_color.dart';
import 'package:plantix_app/app/core/theme/typography.dart';
import 'package:plantix_app/app/core/widgets/custom_loading.dart';
import 'package:plantix_app/app/modules/my_store/my_store_controller.dart';
import 'package:plantix_app/app/routes/buat_toko_routes.dart';
import 'package:plantix_app/app/routes/my_products_routes.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MyStorePage extends GetView<MyStoreController> {
  const MyStorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Toko Saya"),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Get.toNamed(BuatTokoRoutes.buatToko);
            },
          ),
        ],
      ),
      body: Obx(() {
        return Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                spacing: 16,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStoreDetails(),
                  Text(
                    'Ringkasan Penjualan',
                    style: TStyle.head3,
                  ),
                  Wrap(
                    spacing: 8.0, // Spasi horizontal
                    runSpacing: 8.0, // Spasi vertikal
                    children: [
                      SizedBox(
                        width: (MediaQuery.of(context).size.width - 40) / 2,
                        child: _buildSummaryCard('Total Penjualan',
                            'Rp ${controller.totalSales.value}', Colors.green),
                      ),
                      SizedBox(
                        width: (MediaQuery.of(context).size.width - 40) / 2,
                        child: _buildSummaryCard('Total Produk',
                            '${controller.totalProducts.value}', Colors.blue),
                      ),
                      SizedBox(
                        width: (MediaQuery.of(context).size.width - 40) / 2,
                        child: _buildSummaryCard('Total Pesanan',
                            '${controller.totalOrders.value}', Colors.orange),
                      ),
                      SizedBox(
                        width: (MediaQuery.of(context).size.width - 40) / 2,
                        child: _buildSummaryCard('Dibatalkan',
                            '${controller.totalCancelled.value}', Colors.red),
                      ),
                    ],
                  ),
                  _buildProductListSection(),
                  Text(
                    'Grafik Penjualan',
                    style: TStyle.head3,
                  ),
                  Builder(
                    builder: (context) {
                      final List<Map> chartData = [
                        {
                          "year": 2018,
                          "sales": 40,
                        },
                        {
                          "year": 2019,
                          "sales": 90,
                        },
                        {
                          "year": 2020,
                          "sales": 30,
                        },
                        {
                          "year": 2021,
                          "sales": 80,
                        },
                        {
                          "year": 2022,
                          "sales": 90,
                        }
                      ];

                      return Container(
                        color: Theme.of(context).cardColor,
                        padding: const EdgeInsets.all(0.0),
                        child: SfCartesianChart(
                          series: <CartesianSeries>[
                            // Renders line chart
                            LineSeries<Map, int>(
                              color: AppColors.primary,
                              dataSource: chartData,
                              xValueMapper: (Map data, _) => data["year"],
                              yValueMapper: (Map data, _) => data["sales"],
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            if (controller.isLoading.value) const LoadingWidgetBG(),
          ],
        );
      }),
    );
  }

  Widget _buildStoreDetails() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary.withValues(alpha: 0.8), AppColors.primary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.3),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        spreadRadius: 2,
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 45,
                    backgroundColor: Colors.grey[200],
                    backgroundImage: controller
                                .store?.storeImageUrl.isNotEmpty ??
                            false
                        ? NetworkImage(controller.store?.storeImageUrl ?? "")
                        : null,
                    child: controller.store?.storeImageUrl.isEmpty ?? true
                        ? const Icon(Icons.store, size: 40, color: Colors.grey)
                        : null,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        controller.store?.storeName ?? "Nama Toko",
                        style: TStyle.head4.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            size: 16,
                            color: Colors.white70,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              controller.store?.address ?? "Alamat toko",
                              style: TStyle.bodyText2.copyWith(
                                color: Colors.white70,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductListSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Daftar Produk (${controller.productCount})",
          style: TStyle.head3,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  Get.toNamed(MyProductsRoutes.myProducts,
                      arguments: controller.store?.id);
                },
                icon: const Icon(Icons.list),
                label: const Text("Lihat Semua Produk"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSummaryCard(String title, String value, Color color) {
    return Card(
      elevation: 4,
      color: color.withValues(alpha: 0.6),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TStyle.head5,
            ),
            SizedBox(height: 8),
            Text(
              value,
              style: TStyle.head3,
            ),
          ],
        ),
      ),
    );
  }
}
