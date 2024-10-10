import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantix_app/app/data/models/analisa_usaha_model.dart';
import 'package:plantix_app/app/data/models/spend_model.dart';
import 'package:plantix_app/app/modules/detail_analisa_usaha/widgets/bottom_sheet_spend.dart';
import 'package:plantix_app/app/modules/detail_analisa_usaha/widgets/dialog_harvest_widget.dart';

class DetailAnalisaUsahaController extends GetxController {
  AnalisaUsahaTani? analisaUsana = Get.arguments;
  TextEditingController spendController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController hargaPanenController = TextEditingController();
  final pengeluaranList = <Pengeluaran>[].obs;
  final jumlahPanen = "".obs;
  final hargaPanen = 0.0.obs;

  bool get isEditMode => analisaUsana != null;

  @override
  void onInit() {
    super.onInit();
    // Inisialisasi data dummy
    initDummyData();
    if (isEditMode) {
      jumlahPanen.value = analisaUsana!.jumlahPanen.toString();
    }
  }

  // Fungsi untuk menginisialisasi data dummy
  void initDummyData() {
    pengeluaranList.addAll([
      Pengeluaran("Benih", 90000),
      Pengeluaran("Pupuk", 120000),
      Pengeluaran("Pestisida", 250000),
      Pengeluaran("Lain-lain", 40000),
    ]);
  }

  // Fungsi untuk menambah pengeluaran
  tambahPengeluaran(String kategori, double jumlah) {
    pengeluaranList.add(Pengeluaran(kategori, jumlah));
    Get.back();
    spendController.clear();
    descriptionController.clear();
  }

  // Fungsi untuk menghitung total biaya (pengeluaran)
  double hitungTotalBiaya() {
    return pengeluaranList.fold(0, (sum, item) => sum + item.jumlah);
  }

  // Fungsi untuk mengatur hasil panen
  setPanen(double harga, double jumlah) {
    jumlahPanen.value = jumlah.toString();
    hargaPanen.value = harga;
    Get.back();
  }

  // Fungsi untuk menghitung pendapatan kotor
  double hitungPendapatanKotor() {
    return double.parse(jumlahPanen.value) * hargaPanen.value;
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
    if (Get.isDialogOpen!) {}
  }

  @override
  void onClose() {
    super.onClose();
  }
}
