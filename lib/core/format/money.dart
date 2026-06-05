/// Money formatting helpers.
///
/// Amounts are displayed receipt-style: whole numbers, space thousands
/// separators and a trailing hryvnia sign — e.g. `500 ₴`, `1 500 ₴`,
/// `12 450 ₴`.
library;

const String kCurrencySign = '₴';

/// Formats [value] as `1 500 ₴`. Rounds to the nearest whole hryvnia.
String formatMoney(num value) {
  return '${formatAmount(value)} $kCurrencySign';
}

/// Formats [value] as a grouped integer string without the currency sign.
String formatAmount(num value) {
  final rounded = value.round();
  final negative = rounded < 0;
  final digits = rounded.abs().toString();
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) {
      buffer.write(' ');
    }
    buffer.write(digits[i]);
  }
  return '${negative ? '-' : ''}$buffer';
}
