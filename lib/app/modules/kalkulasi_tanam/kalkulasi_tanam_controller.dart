import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantix_app/app/core/widgets/custom_snackbar.dart';
import 'package:plantix_app/app/data/models/calculation_model.dart';

class KalkulasiTanamController extends GetxController {
  // Form Key
  final formKey = GlobalKey<FormState>();

  // Variabel untuk menyimpan hasil kalkulasi
  final kebutuhanPupuk = 0.0.obs;
  final kebutuhanAir = 0.0.obs;
  final kebutuhanPestisida = 0.0.obs;
  final biayaBenih = 0.0.obs;
  final biayaPupuk = 0.0.obs;
  final biayaPestisida = 0.0.obs;
  final totalBiaya = 0.0.obs;
  final estimasiPanen = 0.0.obs; // Tambahan: Estimasi Hasil Panen

  // TextEditingControllers untuk input form
  final luasLahanController = TextEditingController();
  final tanggalTanamController = TextEditingController();
  final jumlahBenihController = TextEditingController();

  // Dropdown untuk jenis tanaman
  final selectedJenisTanaman = Rxn<String>();
  final jenisTanamanList = <String>[
    'Padi',
    'Jagung',
    'Kedelai',
    'Kacang Tanah',
    'Kacang Hijau',
    'Kacang Kedelai',
    // Tambahkan jenis tanaman lainnya sesuai kebutuhan
  ].obs;

  // Mapping estimasi hasil panen per m² berdasarkan jenis tanaman
  final Map<String, double> yieldPerM2 = {
    'Padi': 5.0, // kg/m²
    'Jagung': 4.0,
    'Kedelai': 3.0,
    'Kacang Tanah': 3.5,
    'Kacang Hijau': 3.0,
    'Kacang Kedelai': 3.5,
    // Tambahkan jenis tanaman lainnya sesuai kebutuhan
  };

  // Riwayat Kalkulasi
  final riwayatKalkulasi = <Kalkulasi>[].obs;


  // Fungsi untuk melakukan kalkulasi
  void submitKalkulasi() {
    if (formKey.currentState!.validate()) {
      double luasLahan = double.parse(luasLahanController.text);
      String jenisTanaman = selectedJenisTanaman.value!;
      int jumlahBenih = int.parse(jumlahBenihController.text);

      // Perhitungan kebutuhan material
      kebutuhanPupuk.value = luasLahan * 10; // kg
      kebutuhanAir.value = luasLahan * 100; // liter
      kebutuhanPestisida.value = luasLahan * 2; // liter

      // Estimasi biaya
      biayaBenih.value = jumlahBenih * 500; // contoh harga per benih
      biayaPupuk.value = kebutuhanPupuk.value * 2000; // harga per kg pupuk
      biayaPestisida.value =
          kebutuhanPestisida.value * 15000; // harga per liter pestisida
      totalBiaya.value =
          biayaBenih.value + biayaPupuk.value + biayaPestisida.value;

      // Estimasi Hasil Panen
      if (yieldPerM2.containsKey(jenisTanaman)) {
        estimasiPanen.value = yieldPerM2[jenisTanaman]! * luasLahan;
      } else {
        estimasiPanen.value = 0.0;
        Get.snackbar(
            'Error', 'Estimasi panen untuk jenis tanaman ini belum tersedia.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.redAccent,
            colorText: Colors.white);
      }

      // Menyimpan riwayat kalkulasi
      riwayatKalkulasi.add(Kalkulasi(
        luasLahan: luasLahan,
        jenisTanaman: jenisTanaman,
        tanggalTanam: tanggalTanamController.text,
        jumlahBenih: jumlahBenih,
        kebutuhanPupuk: kebutuhanPupuk.value,
        kebutuhanAir: kebutuhanAir.value,
        kebutuhanPestisida: kebutuhanPestisida.value,
        biayaBenih: biayaBenih.value,
        biayaPupuk: biayaPupuk.value,
        biayaPestisida: biayaPestisida.value,
        totalBiaya: totalBiaya.value,
        estimasiPanen: estimasiPanen.value, // Tambahan: Estimasi Panen
      ));

      // Menampilkan snackbar sukses
      snackbarSuccess(
        message: "Sukses",
        body: "Kalkulasi berhasil dilakukan",
      );
      // Get.snackbar('Sukses', 'Kalkulasi berhasil dilakukan',
      //     snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  void onClose() {
    luasLahanController.dispose();
    tanggalTanamController.dispose();
    jumlahBenihController.dispose();
    super.onClose();
  }
}
