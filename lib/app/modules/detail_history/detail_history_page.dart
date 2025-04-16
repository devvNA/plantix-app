// ignore_for_file: must_be_immutable, unrelated_type_equality_checks
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantix_app/app/core/extensions/currency_ext.dart';
import 'package:plantix_app/app/core/theme/app_color.dart';
import 'package:plantix_app/app/data/models/history_transaction_model.dart';
import 'package:plantix_app/app/modules/detail_history/detail_history_controller.dart';

class DetailHistoryPage extends GetView<DetailHistoryController> {
  const DetailHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      centerTitle: true,
      title: const Text(
        'Detail Pesanan',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(color: Colors.white),
          child: _buildOrderStatusIndicator(),
        ),
      ),
    );
  }

  Widget _buildOrderStatusIndicator() {
    final status = controller.historiData?.orderStatus ?? '';
    final statusColor = _getStatusColor(status);

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(_getStatusIcon(status), size: 16, color: statusColor),
              const SizedBox(width: 6),
              Text(
                status,
                style: TextStyle(
                  color: statusColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        Text(
          'ID: TRS-${controller.historiData?.orderId}',
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'cancel':
        return Colors.red;
      case 'success':
        return Colors.green;
      case 'diproses':
        return Colors.blue;
      case 'dikirim':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'dibatalkan':
        return Icons.cancel_outlined;
      case 'selesai':
        return Icons.check_circle_outline;
      case 'diproses':
        return Icons.pending_outlined;
      case 'dikirim':
        return Icons.local_shipping_outlined;
      default:
        return Icons.info_outline;
    }
  }

  Widget _buildBody() {
    return Obx(() {
      // Tampilkan loading jika data belum tersedia
      if (controller.historiData == null) {
        return const Center(child: CircularProgressIndicator());
      }

      return ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: [
          _buildOrderDetails(),
          const SizedBox(height: 16),
          _buildOrderItems(),
          const SizedBox(height: 16),
          if (controller.historiData?.paymentMethod.toLowerCase() ==
              "transfer bank")
            _buildPaymentAttachment(),
          const SizedBox(height: 16),
          if (controller.historiData?.orderStatus.toLowerCase() == "success" ||
              controller.historiData?.orderStatus.toLowerCase() == "selesai")
            _buildDeliveryEvidence(),
        ],
      );
    });
  }

  Widget _buildOrderDetails() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Informasi Pesanan',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildOrderInfoItem(
              icon: Icons.calendar_today_rounded,
              label: 'Tanggal Pemesanan',
              value: _formatDate(controller.historiData?.createdAt),
            ),
            const Divider(height: 24),
            _buildOrderInfoItem(
              icon: Icons.payment_rounded,
              label: 'Metode Pembayaran',
              value: controller.historiData?.paymentMethod ?? '-',
              valueColor: AppColors.primary,
            ),
            const SizedBox(height: 12),
            _buildOrderInfoItem(
              icon: Icons.account_balance_wallet_rounded,
              label: 'Status Pembayaran',
              value: controller.historiData?.orderStatus ?? '-',
              valueColor:
                  controller.historiData?.orderStatus == "success"
                      ? Colors.green
                      : Colors.orange,
            ),
            const Divider(height: 24),
            _buildOrderInfoItem(
              icon: Icons.location_on_rounded,
              label: 'Alamat Pengiriman',
              value: "JL ABCD",
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '-';
    return '${date.day}/${date.month}/${date.year}';
  }

  Widget _buildOrderInfoItem({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 18, color: AppColors.primary),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: valueColor ?? Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOrderItems() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Detail Produk',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  '${controller.historiData?.products.length} Item',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...controller.historiData?.products.map(
                  (item) => _buildOrderItem(item),
                ) ??
                [],
            const Divider(height: 32),
            _buildPriceSummary(),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderItem(ProductData item) {
    final hargaSatuan = item.price;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                item.name.substring(0, 1).toUpperCase(),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '${item.quantity}x ${hargaSatuan.currencyFormatRp}',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            (hargaSatuan * item.quantity).currencyFormatRp,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceSummary() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Subtotal',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
            ),
            Text(
              controller.historiData?.totalPrice.currencyFormatRp ?? '-',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Biaya Pengiriman',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            Text(
              'Gratis',
              style: TextStyle(
                fontSize: 14,
                color: Colors.green,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const Divider(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Total',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              controller.historiData?.totalPrice.currencyFormatRp ?? '-',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPaymentAttachment() {
    final isAwaitingPayment =
        controller.historiData?.orderStatus.toLowerCase() == "pending";

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Bukti Pembayaran',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Obx(() {
              final hasImages =
                  controller.imageFile.isNotEmpty ||
                  (controller.historiData?.paymentProofs.isNotEmpty ?? false);

              if (!hasImages) {
                return _buildEmptyImagePlaceholder();
              }

              return Column(
                children: [
                  SizedBox(
                    height: 200,
                    child:
                        controller.imageFile.isNotEmpty
                            ? _buildUploadedImages()
                            : _buildStoredImage(),
                  ),
                  if (isAwaitingPayment && controller.imageFile.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    _buildUploadFinalButton(),
                  ],
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyImagePlaceholder() {
    final isAwaitingPayment =
        controller.historiData?.orderStatus.toLowerCase() == "pending";

    return Column(
      children: [
        Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.image_outlined, size: 60, color: Colors.grey.shade400),
              const SizedBox(height: 8),
              Text(
                'Belum ada bukti pembayaran',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
              ),
            ],
          ),
        ),
        if (isAwaitingPayment) ...[
          const SizedBox(height: 16),
          _buildUploadButton(),
        ],
      ],
    );
  }

  Widget _buildUploadedImages() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: controller.imageFile.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(right: 12),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.file(
              File(controller.imageFile[index].path),
              width: 200,
              height: 200,
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }

  Widget _buildStoredImage() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: controller.historiData!.paymentProofs.length,
      itemBuilder: (context, index) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            controller.historiData!.paymentProofs[index],
            width: 200,
            height: 200,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  value:
                      loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                  color: AppColors.primary,
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: Colors.red.shade300,
                      size: 40,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Gagal memuat gambar",
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildUploadButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () async {
          await controller.pickImage();
        },
        icon: const Icon(Icons.photo_library),
        label: const Text('Pilih Bukti Pembayaran'),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  Widget _buildUploadFinalButton() {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                controller.pickImage();
              },
              icon: const Icon(Icons.photo_library),
              label: const Text("Pilih Gambar"),
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: AppColors.primary),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: SizedBox(
            width: double.infinity,
            child: Obx(
              () => ElevatedButton.icon(
                onPressed:
                    controller.isLoading.value
                        ? null
                        : () => controller.uploadImageToServer(),
                icon:
                    controller.isLoading.value
                        ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                        : const Icon(Icons.upload_file),
                label: Text(
                  controller.isLoading.value ? "Mengupload..." : "Upload",
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDeliveryEvidence() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Bukti Pengiriman',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Diterima',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                controller.historiData?.paymentProofs.isNotEmpty == true
                    ? controller.historiData!.paymentProofs.first
                    : "https://mediakonsumen.com/files/2022/01/IMG-20220115-WA0000-1.jpg",
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value:
                          loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                      color: AppColors.primary,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: Colors.red.shade300,
                          size: 40,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Gagal memuat gambar",
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: const Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 18),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Pesanan telah diterima pada 15 Maret 2023',
                      style: TextStyle(fontSize: 12, color: Colors.green),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
