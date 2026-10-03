/// Thực thể bóc tách phí booking từ BE (Domain layer — không phụ thuộc Flutter)
class BookingFee {
  const BookingFee({
    required this.description,
    required this.feeType,
    required this.value,
  });

  final String description;

  /// Loại phí: BOOKING_FEE, DEPOSIT, HOLD_CAR, TOTAL_AMOUNT
  final String feeType;
  final double value;
}

/// Kết quả tổng hợp bảng phí từ API /vehicles/booking
class BookingFeeBreakdown {
  const BookingFeeBreakdown({
    required this.fees,
    this.bookingFee = 0.0,
    this.deposit = 0.0,
    this.holdCar = 0.0,
    this.totalAmount = 0.0,
  });

  final List<BookingFee> fees;

  /// Phí thuê xe (BOOKING_FEE)
  final double bookingFee;

  /// Tiền cọc xe (DEPOSIT)
  final double deposit;

  /// Phí giữ chỗ (HOLD_CAR)
  final double holdCar;

  /// Tổng thanh toán (TOTAL_AMOUNT)
  final double totalAmount;

  /// Số tiền thanh toán khi nhận xe = Tổng - Giữ chỗ
  double get remainingAtStation =>
      totalAmount > holdCar ? (totalAmount - holdCar) : 0.0;

  /// Tiền cọc sau khi trừ giữ chỗ
  double get depositAfterHold => deposit > holdCar ? (deposit - holdCar) : 0.0;

  factory BookingFeeBreakdown.fromFees(List<BookingFee> fees) {
    double booking = 0;
    double dep = 0;
    double hold = 0;
    double total = 0;
    for (final f in fees) {
      switch (f.feeType) {
        case 'BOOKING_FEE':
          booking = f.value;
        case 'DEPOSIT':
          dep = f.value;
        case 'HOLD_CAR':
          hold = f.value;
        case 'TOTAL_AMOUNT':
          total = f.value;
      }
    }
    return BookingFeeBreakdown(
      fees: fees,
      bookingFee: booking,
      deposit: dep,
      holdCar: hold,
      totalAmount: total,
    );
  }
}
