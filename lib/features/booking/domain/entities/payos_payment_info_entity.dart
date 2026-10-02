/// Thực thể thông tin thanh toán cọc PayOS VietQR
class PayOSPaymentInfoEntity {
  const PayOSPaymentInfoEntity({
    required this.orderCode,
    required this.amount,
    required this.description,
    required this.accountNumber,
    required this.accountName,
    required this.qrCodeUrl,
    this.bankName,
    this.bin,
    this.checkoutUrl,
    this.expiresAt,
  });

  /// Mã đơn đặt cọc thanh toán
  final String orderCode;

  /// Số tiền cọc giữ chỗ
  final double amount;

  /// Cú pháp / Nội dung chuyển khoản
  final String description;

  /// Số tài khoản thụ hưởng do PayOS cấp
  final String accountNumber;

  /// Tên chủ tài khoản thụ hưởng do PayOS cấp
  final String accountName;

  /// Mã BIN ngân hàng (nhận từ PayOS, không hardcode)
  final String? bin;

  /// Tên ngân hàng thụ hưởng
  final String? bankName;

  /// Đường dẫn hình ảnh mã QR VietQR PayOS
  final String qrCodeUrl;

  /// Đường dẫn trang web PayOS (dự phòng)
  final String? checkoutUrl;

  /// Thời điểm hết hạn thanh toán
  final DateTime? expiresAt;

  int get depositFee => amount.toInt();

  PayOSPaymentInfoEntity copyWith({
    String? orderCode,
    double? amount,
    String? description,
    String? accountNumber,
    String? accountName,
    String? bin,
    String? bankName,
    String? qrCodeUrl,
    String? checkoutUrl,
    DateTime? expiresAt,
  }) {
    return PayOSPaymentInfoEntity(
      orderCode: orderCode ?? this.orderCode,
      amount: amount ?? this.amount,
      description: description ?? this.description,
      accountNumber: accountNumber ?? this.accountNumber,
      accountName: accountName ?? this.accountName,
      bin: bin ?? this.bin,
      bankName: bankName ?? this.bankName,
      qrCodeUrl: qrCodeUrl ?? this.qrCodeUrl,
      checkoutUrl: checkoutUrl ?? this.checkoutUrl,
      expiresAt: expiresAt ?? this.expiresAt,
    );
  }
}
