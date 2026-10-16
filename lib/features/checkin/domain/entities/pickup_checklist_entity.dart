class AccessoryChecklistEntity {
  const AccessoryChecklistEntity({
    this.hasPortableCharger = true,
    this.hasTireRepairKit = true,
    this.hasChargingCard = true,
  });

  final bool hasPortableCharger;
  final bool hasTireRepairKit;
  final bool hasChargingCard;

  AccessoryChecklistEntity copyWith({
    bool? hasPortableCharger,
    bool? hasTireRepairKit,
    bool? hasChargingCard,
  }) {
    return AccessoryChecklistEntity(
      hasPortableCharger: hasPortableCharger ?? this.hasPortableCharger,
      hasTireRepairKit: hasTireRepairKit ?? this.hasTireRepairKit,
      hasChargingCard: hasChargingCard ?? this.hasChargingCard,
    );
  }

  Map<String, dynamic> toJson() => {
    'hasPortableCharger': hasPortableCharger,
    'hasTireRepairKit': hasTireRepairKit,
    'hasChargingCard': hasChargingCard,
  };
}

class CarImagesEntity {
  const CarImagesEntity({
    this.urls = const [],
    this.frontUrl = '',
    this.backUrl = '',
    this.leftSideUrl = '',
    this.rightSideUrl = '',
  });

  final List<String> urls;
  final String frontUrl;
  final String backUrl;
  final String leftSideUrl;
  final String rightSideUrl;

  List<String> get allUrls {
    if (urls.isNotEmpty) {
      return urls.where((u) => u.trim().isNotEmpty).toList();
    }
    return [
      frontUrl,
      backUrl,
      leftSideUrl,
      rightSideUrl,
    ].where((u) => u.trim().isNotEmpty).toList();
  }

  bool get isComplete =>
      urls.isNotEmpty ||
      (frontUrl.trim().isNotEmpty &&
          backUrl.trim().isNotEmpty &&
          leftSideUrl.trim().isNotEmpty &&
          rightSideUrl.trim().isNotEmpty);

  int get uploadedCount {
    if (urls.isNotEmpty) return urls.length;
    var count = 0;
    if (frontUrl.trim().isNotEmpty) count++;
    if (backUrl.trim().isNotEmpty) count++;
    if (leftSideUrl.trim().isNotEmpty) count++;
    if (rightSideUrl.trim().isNotEmpty) count++;
    return count;
  }

  CarImagesEntity copyWith({
    List<String>? urls,
    String? frontUrl,
    String? backUrl,
    String? leftSideUrl,
    String? rightSideUrl,
  }) {
    return CarImagesEntity(
      urls: urls ?? this.urls,
      frontUrl: frontUrl ?? this.frontUrl,
      backUrl: backUrl ?? this.backUrl,
      leftSideUrl: leftSideUrl ?? this.leftSideUrl,
      rightSideUrl: rightSideUrl ?? this.rightSideUrl,
    );
  }

  Map<String, dynamic> toJson() => {
    'urls': allUrls,
    'img': allUrls.join('|'),
    'frontUrl': frontUrl.isNotEmpty
        ? frontUrl
        : (allUrls.isNotEmpty ? allUrls.first : ''),
    'backUrl': backUrl.isNotEmpty
        ? backUrl
        : (allUrls.length > 1 ? allUrls[1] : ''),
    'leftSideUrl': leftSideUrl.isNotEmpty
        ? leftSideUrl
        : (allUrls.length > 2 ? allUrls[2] : ''),
    'rightSideUrl': rightSideUrl.isNotEmpty
        ? rightSideUrl
        : (allUrls.length > 3 ? allUrls[3] : ''),
  };
}

class PickupChecklistEntity {
  const PickupChecklistEntity({
    required this.checklistId,
    required this.rentalId,
    required this.type,
    required this.odometer,
    required this.batteryPercentage,
    this.hasPortableCharger = true,
    this.hasTireRepairKit = true,
    this.hasChargingCard = true,
    this.photoCount = 4,
    this.createdAt,
  });

  final int checklistId;
  final int rentalId;
  final String type;
  final int odometer;
  final int batteryPercentage;
  final bool hasPortableCharger;
  final bool hasTireRepairKit;
  final bool hasChargingCard;
  final int photoCount;
  final DateTime? createdAt;
}
