class FeeItemEntity {
  const FeeItemEntity({
    required this.description,
    required this.feeType,
    required this.value,
  });

  final String description;
  final String feeType;
  final double value;
}

class BookingFeeEntity {
  const BookingFeeEntity({
    required this.bookingFee,
    required this.depositFee,
    required this.holdCarFee,
    required this.totalAmount,
    this.items = const [],
  });

  /// Phí thuê xe thực tế theo số giờ
  final double bookingFee;

  /// Tiền cọc tài sản thế chấp xe (sẽ thanh toán khi nhận xe)
  final double depositFee;

  /// Tiền giữ chỗ thanh toán ngay (thường là 500.000đ)
  final double holdCarFee;

  /// Tổng tiền thuê + cọc
  final double totalAmount;

  /// Danh sách chi tiết các khoản phí trả về từ API
  final List<FeeItemEntity> items;

  /// Số tiền cần thanh toán khi nhận xe = (bookingFee + depositFee) - holdCarFee
  double get paymentUponPickup => (bookingFee + depositFee) - holdCarFee > 0
      ? (bookingFee + depositFee) - holdCarFee
      : 0;

  // Tiện ích chuyển đổi kiểu int cho UI
  int get bookingCost => bookingFee.toInt();
  int get collateralFee => depositFee.toInt();
  int get holdDepositFee => holdCarFee.toInt();
  int get totalCost => totalAmount.toInt();
}
