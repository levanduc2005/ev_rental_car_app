import 'package:rental_car/features/booking/domain/entities/payos_payment_info_entity.dart';

class PayOSPaymentInfoModel {
  const PayOSPaymentInfoModel({
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

  final String orderCode;
  final double amount;
  final String description;
  final String accountNumber;
  final String accountName;
  final String? bin;
  final String bankName;
  final String qrCodeUrl;
  final String? checkoutUrl;
  final DateTime? expiresAt;

  factory PayOSPaymentInfoModel.fromJson(Map<String, dynamic> json) {
    final code = json['orderCode']?.toString() ??
        json['code']?.toString() ??
        DateTime.now().millisecondsSinceEpoch.toString();
    final amount = (json['amount'] as num?)?.toDouble() ?? 500000.0;
    final checkoutUrl = json['checkoutUrl'] as String? ?? json['vnpayUrl'] as String?;
    final bin = json['bin']?.toString() ?? '970422';
    final accountNumber = json['accountNumber']?.toString() ?? '';
    final accountName = json['accountName']?.toString() ?? '';
    final bank = json['bankName']?.toString() ??
        PayOSPaymentInfoEntity.resolveBankName(bin);
    final description = json['description']?.toString() ??
        (code.startsWith('BBC') ? code : 'BBC$code');
    final rawQr = json['qrCode']?.toString();
    final qrCodeUrl = (rawQr != null && rawQr.startsWith('http'))
        ? rawQr
        : (accountNumber.isNotEmpty
            ? 'https://img.vietqr.io/image/$bin-$accountNumber-compact2.png?amount=${amount.toInt()}&addInfo=$description&accountName=${Uri.encodeComponent(accountName)}'
            : '');

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
      expiresAt: DateTime.now().add(const Duration(minutes: 15)),
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
