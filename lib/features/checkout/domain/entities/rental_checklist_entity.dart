class RentalChecklistEntity {
  const RentalChecklistEntity({
    required this.id,
    required this.type,
    required this.currentBattery,
    this.fee = 0.0,
    this.img = '',
    this.createdAt,
  });

  final int id;
  final String type; // 'CHECK_IN' hoặc 'CHECK_OUT'
  final double currentBattery;
  final double fee;
  final String img;
  final DateTime? createdAt;

  bool get isCheckIn => type == 'CHECK_IN';
  bool get isCheckOut => type == 'CHECK_OUT';

  List<String> get imageUrls {
    if (img.isEmpty) return const [];
    return img.split('|').where((url) => url.trim().isNotEmpty).toList();
  }
}
