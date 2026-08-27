import 'package:intl/intl.dart';

abstract final class AppFormat {
  static final _currency = NumberFormat.currency(
    locale: 'en_NG',
    symbol: '₦',
    decimalDigits: 2,
  );

  static final _mediumDate = DateFormat('MMM d, y');

  static String currency(double amount) => _currency.format(amount);

  static String mediumDate(DateTime date) => _mediumDate.format(date);
}
