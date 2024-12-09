// ignore_for_file: must_be_immutable, unrelated_type_equality_checks
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantix_app/app/core/extensions/currency_ext.dart';
import 'package:plantix_app/app/core/theme/typography.dart';
import 'package:plantix_app/app/data/models/histori_transaksi_model.dart';
import 'package:plantix_app/app/modules/detail_history/detail_history_controller.dart';

class DetailHistoryPage extends GetView<DetailHistoryController> {
  const DetailHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('History Pemesanan Produk'),
        ),
        body: ListView(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          children: [
            _buildOrderDetails(context),
            SizedBox(height: 8),
            _buildOrderItems(),
            SizedBox(height: 8),
            _buildPaymentAttachmentWidget(),
            SizedBox(height: 8),
            _buildEvidenceWidget(),
          ],
        ));
  }

  Visibility _buildEvidenceWidget() {
    return Visibility(
      visible: controller.historiData?.status == "Selesai",
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bukti Diterima:',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Obx(() {
                if (controller.imageFile.isNotEmpty ||
                    controller.historiData?.urlBukti != null) {
                  return Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: controller.imageFile.isEmpty
                            ? Image.network(
                                "https://mediakonsumen.com/files/2022/01/IMG-20220115-WA0000-1.jpg",
                                // controller.historiData!.urlBukti!,
                                height: 180,

                                fit: BoxFit.cover,
                                loadingBuilder: (BuildContext context,
                                    Widget child,
                                    ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  }
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value:
                                          loadingProgress.expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                    ),
                                  );
                                },
                                errorBuilder: (BuildContext context,
                                    Object exception, StackTrace? stackTrace) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(Icons.error,
                                              color: Colors.red),
                                          const SizedBox(height: 4.0),
                                          const Text(
                                            "Gagal memuat gambar",
                                            style: TextStyle(
                                              fontSize: 8.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              )
                            : Image.network(
                                "https://res.cloudinary.com/dotz74j1p/image/upload/v1715660683/no-image.jpg",
                                height: 180,
                                fit: BoxFit.cover,
                              ),
                        // : Image.file(
                        //     File(controller.imageFile.value![0].path),
                        //     height: 180,

                        //     fit: BoxFit.cover,
                        //   ),
                      ),
                    ],
                  );
                } else {
                  return Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.image, size: 50, color: Colors.grey[400]),
                  );
                }
              }),
              const SizedBox(height: 8.0),
              Visibility(
                visible: controller.historiData?.status != "Dibatalkan" &&
                    controller.historiData?.status != "Selesai",
                child: ElevatedButton(
                  onPressed: () async {
                    // await controller.pickImage();
                    // await controller.uploadBukti();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 4.0),
                    child: Text(
                      controller.imageFile.isNotEmpty
                          ? 'Unggah Bukti Pembayaran'
                          : 'Unggah Bukti Pembayaran',
                      style: const TextStyle(
                        fontSize: 12.0,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderDetails(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('ID Pesanan', "TRS-${controller.historiData?.id}",
                isBold: true),
            _buildDetailRow(
                'Tanggal', controller.historiData?.tanggal.toString() ?? ''),
            _buildDetailRow('Total Pembayaran',
                controller.historiData?.total.currencyFormatRp ?? ''),
            _buildDetailRow(
                'Jenis Pembayaran', controller.historiData?.tipePayment ?? ''),
            _buildDetailRow('Total Barang',
                '${controller.historiData?.detail.length} Barang'),
            // _buildDetailRow('Alamat', controller.outlet!.alamat, maxLines: 2),
            _buildDetailRow('Alamat', "JL ABCD", maxLines: 2),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value,
      {bool isBold = false, int maxLines = 1}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
              maxLines: maxLines,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItems() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pesanan:',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...controller.historiData?.detail
                    .map((item) => _buildOrderItem(item)) ??
                [],
          ],
        ),
      ),
    );
  }

  Widget _buildOrderItem(DetailTransaksi item) {
    final hargaSatuan = item.harga;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Text(
                item.productName.substring(0, 1),
                style: TextStyle(fontSize: 12),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName,
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.bold),
                ),
                Text(
                  "${CurrencyFormat.convertToIdr(hargaSatuan)} x ${item.quantity}",
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          Text(
            CurrencyFormat.convertToIdr(hargaSatuan * item.quantity),
            style: TStyle.bodyText2,
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentAttachmentWidget() {
    return Visibility(
      visible: controller.historiData?.status != "Dibatalkan" &&
          controller.historiData?.tipePayment == "Transfer Bank",
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bukti Pembayaran:',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Obx(() {
                if (controller.imageFile.isNotEmpty ||
                    controller.historiData?.urlBukti != null) {
                  // return PageView.builder(
                  //   scrollDirection: Axis.horizontal,
                  //   itemCount: controller.imageFile.length,
                  //   itemBuilder: (context, index) {
                  //     return ClipRRect(
                  //       borderRadius: BorderRadius.circular(12),
                  //       child: Image.file(
                  //         File(controller.imageFile[index].path),
                  //         fit: BoxFit.cover,
                  //       ),
                  //     );
                  //   },
                  // );
                  return SizedBox(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      clipBehavior: Clip.antiAlias,
                      child: Row(
                        children: [
                          ...controller.imageFile.map((file) => Padding(
                                padding: const EdgeInsets.only(right: 12.0),
                                child: Image.file(
                                  File(file.path),
                                  height: 180,
                                  width: 180,
                                  fit: BoxFit.cover,
                                ),
                              )),
                          if (controller.historiData?.urlBukti != null)
                            Padding(
                              padding: const EdgeInsets.only(right: 12.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  controller.historiData?.urlBukti ?? '',
                                  height: 180,
                                  width: 180,
                                  fit: BoxFit.cover,
                                  loadingBuilder: (BuildContext context,
                                      Widget child,
                                      ImageChunkEvent? loadingProgress) {
                                    if (loadingProgress == null) {
                                      return child;
                                    }
                                    return Center(
                                      child: CircularProgressIndicator(
                                        value: loadingProgress
                                                    .expectedTotalBytes !=
                                                null
                                            ? loadingProgress
                                                    .cumulativeBytesLoaded /
                                                loadingProgress
                                                    .expectedTotalBytes!
                                            : null,
                                      ),
                                    );
                                  },
                                  errorBuilder: (BuildContext context,
                                      Object exception,
                                      StackTrace? stackTrace) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Icon(Icons.error,
                                                color: Colors.red),
                                            const SizedBox(height: 4.0),
                                            const Text(
                                              "Gagal memuat gambar",
                                              style: TextStyle(
                                                fontSize: 8.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return Container(
                    height: 200,
                    width: Get.width,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.image, size: 50, color: Colors.grey[400]),
                  );
                }
              }),
              const SizedBox(height: 8.0),
              Visibility(
                visible:
                    controller.historiData?.statusPembayaran == "Belum Bayar",
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () async {
                    await controller.pickImage();
                    // await controller.uploadBukti();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 4.0),
                    child: Text(
                      controller.imageFile.isNotEmpty
                          ? 'Perbarui Bukti Pembayaran'
                          : 'Unggah Bukti Pembayaran',
                      style: const TextStyle(
                        fontSize: 12.0,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
