class AnalisaUsahaTani {
  String namaLahan;
  String jenisTanaman;
  String tanggalTanam;
  String tanggalPanen;
  double jumlahPanen;
  double pendapatanBersih;
  double pengeluaran;

  AnalisaUsahaTani({
    required this.namaLahan,
    required this.jenisTanaman,
    required this.tanggalTanam,
    required this.tanggalPanen,
    required this.jumlahPanen,
    required this.pendapatanBersih,
    required this.pengeluaran,
  });

  factory AnalisaUsahaTani.fromMap(Map<String, dynamic> map) {
    return AnalisaUsahaTani(
      namaLahan: map['namaLahan'],
      jenisTanaman: map['jenisTanaman'],
      tanggalTanam: map['tanggalTanam'],
      tanggalPanen: map['tanggalPanen'],
      jumlahPanen: map['jumlahPanen'],
      pendapatanBersih: map['pendapatanBersih'],
      pengeluaran: map['pengeluaran'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'namaLahan': namaLahan,
      'jenisTanaman': jenisTanaman,
      'tanggalTanam': tanggalTanam,
      'tanggalPanen': tanggalPanen,
      'jumlahPanen': jumlahPanen,
      'pendapatanBersih': pendapatanBersih,
      'pengeluaran': pengeluaran,
    };
  }
}
