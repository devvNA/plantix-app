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

  // Update mapping hasil panen per hektar (dikonversi ke m²)
  final Map<String, double> yieldPerM2 = {
    'Padi': 0.6, // 6 ton/ha = 0.6 kg/m²
    'Jagung': 0.85, // 8.5 ton/ha = 0.85 kg/m²
    'Kedelai': 0.25, // 2.5 ton/ha = 0.25 kg/m²
    'Kacang Tanah': 0.2, // 2 ton/ha = 0.2 kg/m²
    'Kacang Hijau': 0.15, // 1.5 ton/ha = 0.15 kg/m²
    'Kacang Kedelai': 0.25, // 2.5 ton/ha = 0.25 kg/m²
  };

  // Update kebutuhan pupuk per hektar (dalam kg)
  final Map<String, Map<String, double>> pupukPerHa = {
    'Padi': {
      'Urea': 250,
      'SP36': 100,
      'KCl': 100,
    },
    'Jagung': {
      'Urea': 350,
      'SP36': 200,
      'KCl': 100,
    },
    'Kedelai': {
      'Urea': 75,
      'SP36': 100,
      'KCl': 100,
    },
    // ... tambahkan untuk tanaman lain
  };

  // Riwayat Kalkulasi
  final riwayatKalkulasi = <Kalkulasi>[].obs;

  // Fungsi untuk melakukan kalkulasi
  void submitKalkulasi() {
    if (formKey.currentState!.validate()) {
      double luasLahan = double.parse(luasLahanController.text);
      String jenisTanaman = selectedJenisTanaman.value!;
      int jumlahBenih = int.parse(jumlahBenihController.text);

      // Konversi luas lahan ke hektar untuk perhitungan
      double luasHektar = luasLahan / 10000; // konversi m² ke hektar

      // Perhitungan kebutuhan pupuk (total dari semua jenis)
      if (pupukPerHa.containsKey(jenisTanaman)) {
        kebutuhanPupuk.value =
            pupukPerHa[jenisTanaman]!.values.reduce((a, b) => a + b) *
                luasHektar;
      } else {
        kebutuhanPupuk.value = 0;
      }

      // Kebutuhan air (dalam liter, berdasarkan standar irigasi)
      // Rata-rata kebutuhan air: 8000-10000 m³/ha/musim
      kebutuhanAir.value =
          luasHektar * 9000000; // konversi ke liter (1 m³ = 1000 L)

      // Kebutuhan pestisida (dalam liter)
      // Rata-rata 2-3 liter/ha
      kebutuhanPestisida.value = luasHektar * 2.5;

      // Estimasi biaya
      biayaBenih.value = jumlahBenih * 2500; // Update harga benih
      biayaPupuk.value = kebutuhanPupuk.value * 10000; // Update harga pupuk
      biayaPestisida.value =
          kebutuhanPestisida.value * 75000; // Update harga pestisida
      totalBiaya.value =
          biayaBenih.value + biayaPupuk.value + biayaPestisida.value;

      // Estimasi hasil panen
      if (yieldPerM2.containsKey(jenisTanaman)) {
        estimasiPanen.value = yieldPerM2[jenisTanaman]! * luasLahan;
      }

      // Menyimpan riwayat kalkulasi
      riwayatKalkulasi.add(Kalkulasi(
        luasLahan: luasLahan,
        jenisTanaman: jenisTanaman,
        tanggalTanam: DateTime.parse(tanggalTanamController.text),
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
