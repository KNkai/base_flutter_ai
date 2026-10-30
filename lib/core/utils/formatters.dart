import 'package:intl/intl.dart';

class Formatters {
  Formatters._();

  static String formatDate(DateTime? date, [String pattern = 'MMM dd, yyyy']) {
    if (date == null) return '';
    return DateFormat(pattern).format(date);
  }

  static String formatCurrency(
    num? amount, {
    String symbol = '\$',
    int decimalDigits = 2,
  }) {
    if (amount == null) return '$symbol 0.00';
    final formatter = NumberFormat.currency(
      symbol: symbol,
      decimalDigits: decimalDigits,
    );
    return formatter.format(amount);
  }

  static String truncate(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }
}
