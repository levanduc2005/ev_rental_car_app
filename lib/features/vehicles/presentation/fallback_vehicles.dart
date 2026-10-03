import 'package:flutter/material.dart';
import 'package:rental_car/features/home/presentation/widgets/vehicle_showcase_section.dart';

/// Dữ liệu xe dự phòng tập trung — dùng khi BE offline.
///
/// Định nghĩa một lần duy nhất, được tái sử dụng bởi mọi nơi cần hiển thị
/// danh sách xe fallback trên tầng presentation (homepage, v.v.).
///
/// URL ảnh khớp với database [V2__seed_data.sql] và [_staticFallbackVehicles]
/// trong VehicleRemoteDataSourceImpl.
abstract final class FallbackVehicles {
  // --------------------------------------------------------------------------
  // "Xe có thể bạn sẽ thích" — xe điện phổ thông
  // --------------------------------------------------------------------------
  static const List<VehicleCardData> recommended = [
    VehicleCardData(
      id: 1,
      name: 'VinFast VF 3 Plus 2024',
      imageUrl:
          'https://images.unsplash.com/photo-1533473359331-0135ef1b58bf?q=80&w=800&auto=format&fit=crop',
      rating: 4.9,
      location: 'Quận 1, TP. Hồ Chí Minh',
      seats: '4 chỗ',
      transmission: 'Điện',
      fuelType: 'Điện (95% Pin)',
      price4h: '300K',
      oldPrice4h: '350K',
      price24h: '600K',
      topBadgeText: '⚡ 100% Điện',
      topBadgeColor: Color(0xFF1976D2),
      bottomBadgeText: 'Tự nhận xe',
    ),
    VehicleCardData(
      id: 2,
      name: 'VinFast VF 5 Plus',
      imageUrl:
          'https://images.unsplash.com/photo-1552519507-da3b142c6e3d?q=80&w=800&auto=format&fit=crop',
      rating: 4.95,
      location: 'Quận 1, TP. Hồ Chí Minh',
      seats: '5 chỗ',
      transmission: 'Điện',
      fuelType: 'Điện (88% Pin)',
      price4h: '450K',
      oldPrice4h: '500K',
      price24h: '900K',
      topBadgeText: '⚡ 100% Điện',
      topBadgeColor: Color(0xFF1976D2),
      bottomBadgeText: 'Tự nhận xe',
    ),
    VehicleCardData(
      id: 7,
      name: 'BYD Atto 3 Extended',
      imageUrl:
          'https://images.unsplash.com/photo-1502877338535-766e1452684a?q=80&w=800&auto=format&fit=crop',
      rating: 4.85,
      location: 'Hoàn Kiếm, Hà Nội',
      seats: '5 chỗ',
      transmission: 'Điện',
      fuelType: 'Điện (85% Pin)',
      price4h: '600K',
      oldPrice4h: '700K',
      price24h: '1.200K',
      topBadgeText: '⚡ 100% Điện',
      topBadgeColor: Color(0xFF1976D2),
      bottomBadgeText: 'Tự nhận xe',
    ),
  ];

  // --------------------------------------------------------------------------
  // "Xế xịn • Xe sang" — xe điện cao cấp
  // --------------------------------------------------------------------------
  static const List<VehicleCardData> luxury = [
    VehicleCardData(
      id: 3,
      name: 'VinFast VF 8 Plus',
      imageUrl:
          'https://images.unsplash.com/photo-1617788138017-80ad40651399?q=80&w=800&auto=format&fit=crop',
      rating: 4.95,
      location: 'Quận 1, TP. Hồ Chí Minh',
      seats: '5 chỗ',
      transmission: 'Điện',
      fuelType: 'Điện (72% Pin)',
      price4h: '900K',
      oldPrice4h: '1.050K',
      price24h: '1.800K',
      topBadgeText: '👑 Xế xịn',
      topBadgeColor: Color(0xFFE65100),
      bottomBadgeText: 'Tự nhận xe',
      isLuxury: true,
    ),
    VehicleCardData(
      id: 4,
      name: 'VinFast VF 9 Plus 6 Chỗ',
      imageUrl:
          'https://images.unsplash.com/photo-1563720223185-11003d516935?q=80&w=800&auto=format&fit=crop',
      rating: 5.0,
      location: 'Cầu Giấy, Hà Nội',
      seats: '7 chỗ',
      transmission: 'Điện',
      fuelType: 'Điện (100% Pin)',
      price4h: '1.400K',
      oldPrice4h: '1.600K',
      price24h: '2.800K',
      topBadgeText: '👑 Xế xịn',
      topBadgeColor: Color(0xFFE65100),
      bottomBadgeText: 'Tự nhận xe',
      isLuxury: true,
    ),
    VehicleCardData(
      id: 5,
      name: 'Tesla Model 3 Long Range',
      imageUrl:
          'https://images.unsplash.com/photo-1560958089-b8a1929cea89?q=80&w=800&auto=format&fit=crop',
      rating: 5.0,
      location: 'Cầu Giấy, Hà Nội',
      seats: '5 chỗ',
      transmission: 'Điện',
      fuelType: 'Điện (90% Pin)',
      price4h: '1.200K',
      oldPrice4h: '1.350K',
      price24h: '2.400K',
      topBadgeText: '👑 Xế xịn',
      topBadgeColor: Color(0xFFE65100),
      bottomBadgeText: 'Tự nhận xe',
      isLuxury: true,
    ),
  ];
}
