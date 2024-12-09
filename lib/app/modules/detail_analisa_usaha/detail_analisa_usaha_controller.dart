import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:plantix_app/app/core/extensions/snackbar_ext.dart';
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

  // Tambahkan variabel untuk mengontrol visibility FAB
  final isVisible = true.obs;
  final scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    // Inisialisasi data dummy
    initDummyData();
    // Tambahkan listener untuk scroll
    scrollController.addListener(_scrollListener);
  }

  @override
  void onClose() {
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
    super.onClose();
  }

  // Fungsi untuk mendeteksi scroll
  void _scrollListener() {
    if (scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      if (isVisible.value) {
        isVisible.value = false;
      }
    }

    if (scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      if (!isVisible.value) {
        isVisible.value = true;
      }
    }
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
    Get.context!.showSnackBar('Pengeluaran berhasil ditambahkan');
  }

  // Fungsi untuk menghitung total biaya (pengeluaran)
  double hitungTotalBiaya() {
    return pengeluaranList.fold(0, (sum, item) => sum + item.jumlah);
  }

  // Fungsi untuk mengatur hasil panen
  void setPanen(double jumlah, double harga) {
    jmlPanen.value = jumlah;
    hargaPanen.value = harga;
    Get.back();
    Get.context!.showSnackBar('Data panen berhasil diperbarui');
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

  // Tambahkan getter untuk warna status
  Color get statusColor => hitungPendapatanBersih() < 0
      ? Colors.red
      : hitungPendapatanBersih() == 0
          ? Colors.orange
          : Colors.green;

  // Tambahkan getter untuk status text
  String get statusText => hitungPendapatanBersih() < 0
      ? 'Rugi'
      : hitungPendapatanBersih() == 0
          ? 'BEP'
          : 'Untung';

  // ... kode lainnya tetap sama
}
