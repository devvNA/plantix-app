import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantix_app/app/core/extensions/currency_ext.dart';
import 'package:plantix_app/app/core/theme/app_color.dart';
import 'package:plantix_app/app/core/theme/typography.dart';
import 'package:plantix_app/app/core/widgets/custom_loading.dart';
import 'package:plantix_app/app/modules/my_store/my_store_controller.dart';
import 'package:plantix_app/app/modules/my_store/new_ui.dart';
import 'package:plantix_app/app/routes/buat_toko_routes.dart';
import 'package:plantix_app/app/routes/my_products_routes.dart';

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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStoreDetails(),
                  const SizedBox(height: 20),
                  _buildSaldoSection(),
                  const SizedBox(height: 20),
                  _buildSalesStatus(),
                  const SizedBox(height: 20),
                  _buildProductListSection(),
                  const SizedBox(height: 15.0),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DashboardPage()),
                      );
                    },
                    child: const Text("Save"),
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
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 45,
              backgroundImage:
                  controller.store?.storeImageUrl.isNotEmpty ?? false
                      ? NetworkImage(controller.store?.storeImageUrl ?? "")
                      : null,
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    controller.store?.storeName ?? "",
                    style: TStyle.head4.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    controller.store?.address ?? "",
                    style: TStyle.bodyText2.copyWith(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSaldoSection() {
    return Card(
      color: Color(0xFF2F7C57),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            const Icon(Icons.account_balance_wallet,
                color: Colors.white, size: 30),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Saldo Produk Terjual",
                  style: TStyle.bodyText1.copyWith(color: Colors.white70),
                ),
                const SizedBox(height: 6),
                Text(
                  controller.saldo.value.currencyFormatRp,
                  style: TStyle.head4.copyWith(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSalesStatus() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Status Penjualan", style: TStyle.head4),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatusCard(
                    "Proses",
                    controller.processingSales.toString(),
                    Colors.orange,
                    Icons.work),
                _buildStatusCard(
                    "Selesai",
                    controller.completedSales.toString(),
                    Colors.green,
                    Icons.check_circle),
                _buildStatusCard(
                    "Dibatalkan",
                    controller.canceledSales.toString(),
                    Colors.red,
                    Icons.cancel),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard(
      String status, String count, Color color, IconData icon) {
    return Column(
      children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: color.withOpacity(0.1),
          child: Icon(
            icon,
            color: color,
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          count,
          style: TStyle.head5.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          status,
          style: TStyle.bodyText3.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildProductListSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Daftar Produk (${controller.productCount})",
          style: TStyle.head4.copyWith(fontWeight: FontWeight.bold),
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
}
