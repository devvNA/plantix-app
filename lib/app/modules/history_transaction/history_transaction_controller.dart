import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantix_app/app/data/models/histori_transaksi_model.dart';

class HistoryTransactionController extends GetxController {
  RxInt selectedIndex = RxInt(0);
  final isLoading = false.obs;
  final listHistoriTransaksi = <HistoriTransaksi>[].obs;
  final listHistoriProses = <HistoriTransaksi>[].obs;
  final listHistoriSelesai = <HistoriTransaksi>[].obs;
  final listHistoriDibatalkan = <HistoriTransaksi>[].obs;

  final tabs = [
    const Text("Proses"),
    const Text("Selesai"),
    const Text("Dibatalkan"),
  ].obs;

  @override
  void onInit() {
    super.onInit();
    _populateDummyData();
  }

  void _populateDummyData() {
    listHistoriTransaksi.value = [
      HistoriTransaksi(
        id: 'TXN001',
        tanggal: DateTime.now().subtract(Duration(days: 1)),
        tipePayment: 'COD',
        statusPembayaran: 'Belum Bayar',
        status: 'Proses',
        total: 150000.0,
        detail: [
          DetailTransaksi(
            productId: 101,
            productName: 'Tomat Segar',
            quantity: 2,
            harga: 50000.0,
          ),
          DetailTransaksi(
            productId: 102,
            productName: 'Wortel Organik',
            quantity: 1,
            harga: 50000.0,
          ),
        ],
      ),
      HistoriTransaksi(
        id: 'TXN001X435',
        tanggal: DateTime.now().subtract(Duration(days: 1)),
        tipePayment: 'Transfer Bank',
        statusPembayaran: 'Belum Bayar',
        status: 'Proses',
        total: 150000.0,
        detail: [
          DetailTransaksi(
            productId: 101,
            productName: 'Tomat Segar',
            quantity: 2,
            harga: 50000.0,
          ),
          DetailTransaksi(
            productId: 102,
            productName: 'Wortel Organik',
            quantity: 1,
            harga: 50000.0,
          ),
        ],
      ),
      HistoriTransaksi(
        id: 'TXN002',
        tanggal: DateTime.now().subtract(Duration(days: 2)),
        tipePayment: 'Transfer Bank',
        statusPembayaran: 'Lunas',
        urlBukti:
            "https://down-id.img.susercontent.com/file/ec8177b2139f0c48f2c07e2470f22341@resize_w900_nl.webp",
        status: 'Selesai',
        total: 200000.0,
        detail: [
          DetailTransaksi(
            productId: 103,
            productName: 'Cabai Merah',
            quantity: 4,
            harga: 50000.0,
          ),
        ],
      ),
      HistoriTransaksi(
        id: 'TXN003',
        tanggal: DateTime.now().subtract(Duration(days: 3)),
        tipePayment: 'COD',
        statusPembayaran: 'Lunas',
        status: 'Dibatalkan',
        total: 75000.0,
        detail: [
          DetailTransaksi(
            productId: 104,
            productName: 'Kentang',
            quantity: 1,
            harga: 75000.0,
          ),
        ],
      ),
      HistoriTransaksi(
        id: 'TXN004',
        tanggal: DateTime.now().subtract(Duration(days: 4)),
        tipePayment: 'Transfer Bank',
        statusPembayaran: 'Lunas',
        urlBukti:
            "https://down-id.img.susercontent.com/file/ec8177b2139f0c48f2c07e2470f22341@resize_w900_nl.webp",
        status: 'Proses',
        total: 125000.0,
        detail: [
          DetailTransaksi(
            productId: 105,
            productName: 'Jagung Manis',
            quantity: 2,
            harga: 62500.0,
          ),
        ],
      ),
      HistoriTransaksi(
        id: 'TXN005',
        tanggal: DateTime.now().subtract(Duration(days: 5)),
        tipePayment: 'Transfer Bank',
        statusPembayaran: 'Lunas',
        urlBukti:
            "https://down-id.img.susercontent.com/file/ec8177b2139f0c48f2c07e2470f22341@resize_w900_nl.webp",
        status: 'Selesai',
        total: 300000.0,
        detail: [
          DetailTransaksi(
            productId: 106,
            productName: 'Bawang Merah',
            quantity: 3,
            harga: 100000.0,
          ),
        ],
      ),
      HistoriTransaksi(
        id: 'TXN005',
        tanggal: DateTime.now().subtract(Duration(days: 5)),
        tipePayment: 'Transfer Bank',
        statusPembayaran: 'Lunas',
        urlBukti:
            "https://down-id.img.susercontent.com/file/ec8177b2139f0c48f2c07e2470f22341@resize_w900_nl.webp",
        status: 'Selesai',
        total: 300000.0,
        detail: [
          DetailTransaksi(
            productId: 106,
            productName: 'Bawang Merah',
            quantity: 3,
            harga: 100000.0,
          ),
        ],
      ),
    ];

    // Memisahkan data berdasarkan status
    listHistoriProses.value =
        listHistoriTransaksi.where((txn) => txn.status == 'Proses').toList();
    listHistoriSelesai.value =
        listHistoriTransaksi.where((txn) => txn.status == 'Selesai').toList();
    listHistoriDibatalkan.value = listHistoriTransaksi
        .where((txn) => txn.status == 'Dibatalkan')
        .toList();
  }
}
