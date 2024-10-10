import 'package:get/get.dart';

class AnalisaUsahaTaniController extends GetxController {
  final analisaUsahaList = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadDummyData();
  }

  void loadDummyData() {
    analisaUsahaList.value = [
      {
        'namaLahan': 'Lahan Contoh',
        'jenisTanaman': 'Padi',
        'tanggalTanam': '27-09-2024',
        'tanggalPanen': '15-01-2025',
        'jumlahPanen': 50.0,
        'pendapatanBersih': 5000000.0,
        'pengeluaran': 500000.0,
      },
      // {
      //   'namaLahan': 'Kebun Jagung Timur',
      //   'jenisTanaman': 'Jagung',
      //   'tanggalTanam': '15-10-2024',
      //   'tanggalPanen': '20-02-2025',
      //   'jumlahPanen': 70.0,
      //   'pendapatanBersih': 500000.0,
      //   'pengeluaran': 300000.0,
      // },
    ];
  }
}
