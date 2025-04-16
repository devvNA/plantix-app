import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  final estimasiPanen = 0.0.obs;
  final durasi = 0.obs; // Durasi tanam sampai panen (hari)

  // TextEditingControllers untuk input form
  final luasLahanController = TextEditingController();
  final tanggalTanamController = TextEditingController();
  final jumlahBenihController = TextEditingController();

  // Dropdown untuk jenis tanaman
  final selectedJenisTanaman = Rxn<String>();
  final jenisTanamanList =
      <String>[
        'Padi',
        'Jagung',
        'Kedelai',
        'Cabai',
        'Tomat',
        'Bawang Merah',
        'Kentang',
        'Kacang Tanah',
        'Kacang Hijau',
        'Ubi Kayu',
        'Ubi Jalar',
      ].obs;

  // Data hasil panen per hektar berdasarkan Kementan dan BPS (2022)
  // Nilai dalam ton/ha, dikonversi ke kg/m²
  final Map<String, double> yieldPerM2 = {
    'Padi': 0.52, // 5.2 ton/ha = 0.52 kg/m²
    'Jagung': 0.58, // 5.8 ton/ha = 0.58 kg/m²
    'Kedelai': 0.16, // 1.6 ton/ha = 0.16 kg/m²
    'Cabai': 0.85, // 8.5 ton/ha = 0.85 kg/m²
    'Tomat': 2.40, // 24 ton/ha = 2.4 kg/m²
    'Bawang Merah': 1.05, // 10.5 ton/ha = 1.05 kg/m²
    'Kentang': 1.85, // 18.5 ton/ha = 1.85 kg/m²
    'Kacang Tanah': 0.13, // 1.3 ton/ha = 0.13 kg/m²
    'Kacang Hijau': 0.12, // 1.2 ton/ha = 0.12 kg/m²
    'Ubi Kayu': 2.30, // 23 ton/ha = 2.3 kg/m²
    'Ubi Jalar': 1.60, // 16 ton/ha = 1.6 kg/m²
  };

  // Durasi tanam sampai panen (dalam hari)
  final Map<String, int> durasiTanam = {
    'Padi': 110, // 3.5-4 bulan
    'Jagung': 95, // 3-3.5 bulan
    'Kedelai': 85, // 2.5-3 bulan
    'Cabai': 120, // 4 bulan
    'Tomat': 85, // 2.5-3 bulan
    'Bawang Merah': 60, // 2 bulan
    'Kentang': 110, // 3.5-4 bulan
    'Kacang Tanah': 95, // 3-3.5 bulan
    'Kacang Hijau': 65, // 2-2.5 bulan
    'Ubi Kayu': 270, // 9 bulan
    'Ubi Jalar': 135, // 4.5 bulan
  };

  // Kebutuhan benih per hektar (kg/ha)
  final Map<String, double> kebutuhanBenihPerHa = {
    'Padi': 25.0, // 25 kg/ha untuk padi
    'Jagung': 20.0, // 20 kg/ha untuk jagung
    'Kedelai': 40.0, // 40 kg/ha untuk kedelai
    'Cabai': 0.5, // 0.5 kg/ha untuk cabai
    'Tomat': 0.3, // 0.3 kg/ha untuk tomat
    'Bawang Merah': 1200.0, // 1200 kg/ha (umbi)
    'Kentang': 2000.0, // 2000 kg/ha (umbi bibit)
    'Kacang Tanah': 100.0, // 100 kg/ha
    'Kacang Hijau': 25.0, // 25 kg/ha
    'Ubi Kayu': 150.0, // 150 kg/ha (stek)
    'Ubi Jalar': 120.0, // 120 kg/ha (stek)
  };

  // Harga benih per kg (Rp)
  final Map<String, int> hargaBenihPerKg = {
    'Padi': 15000,
    'Jagung': 85000,
    'Kedelai': 20000,
    'Cabai': 2000000, // Harga per kg benih cabai
    'Tomat': 2500000, // Harga per kg benih tomat
    'Bawang Merah': 45000, // Harga per kg umbi bibit
    'Kentang': 15000, // Harga per kg umbi bibit
    'Kacang Tanah': 25000,
    'Kacang Hijau': 30000,
    'Ubi Kayu': 5000, // Harga per kg stek
    'Ubi Jalar': 7000, // Harga per kg stek
  };

  // Kebutuhan pupuk per hektar (kg/ha)
  final Map<String, Map<String, double>> kebutuhanPupukPerHa = {
    'Padi': {'Urea': 250.0, 'SP36': 100.0, 'KCl': 100.0, 'NPK': 200.0},
    'Jagung': {'Urea': 300.0, 'SP36': 150.0, 'KCl': 100.0, 'NPK': 300.0},
    'Kedelai': {'Urea': 75.0, 'SP36': 100.0, 'KCl': 100.0, 'NPK': 150.0},
    'Cabai': {'Urea': 200.0, 'SP36': 150.0, 'KCl': 150.0, 'NPK': 300.0},
    'Tomat': {'Urea': 150.0, 'SP36': 200.0, 'KCl': 150.0, 'NPK': 250.0},
    'Bawang Merah': {'Urea': 200.0, 'SP36': 200.0, 'KCl': 200.0, 'NPK': 300.0},
    'Kentang': {'Urea': 200.0, 'SP36': 250.0, 'KCl': 200.0, 'NPK': 350.0},
    'Kacang Tanah': {'Urea': 50.0, 'SP36': 100.0, 'KCl': 50.0, 'NPK': 200.0},
    'Kacang Hijau': {'Urea': 50.0, 'SP36': 75.0, 'KCl': 50.0, 'NPK': 150.0},
    'Ubi Kayu': {'Urea': 100.0, 'SP36': 100.0, 'KCl': 100.0, 'NPK': 200.0},
    'Ubi Jalar': {'Urea': 100.0, 'SP36': 150.0, 'KCl': 100.0, 'NPK': 200.0},
  };

  // Harga pupuk per kg (Rp)
  final Map<String, int> hargaPupukPerKg = {
    'Urea': 2000,
    'SP36': 2500,
    'KCl': 3500,
    'NPK': 3000,
  };

  // Kebutuhan pestisida (liter/ha/musim)
  final Map<String, double> kebutuhanPestisidaPerHa = {
    'Padi': 5.0,
    'Jagung': 3.0,
    'Kedelai': 4.0,
    'Cabai': 7.0,
    'Tomat': 6.0,
    'Bawang Merah': 8.0,
    'Kentang': 7.0,
    'Kacang Tanah': 3.0,
    'Kacang Hijau': 2.5,
    'Ubi Kayu': 2.0,
    'Ubi Jalar': 2.5,
  };

  // Harga pestisida per liter (Rp)
  final int hargaPestisidaPerLiter = 120000;

  // Kebutuhan air (m³/ha/musim)
  final Map<String, double> kebutuhanAirPerHa = {
    'Padi': 8000.0, // 8000 m³/ha untuk padi sawah
    'Jagung': 4500.0,
    'Kedelai': 4000.0,
    'Cabai': 5000.0,
    'Tomat': 5500.0,
    'Bawang Merah': 6000.0,
    'Kentang': 5000.0,
    'Kacang Tanah': 3500.0,
    'Kacang Hijau': 3000.0,
    'Ubi Kayu': 3000.0,
    'Ubi Jalar': 3500.0,
  };

  // Riwayat Kalkulasi
  final riwayatKalkulasi = <Kalkulasi>[].obs;

  // Fungsi untuk melakukan kalkulasi
  void submitKalkulasi() {
    if (formKey.currentState!.validate()) {
      // Ambil nilai dari form
      final double luasLahan = double.parse(luasLahanController.text);
      final String jenisTanaman = selectedJenisTanaman.value!;
      final int jumlahBenih = int.parse(jumlahBenihController.text);

      // Konversi luas lahan ke hektar untuk perhitungan
      final double luasHektar = luasLahan / 10000; // konversi m² ke hektar

      // Perhitungan kebutuhan benih berdasarkan standar per hektar
      double kebutuhanBenih = 0;
      if (kebutuhanBenihPerHa.containsKey(jenisTanaman)) {
        kebutuhanBenih = kebutuhanBenihPerHa[jenisTanaman]! * luasHektar;
      }

      // Perhitungan biaya benih
      int hargaBenih = 0;
      if (hargaBenihPerKg.containsKey(jenisTanaman)) {
        hargaBenih = hargaBenihPerKg[jenisTanaman]!;
      }
      biayaBenih.value = jumlahBenih * hargaBenih.toDouble();

      // Perhitungan kebutuhan pupuk total (kg)
      if (kebutuhanPupukPerHa.containsKey(jenisTanaman)) {
        kebutuhanPupuk.value =
            kebutuhanPupukPerHa[jenisTanaman]!.values.reduce((a, b) => a + b) *
            luasHektar;
      } else {
        kebutuhanPupuk.value = 0;
      }

      // Perhitungan biaya pupuk
      double biayaPupukTotal = 0;
      if (kebutuhanPupukPerHa.containsKey(jenisTanaman)) {
        for (var entry in kebutuhanPupukPerHa[jenisTanaman]!.entries) {
          final String pupukType = entry.key;
          final double jumlahPupuk = entry.value * luasHektar;
          final int hargaPupuk = hargaPupukPerKg[pupukType] ?? 0;
          biayaPupukTotal += jumlahPupuk * hargaPupuk;
        }
      }
      biayaPupuk.value = biayaPupukTotal;

      // Perhitungan kebutuhan pestisida (liter)
      if (kebutuhanPestisidaPerHa.containsKey(jenisTanaman)) {
        kebutuhanPestisida.value =
            kebutuhanPestisidaPerHa[jenisTanaman]! * luasHektar;
      } else {
        kebutuhanPestisida.value = 0;
      }

      // Perhitungan biaya pestisida
      biayaPestisida.value = kebutuhanPestisida.value * hargaPestisidaPerLiter;

      // Perhitungan kebutuhan air (liter)
      if (kebutuhanAirPerHa.containsKey(jenisTanaman)) {
        // Konversi m³ ke liter (1 m³ = 1000 liter)
        kebutuhanAir.value =
            kebutuhanAirPerHa[jenisTanaman]! * luasHektar * 1000;
      } else {
        kebutuhanAir.value = 0;
      }

      // Perhitungan total biaya produksi
      totalBiaya.value =
          biayaBenih.value + biayaPupuk.value + biayaPestisida.value;

      // Perhitungan estimasi hasil panen (kg)
      if (yieldPerM2.containsKey(jenisTanaman)) {
        estimasiPanen.value = yieldPerM2[jenisTanaman]! * luasLahan;
      } else {
        estimasiPanen.value = 0;
      }

      // Perhitungan durasi tanam sampai panen
      if (durasiTanam.containsKey(jenisTanaman)) {
        durasi.value = durasiTanam[jenisTanaman]!;
      } else {
        durasi.value = 0;
      }

      // Menyimpan riwayat kalkulasi
      riwayatKalkulasi.add(
        Kalkulasi(
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
          estimasiPanen: estimasiPanen.value,
          durasi: durasi.value,
        ),
      );
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
