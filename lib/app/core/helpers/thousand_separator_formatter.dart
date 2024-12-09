import 'package:flutter/services.dart';

class ThousandsSeparatorInputFormatter extends TextInputFormatter {
  static String getUnformattedValue(String text) {
    // Menghapus semua titik dari string
    return text.replaceAll('.', '');
  }

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Hapus semua titik dari input
    final text = newValue.text.replaceAll('.', '');

    // Format angka dengan pemisah ribuan
    final newText = _formatNumber(text);

    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }

  String _formatNumber(String s) {
    return s.replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.');
  }
}
