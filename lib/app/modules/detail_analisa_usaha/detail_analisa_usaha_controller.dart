import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:plantix_app/app/core/extensions/snackbar_ext.dart';
import 'package:plantix_app/app/core/helpers/thousand_separator_formatter.dart';
import 'package:plantix_app/app/data/models/analisa_usaha_model.dart';
import 'package:plantix_app/app/data/models/spend_model.dart';
import 'package:plantix_app/app/data/repositories/analisa_usaha_tani_repository.dart';
import 'package:plantix_app/app/modules/analisa_usaha_tani/analisa_usaha_tani_controller.dart';
import 'package:plantix_app/app/modules/detail_analisa_usaha/widgets/bottom_sheet_spend.dart';
import 'package:plantix_app/app/modules/detail_analisa_usaha/widgets/dialog_harvest_widget.dart';

class DetailAnalisaUsahaController extends GetxController {
  TextEditingController spendController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController jmlPanenController = TextEditingController();
  TextEditingController hargaPanenController = TextEditingController();
  final isLoading = false.obs;
  final analisaUsahaController = Get.find<AnalisaUsahaTaniController>();

  /// List untuk menyimpan data pengeluaran
  // final pengeluaranList = <Pengeluaran>[].obs;
  final pengeluaranList = <SpendModel>[].obs;
  int? jmlPanen = 0;
  int? hargaPanen = 0;

  // Ambil data jika Sudah Punya Produk
  FarmingProductionAnalysisModel? analisaUsana = Get.arguments;
  // bool get isEditMode => analisaUsana != null;

  // Tambahkan variabel untuk mengontrol visibility FAB
  final isVisible = true.obs;
  final scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    // Inisialisasi data dummy
    // initDummyData();
    getSpend();
    // if (isEditMode) {
    //   jmlPanenController.text = analisaUsana!.harvestQuantity.toString();
    //   hargaPanenController.text = analisaUsana!.netIncome.toString();
    // }

    // Tambahkan listener untuk scroll
    // Tambahkan listener untuk scroll
    scrollController.addListener(_scrollListener);
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
    // pengeluaranList.addAll([
    //   Pengeluaran("Benih", 350000),
    //   Pengeluaran("Pupuk Urea", 600000),
    // ]);
  }

  // // Fungsi untuk menambah pengeluaran
  // void tambahPengeluaran(String kategori, int jumlah) {
  //   pengeluaranList.add(Pengeluaran(kategori, jumlah));
  //   Get.back();
  //   spendController.clear();
  //   descriptionController.clear();
  //   update();
  //   Get.context!.showSnackBar('Pengeluaran berhasil ditambahkan');
  // }

  // Fungsi untuk menghitung total biaya (pengeluaran)
  int hitungTotalBiaya() {
    if (pengeluaranList.isEmpty) return 0;
    return pengeluaranList.fold(0, (sum, item) => sum + item.amount);
  }

  // Fungsi untuk mengatur hasil panen
  void setPanen() async {
    final price = ThousandsSeparatorInputFormatter.getUnformattedValue(
        hargaPanenController.text);

    jmlPanen = int.tryParse(jmlPanenController.text);
    hargaPanen = int.tryParse(price);
    Get.back();
    await updateHarvestAnalysis();
    update();
    Get.context!.showCustomSnackBar(
      message: 'Data panen berhasil diperbarui',
      isError: false,
    );
  }

  // Fungsi untuk mengatur harga panen
  void setHargaPanen(int harga) async {
    hargaPanen = harga;
    await updateHarvestAnalysis();
    update();
  }

  // Fungsi untuk menghitung pendapatan kotor
  int hitungPendapatanKotor() {
    if (jmlPanen == null || hargaPanen == null) return 0;
    return jmlPanen! * hargaPanen!;
  }

  // Fungsi untuk menghitung pendapatan bersih
  int hitungPendapatanBersih() {
    final pendapatanKotor = hitungPendapatanKotor();
    final totalBiaya = hitungTotalBiaya();
    return pendapatanKotor - totalBiaya;
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
  Color get statusColor {
    final pendapatanBersih = hitungPendapatanBersih();
    if (pendapatanBersih < 0) return Colors.red;
    if (pendapatanBersih == 0) return Colors.orange;
    return Colors.green;
  }

  // Tambahkan getter untuk status text
  String get statusText {
    final pendapatanBersih = hitungPendapatanBersih();
    if (pendapatanBersih < 0) return 'Rugi';
    if (pendapatanBersih == 0) return 'BEP';
    return 'Untung';
  }

  Future<void> getSpend() async {
    isLoading.value = true;
    final response =
        await AnalisaUsahaTaniRepository().getSpend(analisaUsana!.id);
    response.fold((failure) {
      log(failure.message);
    }, (data) {
      pengeluaranList.value = data;
      update();
    });
    isLoading.value = false;
  }

  Future<void> createSpend() async {
    final price = ThousandsSeparatorInputFormatter.getUnformattedValue(
        spendController.text);

    isLoading.value = true;
    update();
    final response = await AnalisaUsahaTaniRepository().createSpend(
      farmAnalysisId: analisaUsana!.id,
      spendName: descriptionController.text,
      amount: int.parse(price),
    );
    Get.back();

    response.fold((failure) {
      log(failure.message);
    }, (data) async {
      spendController.clear();
      descriptionController.clear();
      await onRefresh();
      Get.context!.showCustomSnackBar(
        message: 'Pengeluaran berhasil ditambahkan',
        isError: false,
      );
    });
    isLoading.value = false;
  }

  Future deleteSpend(int spendId) async {
    final response = await AnalisaUsahaTaniRepository().deleteSpend(spendId);
    if (response) {
      pengeluaranList.value =
          pengeluaranList.where((e) => e.id != spendId).toList();
      await updateHarvestAnalysis();
      Get.context!.showCustomSnackBar(
        message: 'Pengeluaran berhasil dihapus',
        isError: false,
      );
      update();
    }
  }

  Future onRefresh() async {
    pengeluaranList.clear();
    await getSpend();
  }

  Future updateHarvestAnalysis() async {
    isLoading.value = true;
    update();
    await AnalisaUsahaTaniRepository().updateHarvestAnalysis(
      farmAnalysisId: analisaUsana!.id,
      harvestQuantity: int.parse(jmlPanenController.text),
      netIncome: hitungPendapatanBersih(),
      expenses: hitungTotalBiaya(),
    );
    isLoading.value = false;
    await analisaUsahaController.onRefresh();
  }

  @override
  void onClose() async {
    super.onClose();
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
  }

  // ... kode lainnya tetap sama
}
