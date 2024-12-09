import 'package:intl/intl.dart';

extension NumCurrencyExt on num {
  String get currencyFormatRp => NumberFormat.currency(
        locale: 'id',
        symbol: 'Rp ',
        decimalDigits: 0,
      ).format(this);
}

extension StringCurrencyExt on String {
  String get currencyFormatRp => NumberFormat.currency(
        locale: 'id',
        symbol: 'Rp ',
        decimalDigits: 0,
      ).format(num.parse(this));
}

class CurrencyFormat {
  static String convertToIdr(dynamic number, {int? decimalDigit}) {
    NumberFormat currencyFormatter = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp',
      decimalDigits: decimalDigit ?? 0,
    );
    return currencyFormatter.format(number);
  }
}
