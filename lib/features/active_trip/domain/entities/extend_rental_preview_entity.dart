/// Thực thể xem trước phí gia hạn đơn thuê xe từ Backend
class ExtendRentalPreviewEntity {
  const ExtendRentalPreviewEntity({
    required this.additionalFee,
    required this.newRentFee,
    required this.currentRentFee,
    required this.additionalHours,
    required this.newReturnTime,
  });

  final double additionalFee;
  final double newRentFee;
  final double currentRentFee;
  final int additionalHours;
  final DateTime newReturnTime;
}
