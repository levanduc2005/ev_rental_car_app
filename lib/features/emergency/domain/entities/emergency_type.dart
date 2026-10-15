enum EmergencyType {
  outOfBattery(
    code: 'OUT_OF_BATTERY',
    displayName: 'Hết pin giữa đường',
    shortDescription: 'Pin xe cạn, cần hỗ trợ sạc lưu động hoặc cứu hộ.',
  ),
  flatTire(
    code: 'FLAT_TIRE',
    displayName: 'Thủng lốp / Nổ lốp',
    shortDescription: 'Lốp xe bị rách, thủng hoặc phát nổ, không thể lăn bánh.',
  ),
  accident(
    code: 'ACCIDENT',
    displayName: 'Va chạm / Tai nạn',
    shortDescription: 'Xe gặp sự cố va quẹt hoặc tai nạn trên đường.',
  ),
  technicalFault(
    code: 'TECHNICAL_FAULT',
    displayName: 'Hỏng hóc kỹ thuật',
    shortDescription:
        'Lỗi hệ thống điện, motor, phanh hoặc không khởi động được.',
  );

  const EmergencyType({
    required this.code,
    required this.displayName,
    required this.shortDescription,
  });

  final String code;
  final String displayName;
  final String shortDescription;

  static EmergencyType fromCode(String? code) {
    return switch (code?.toUpperCase()) {
      'OUT_OF_BATTERY' => EmergencyType.outOfBattery,
      'FLAT_TIRE' => EmergencyType.flatTire,
      'ACCIDENT' => EmergencyType.accident,
      'TECHNICAL_FAULT' => EmergencyType.technicalFault,
      _ => EmergencyType.technicalFault,
    };
  }
}
