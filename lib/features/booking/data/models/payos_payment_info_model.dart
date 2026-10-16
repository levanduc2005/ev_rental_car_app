import 'package:rental_car/features/booking/domain/entities/payos_payment_info_entity.dart';

class PayOSPaymentInfoModel {
  const PayOSPaymentInfoModel({
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

  final String orderCode;
  final double amount;
  final String description;
  final String accountNumber;
  final String accountName;
  final String? bin;
  final String? bankName;
  final String qrCodeUrl;
  final String? checkoutUrl;
  final DateTime? expiresAt;

  factory PayOSPaymentInfoModel.fromJson(Map<String, dynamic> json) {
    final code =
        json['orderCode']?.toString() ??
        json['code']?.toString() ??
        DateTime.now().millisecondsSinceEpoch.toString();
    final amount = (json['amount'] as num?)?.toDouble() ?? 0.0;
    final checkoutUrl =
        json['checkoutUrl'] as String? ?? json['vnpayUrl'] as String?;
    final bin = json['bin']?.toString();
    final accountNumber = json['accountNumber']?.toString() ?? '';
    final accountName = json['accountName']?.toString() ?? '';
    final bank = json['bankName']?.toString();
    final description = json['description']?.toString() ?? code;
    final rawQr = json['qrCode']?.toString();
    final qrCodeUrl = (rawQr != null && rawQr.startsWith('http'))
        ? rawQr
        : (bin != null && accountNumber.isNotEmpty
              ? 'https://img.vietqr.io/image/$bin-$accountNumber-compact2.png?amount=${amount.toInt()}&addInfo=$description&accountName=${Uri.encodeComponent(accountName)}'
              : '');

    DateTime? parsedExpiresAt;
    if (json['expiresAt'] != null) {
      parsedExpiresAt = DateTime.tryParse(json['expiresAt'].toString());
    } else if (json['expiredAt'] != null) {
      final rawExp = json['expiredAt'];
      if (rawExp is num) {
        parsedExpiresAt = DateTime.fromMillisecondsSinceEpoch(
          rawExp.toInt() * 1000,
        );
      } else {
        parsedExpiresAt = DateTime.tryParse(rawExp.toString());
      }
    }

    return PayOSPaymentInfoModel(
      orderCode: code,
      amount: amount,
      description: description,
      accountNumber: accountNumber,
      accountName: accountName,
      bin: bin,
      bankName: bank,
      qrCodeUrl: qrCodeUrl,
      checkoutUrl: checkoutUrl,
      expiresAt: parsedExpiresAt,
    );
  }

  PayOSPaymentInfoEntity toEntity() {
    return PayOSPaymentInfoEntity(
      orderCode: orderCode,
      amount: amount,
      description: description,
      accountNumber: accountNumber,
      accountName: accountName,
      bin: bin,
      bankName: bankName,
      qrCodeUrl: qrCodeUrl,
      checkoutUrl: checkoutUrl,
      expiresAt: expiresAt,
    );
  }
}
