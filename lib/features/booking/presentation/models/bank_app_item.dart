/// Đại diện cho một ứng dụng ngân hàng hỗ trợ App-to-App Deeplink (VietQR Napas247)
/// Dữ liệu nạp động 100% từ VietQR Open API, không hardcode danh sách hoặc mã ngân hàng
class BankAppItem {
  const BankAppItem({
    required this.appId,
    required this.code,
    required this.name,
    required this.shortName,
    required this.logoUrl,
    this.bin,
    this.isPopular = false,
  });

  /// Mã định danh ứng dụng cho VietQR Deeplink (vd: 'mb', 'vcb', 'tcb')
  final String appId;

  /// Mã ngân hàng (vd: 'MB', 'VCB', 'TCB')
  final String code;

  /// Tên thương hiệu đầy đủ của ngân hàng
  final String name;

  /// Tên viết tắt ngắn gọn (vd: 'MBBank', 'Vietcombank')
  final String shortName;

  /// Logo chính thức từ VietQR CDN
  final String logoUrl;

  /// Mã BIN ngân hàng (vd: '970422')
  final String? bin;

  /// Đánh dấu thuộc Top ngân hàng phổ biến (xác định động theo vị trí hoặc cờ từ API)
  final bool isPopular;

  /// Map động từ response VietQR API (https://api.vietqr.io/v2/banks)
  factory BankAppItem.fromVietQRJson(Map<String, dynamic> json) {
    final code = json['code']?.toString().trim() ?? '';
    final shortName =
        json['shortName']?.toString() ?? json['short_name']?.toString() ?? code;
    final name = json['name']?.toString() ?? shortName;
    final bin = json['bin']?.toString().trim();
    final logo =
        json['logo']?.toString() ??
        'https://cdn.vietqr.io/img/${code.toUpperCase()}.png';
    final appId = code.toLowerCase();

    return BankAppItem(
      appId: appId,
      code: code,
      name: name,
      shortName: shortName,
      logoUrl: logo,
      bin: bin,
    );
  }

  /// Tạo đường dẫn Deeplink App-to-App theo chuẩn VietQR dl.vietqr.io
  /// Nhận mã ngân hàng thụ hưởng động từ đối tượng ngân hàng nhận (không dùng map tĩnh)
  String buildDeeplink({
    required String beneficiaryAccountNumber,
    required String beneficiaryBankCode,
    required int amount,
    required String description,
    String? beneficiaryAccountName,
  }) {
    final receivingCode = beneficiaryBankCode.toLowerCase().trim();
    final ba = '$beneficiaryAccountNumber@$receivingCode';
    final am = amount.toString();
    final tn = Uri.encodeComponent(description);
    final bn =
        beneficiaryAccountName != null && beneficiaryAccountName.isNotEmpty
        ? '&bn=${Uri.encodeComponent(beneficiaryAccountName)}'
        : '';
    return 'https://dl.vietqr.io/pay?app=$appId&ba=$ba&am=$am&tn=$tn$bn';
  }
}
