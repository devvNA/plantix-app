class Kalkulasi {
  final double luasLahan;
  final String jenisTanaman;
  final DateTime tanggalTanam;
  final int jumlahBenih;
  final double kebutuhanPupuk;
  final double kebutuhanAir;
  final double kebutuhanPestisida;
  final double biayaBenih;
  final double biayaPupuk;
  final double biayaPestisida;
  final double totalBiaya;
  final double estimasiPanen; // Tambahan: Estimasi Panen

  Kalkulasi({
    required this.luasLahan,
    required this.jenisTanaman,
    required this.tanggalTanam,
    required this.jumlahBenih,
    required this.kebutuhanPupuk,
    required this.kebutuhanAir,
    required this.kebutuhanPestisida,
    required this.biayaBenih,
    required this.biayaPupuk,
    required this.biayaPestisida,
    required this.totalBiaya,
    required this.estimasiPanen, // Tambahan: Estimasi Panen
  });
}
