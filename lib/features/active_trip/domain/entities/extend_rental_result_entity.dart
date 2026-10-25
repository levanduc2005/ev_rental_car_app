/// Thực thể kết quả phản hồi khi yêu cầu gia hạn đơn thuê xe
class ExtendRentalResultEntity {
  const ExtendRentalResultEntity({required this.url, this.qrCode});

  final String url;
  final String? qrCode;
}
