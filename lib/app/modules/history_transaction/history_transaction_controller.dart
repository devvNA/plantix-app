// ignore_for_file: unnecessary_overrides, avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantix_app/app/data/models/history_transaction_model.dart';
import 'package:plantix_app/app/data/repositories/history_order_repository.dart';

class HistoryTransactionController extends GetxController {
  final selectedIndex = RxInt(0);
  final isLoading = false.obs;

  final listHistoriTransaksi = <HistoryModel>[].obs;
  final listHistoriPending = <HistoryModel>[].obs;
  final listHistoriSuccess = <HistoryModel>[].obs;
  final listHistoriCancel = <HistoryModel>[].obs;

  final tabs = [
    const Text("Proses"),
    const Text("Selesai"),
    const Text("Dibatalkan"),
  ];

  @override
  void onInit() {
    super.onInit();
    getOrders();
  }

  /// Mengambil data pesanan dari repository dan mengkonversinya ke model HistoryModel
  Future<void> getOrders() async {
    isLoading.value = true;
    try {
      final result = await HistoryOrderRepository().getHistoryOrders();
      result.fold(
        (failure) {
          print("Error getting orders: $failure");
        },
        (orders) {
          orders.sort((a, b) {
            // Null safety: jika salah satu createdAt null, letakkan di paling bawah
            if (a.createdAt == null) return 1;
            if (b.createdAt == null) return -1;
            // Urutkan dari yang terbaru (descending)
            return b.createdAt!.compareTo(a.createdAt!);
          });

          listHistoriTransaksi.value = orders;
          _filterOrdersByStatus();
        },
      );
    } catch (e) {
      print("Exception in getOrders: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// Memisahkan data berdasarkan status transaksi
  void _filterOrdersByStatus() {
    // Menggunakan data yang sudah diurutkan dari listHistoriTransaksi
    listHistoriPending.value =
        listHistoriTransaksi
            .where((txn) => txn.orderStatus == 'pending')
            .toList();

    listHistoriSuccess.value =
        listHistoriTransaksi
            .where((txn) => txn.orderStatus == 'success')
            .toList();

    listHistoriCancel.value =
        listHistoriTransaksi
            .where((txn) => txn.orderStatus == 'cancel')
            .toList();
  }

  /// Menyegarkan data histori transaksi
  Future<void> refreshHistoryData() async {
    listHistoriTransaksi.clear();
    listHistoriPending.clear();
    listHistoriSuccess.clear();
    listHistoriCancel.clear();
    await getOrders();
    update();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }
}
