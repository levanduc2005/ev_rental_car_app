import 'package:intl/intl.dart';

abstract final class BookingFormatters {
  static final NumberFormat _currencyFormat = NumberFormat('#,###', 'vi_VN');
  static final DateFormat _dateTimeFormat = DateFormat('HH:mm, dd/MM/yyyy');
  static final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');
  static final DateFormat _timeFormat = DateFormat('HH:mm');

  /// Định dạng tiền tệ VND: 500000 -> 500.000đ
  static String formatCurrency(int amount) {
    return '${_currencyFormat.format(amount)}đ';
  }

  /// Định dạng ngày giờ: 14:00, 17/09/2026
  static String formatDateTime(DateTime dateTime) {
    return _dateTimeFormat.format(dateTime);
  }

  /// Định dạng ngày: 17/09/2026
  static String formatDate(DateTime dateTime) {
    return _dateFormat.format(dateTime);
  }

  /// Định dạng giờ: 14:00
  static String formatTime(DateTime dateTime) {
    return _timeFormat.format(dateTime);
  }

  /// Định dạng khoảng ngày: 17/09/2026 tới 19/09/2026
  static String formatDateRange(DateTime start, DateTime end) {
    return '${formatDate(start)} tới ${formatDate(end)}';
  }
}
