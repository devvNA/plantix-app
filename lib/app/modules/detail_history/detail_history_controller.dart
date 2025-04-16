// ignore_for_file: unnecessary_overrides

import 'dart:developer';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plantix_app/app/core/services/upload_image_service.dart.dart';
import 'package:plantix_app/app/core/widgets/custom_snackbar.dart';
import 'package:plantix_app/app/data/models/history_transaction_model.dart';
import 'package:plantix_app/app/data/repositories/history_order_repository.dart';
import 'package:plantix_app/app/modules/history_transaction/history_transaction_controller.dart';

class DetailHistoryController extends GetxController {
  final isLoading = false.obs;

  /// Model data transaksi yang sedang ditampilkan
  final Rx<HistoryModel?> _historiData = Rx<HistoryModel?>(null);
  HistoryModel? get historiData => _historiData.value;

  final imageUrls = <String>[].obs;
  final imageFile = <XFile>[].obs;
  final _historyOrderRepository = HistoryOrderRepository();

  /// Service untuk menghandle operasi upload image
  final _uploadService = UploadImageService();

  @override
  void onInit() {
    super.onInit();
    // Validasi data transaksi
    final validData = SafeDetailHistoryService.validateHistoryData(
      Get.arguments,
    );
    if (validData != null) {
      _historiData.value = validData;
    } else {
      // Kembali ke halaman sebelumnya jika data tidak valid
      Get.back();
    }
  }

  /// Metode untuk memilih gambar dari galeri
  Future<void> pickImage() async {
    try {
      isLoading.value = true;
      final pickedFiles = await _uploadService.pickMultipleImages(
        maxResolution: 800,
        quality: 80,
      );

      if (pickedFiles.isNotEmpty) {
        imageFile.value = pickedFiles;
      }
    } catch (e) {
      log("Error picking images: ${e.toString()}");
      snackbarError(message: "Gagal memilih gambar: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  /// Metode untuk mengunggah gambar yang telah dipilih ke server
  Future<void> uploadImageToServer() async {
    if (imageFile.isEmpty) {
      snackbarError(message: "Pilih gambar terlebih dahulu");
      return;
    }

    try {
      isLoading.value = true;

      final result = await _uploadService.uploadMultipleFiles(
        files: imageFile,
        bucketName: "stores",
        folderPath: "payment_proofs",
      );

      result.fold(
        (error) {
          log("Error uploading images: $error");
          snackbarError(message: "Gagal mengunggah gambar: $error");
        },
        (urls) async {
          if (urls.isNotEmpty) {
            // Simpan URL yang sudah diurutkan berdasarkan waktu terbaru
            imageUrls.value = urls;

            // Upload bukti pembayaran ke database
            await _uploadPaymentProofsToDatabase();
          }
        },
      );
    } catch (e) {
      log("Exception in uploadImageToServer: $e");
      snackbarError(message: "Gagal mengunggah gambar: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// Metode untuk menyimpan bukti pembayaran ke database
  Future<void> _uploadPaymentProofsToDatabase() async {
    if (historiData == null) return;

    final result = await _historyOrderRepository.uploadPaymentProofs(
      orderId: historiData!.orderId,
      paymentProof: imageUrls,
    );

    result.fold(
      (error) {
        log("Error uploading payment proofs to database: $error");
        snackbarError(message: "Gagal menyimpan bukti pembayaran: $error");
      },
      (success) async {
        log("Payment proof uploaded successfully");

        // Update data transaksi di model lokal
        final updatedHistoriData = historiData!.copyWith(
          paymentProofs: imageUrls.toList(),
        );
        _historiData.value = updatedHistoriData;

        // Refresh data di halaman histori transaksi jika ada
        _refreshHistoryTransactionList();

        // Tampilkan pesan sukses
        snackbarSuccess(message: "Berhasil mengunggah bukti pembayaran");
      },
    );
  }

  /// Refresh data di halaman histori transaksi
  void _refreshHistoryTransactionList() {
    try {
      // Cek apakah HistoryTransactionController sudah di-instantiate
      if (Get.isRegistered<HistoryTransactionController>()) {
        final historyController = Get.find<HistoryTransactionController>();
        historyController.refreshHistoryData();
      }
    } catch (e) {
      log("Error refreshing history transaction list: $e");
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}

/// Service yang menangani validasi data untuk detail history
class SafeDetailHistoryService {
  /// Validasi data history yang diterima dari argumen
  /// Mengembalikan null jika data tidak valid
  static HistoryModel? validateHistoryData(dynamic arguments) {
    // Validasi apakah argumen adalah HistoryModel
    if (arguments is HistoryModel) {
      return arguments;
    }

    // Jika bukan, tampilkan pesan error dan kembali null
    Get.snackbar(
      'Error',
      'Data transaksi tidak valid',
      snackPosition: SnackPosition.BOTTOM,
    );
    return null;
  }

  /// Validasi status pembelian
  static bool isCompletedOrder(String? status) {
    return status?.toLowerCase() == 'success' ||
        status?.toLowerCase() == 'selesai';
  }

  /// Validasi metode pembayaran
  static bool isBankTransfer(String? method) {
    return method?.toLowerCase() == 'transfer bank';
  }
}
