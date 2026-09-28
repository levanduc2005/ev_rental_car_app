class PayOSPaymentInfoEntity {
  const PayOSPaymentInfoEntity({
    required this.orderCode,
    required this.amount,
    required this.description,
    required this.accountNumber,
    required this.accountName,
    required this.bankName,
    required this.qrCodeUrl,
    this.bin,
    this.checkoutUrl,
    this.expiresAt,
  });

  /// Mã đơn đặt cọc thanh toán
  final String orderCode;

  /// Số tiền cọc giữ chỗ (mặc định 500.000 VNĐ)
  final double amount;

  /// Cú pháp / Nội dung chuyển khoản (ví dụ: BBC1789616882506)
  final String description;

  /// Số tài khoản thụ hưởng do PayOS cấp
  final String accountNumber;

  /// Tên chủ tài khoản ngân hàng do PayOS cấp
  final String accountName;

  /// Mã BIN ngân hàng (ví dụ: 970422 cho MBBank)
  final String? bin;

  /// Tên ngân hàng thụ hưởng (tự động phân giải theo mã BIN của PayOS)
  final String bankName;

  /// Đường dẫn hình ảnh hoặc mã QR VietQR do PayOS sinh ra
  final String qrCodeUrl;

  /// Đường dẫn trang thanh toán web (dự phòng)
  final String? checkoutUrl;

  /// Thời điểm hết hạn đếm ngược (thường là 15 phút)
  final DateTime? expiresAt;

  // Tiện ích tương thích UI
  String get transferContent => description;
  int get depositFee => amount.toInt();
  String get vietQrImageUrl => qrCodeUrl;

  /// Phân giải tên ngắn của ngân hàng dựa theo mã BIN thật từ PayOS
  String get bankShortName {
    switch (bin) {
      case '970422':
        return 'MBBank';
      case '970436':
        return 'Vietcombank';
      case '970415':
        return 'VietinBank';
      case '970418':
        return 'BIDV';
      case '970407':
        return 'Techcombank';
      case '970423':
        return 'TPBank';
      case '970432':
        return 'VPBank';
      case '970416':
        return 'ACB';
      case '970448':
        return 'OCB';
      case '970405':
        return 'Agribank';
      default:
        if (bankName.toUpperCase().contains('MB')) return 'MBBank';
        return bankName.isNotEmpty ? bankName.split(' ').first : 'Ngân hàng';
    }
  }

  /// Tự động ánh xạ mã BIN sang tên đầy đủ ngân hàng
  static String resolveBankName(String? bin, [String? fallback]) {
    switch (bin) {
      case '970422':
        return 'MBBank (Ngân hàng Quân Đội)';
      case '970436':
        return 'Vietcombank (Ngoại thương Việt Nam)';
      case '970415':
        return 'VietinBank (Công thương Việt Nam)';
      case '970418':
        return 'BIDV (Đầu tư & Phát triển)';
      case '970407':
        return 'Techcombank (Kỹ thương)';
      case '970423':
        return 'TPBank (Tiên Phong)';
      case '970432':
        return 'VPBank (Việt Nam Thịnh Vượng)';
      case '970416':
        return 'ACB (Á Châu)';
      case '970448':
        return 'OCB (Phương Đông)';
      case '970405':
        return 'Agribank (Nông nghiệp & PTNT)';
      default:
        return fallback ?? 'Ngân hàng đối tác PayOS';
    }
  }

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

typedef PayosPaymentInfoEntity = PayOSPaymentInfoEntity;
