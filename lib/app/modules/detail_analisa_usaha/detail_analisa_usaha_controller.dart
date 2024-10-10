import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantix_app/app/data/models/analisa_usaha_model.dart';
import 'package:plantix_app/app/data/models/spend_model.dart';
import 'package:plantix_app/app/modules/detail_analisa_usaha/widgets/bottom_sheet_spend.dart';
import 'package:plantix_app/app/modules/detail_analisa_usaha/widgets/dialog_harvest_widget.dart';

class DetailAnalisaUsahaController extends GetxController {
  AnalisaUsahaTani analisaUsana = Get.arguments;
  TextEditingController spendController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  // TextEditingController jmlPanenController = TextEditingController();
  // TextEditingController hargaPanenController = TextEditingController();

  /// List untuk menyimpan data pengeluaran
  final pengeluaranList = <Pengeluaran>[].obs;
  final jmlPanen = 0.0.obs;
  final hargaPanen = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    // Inisialisasi data dummy
    initDummyData();
  }

  // Fungsi untuk menginisialisasi data dummy
  void initDummyData() {
    pengeluaranList.addAll([
      Pengeluaran("Benih", 250000),
      Pengeluaran("Pupuk", 500000),
      Pengeluaran("Pestisida", 300000),
      Pengeluaran("Lain-lain", 150000),
    ]);
  }

  // Fungsi untuk menambah pengeluaran
  void tambahPengeluaran(String kategori, double jumlah) {
    pengeluaranList.add(Pengeluaran(kategori, jumlah));
    Get.back();
    update();
    spendController.clear();
    descriptionController.clear();
  }

  // Fungsi untuk menghitung total biaya (pengeluaran)
  double hitungTotalBiaya() {
    return pengeluaranList.fold(0, (sum, item) => sum + item.jumlah);
  }

  // Fungsi untuk mengatur hasil panen
  void setPanen(double jumlah, double harga) {
    jmlPanen.value = 0.0;
    hargaPanen.value = 0.0;
    jmlPanen.value = jumlah;
    hargaPanen.value = harga;
    Get.back();
  }

  // Fungsi untuk mengatur harga panen
  void setHargaPanen(double harga) {
    hargaPanen.value = harga;
    update();
  }

  // Fungsi untuk menghitung pendapatan kotor
  double hitungPendapatanKotor() {
    return jmlPanen.value * hargaPanen.value;
  }

  // Fungsi untuk menghitung pendapatan bersih
  double hitungPendapatanBersih() {
    return hitungPendapatanKotor() - hitungTotalBiaya();
  }

  showAddSpendBottomSheet() {
    Get.bottomSheet(AddSpendBottomSheet());
    if (Get.isDialogOpen!) {
      spendController.clear();
      descriptionController.clear();
    }
  }

  showDialogHarvest() {
    Get.dialog(DialogHarvestWidget());
  }

  // ... kode lainnya tetap sama
}
