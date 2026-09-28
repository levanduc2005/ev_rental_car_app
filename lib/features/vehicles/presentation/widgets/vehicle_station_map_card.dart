import 'package:flutter/material.dart';
import 'package:rental_car/features/vehicles/presentation/widgets/location_selector_card.dart';

/// Thẻ hiển thị Trạm & Vị trí xe trên bản đồ
/// (Giao diện vector preview giả lập vị trí trạm xe và điều hướng sang màn hình bản đồ,
/// chờ tích hợp Goong Map SDK khi có cấu hình API Key)
class VehicleStationMapCard extends StatelessWidget {
  const VehicleStationMapCard({
    required this.stationAddress,
    required this.onOpenMap,
    this.stationName,
    this.vehicleName,
    super.key,
  });

  final String stationAddress;
  final String? stationName;
  final String? vehicleName;
  final VoidCallback onOpenMap;

  @override
  Widget build(BuildContext context) {
    final displayName =
        LocationSelectorCard.resolveStationName(stationName, stationAddress);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Vị trí xe & Trạm sạc',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
            InkWell(
              onTap: onOpenMap,
              borderRadius: BorderRadius.circular(6),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                child: Row(
                  children: [
                    Icon(Icons.map_outlined, size: 15, color: Color(0xFF1976D2)),
                    SizedBox(width: 4),
                    Text(
                      'Mở bản đồ',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1976D2),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: onOpenMap,
          child: Container(
            height: 170,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFE2E8F0),
                  Color(0xFFCBD5E1),
                ],
              ),
              border: Border.all(color: const Color(0xFFCBD5E1)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Bản đồ nền vector phong cách hiện đại với grid đường phố
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: CustomPaint(
                      painter: _MapGridPainter(),
                    ),
                  ),
                ),
                // Marker trạm xe e-Motion ở trung tâm (hiển thị Tên của Trạm)
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1976D2),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF1976D2).withValues(alpha: 0.35),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.ev_station_rounded,
                              color: Colors.white,
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                displayName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Icon(
                        Icons.location_on,
                        color: Color(0xFF1976D2),
                        size: 28,
                      ),
                    ],
                  ),
                ),
                // Thanh địa chỉ & tên trạm gắn ở đáy bản đồ
                Positioned(
                  left: 12,
                  right: 12,
                  bottom: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.95),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.place_rounded,
                          size: 18,
                          color: Color(0xFF1976D2),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                displayName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1E293B),
                                ),
                              ),
                              const SizedBox(height: 1),
                              Text(
                                stationAddress,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1976D2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'Xem trạm',
                            style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// GHI CHÚ KỸ THUẬT (MOCK MAP PREVIEW):
/// Hiện tại ứng dụng chưa tích hợp SDK Bản đồ trực tiếp (như Goong Map SDK hoặc Google Maps SDK)
/// trong pubspec.yaml do phụ thuộc vào API Key bên thứ ba.
/// Lớp [_MapGridPainter] bên dưới là CustomPainter đồ họa vector giả lập giao diện bản đồ trạm xe
/// để minh họa trực quan vị trí trạm và hỗ trợ mở màn hình bản đồ tương tác khi người dùng bấm vào.
/// TODO: Khi tích hợp SDK Goong Map (hoặc Mapbox/Google Maps), thay thế CustomPaint bằng Widget Map thật.
class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final roadPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.7)
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke;

    final secondaryRoadPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.45)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final waterPaint = Paint()
      ..color = const Color(0xFFBAE6FD).withValues(alpha: 0.35)
      ..style = PaintingStyle.fill;

    // Vẽ sông nước nhẹ
    final riverPath = Path();
    riverPath.moveTo(0, size.height * 0.2);
    riverPath.quadraticBezierTo(size.width * 0.4, size.height * 0.35, size.width * 0.8, 0);
    riverPath.lineTo(size.width, 0);
    riverPath.lineTo(size.width, size.height * 0.15);
    riverPath.quadraticBezierTo(size.width * 0.4, size.height * 0.45, 0, size.height * 0.3);
    riverPath.close();
    canvas.drawPath(riverPath, waterPaint);

    // Tuyến đường chính
    final mainRoad1 = Path()
      ..moveTo(0, size.height * 0.65)
      ..lineTo(size.width, size.height * 0.45);
    canvas.drawPath(mainRoad1, roadPaint);

    final mainRoad2 = Path()
      ..moveTo(size.width * 0.35, 0)
      ..lineTo(size.width * 0.65, size.height);
    canvas.drawPath(mainRoad2, roadPaint);

    // Đường nhỏ cắt ngang
    final road3 = Path()
      ..moveTo(size.width * 0.1, size.height)
      ..lineTo(size.width * 0.9, size.height * 0.1);
    canvas.drawPath(road3, secondaryRoadPaint);

    final road4 = Path()
      ..moveTo(0, size.height * 0.85)
      ..lineTo(size.width, size.height * 0.85);
    canvas.drawPath(road4, secondaryRoadPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
