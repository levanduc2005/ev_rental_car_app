import 'package:flutter/material.dart';
import 'package:rental_car/core/theme/app_colors.dart';
import 'package:rental_car/core/utils/map_launcher.dart';
import 'package:rental_car/features/vehicles/domain/entities/station_entity.dart';

/// Thẻ hiển thị Trạm nhận xe & Địa chỉ
/// (Hiển thị tên trạm, địa chỉ chi tiết, khoảng cách và nút Chỉ đường Google Maps)
class VehicleStationMapCard extends StatelessWidget {
  const VehicleStationMapCard({
    required this.stationAddress,
    this.onOpenMap,
    this.stationName,
    this.vehicleName,
    this.station,
    this.latitude,
    this.longitude,
    this.distanceKm,
    super.key,
  });

  final String stationAddress;
  final String? stationName;
  final String? vehicleName;
  final VoidCallback? onOpenMap;
  final StationEntity? station;
  final double? latitude;
  final double? longitude;
  final double? distanceKm;

  static String resolveStationName(String? name, String address) {
    if (name != null && name.trim().isNotEmpty) return name.trim();
    if (address.trim().isNotEmpty) return address.trim();
    return 'Trạm xe e-Motion';
  }

  /// Mở ứng dụng Google Maps hoặc trình duyệt để dẫn đường từ vị trí user tới trạm nhận xe
  Future<void> _openDirections(BuildContext context) async {
    await MapLauncher.openDirections(
      context: context,
      latitude: latitude ?? station?.latitude,
      longitude: longitude ?? station?.longitude,
      stationName: stationName,
      stationAddress: stationAddress,
    );
  }

  @override
  Widget build(BuildContext context) {
    final displayName = resolveStationName(stationName, stationAddress);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Text(
                  'Vị trí nhận xe & Trạm sạc',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
                if (distanceKm != null && distanceKm! > 0) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 2.5,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0F2FE),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: const Color(0xFFBAE6FD)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.near_me_rounded,
                          size: 11,
                          color: Color(0xFF0284C7),
                        ),
                        const SizedBox(width: 3),
                        Text(
                          'Cách ${distanceKm!.toStringAsFixed(1)} km',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0284C7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
            if (onOpenMap != null)
              InkWell(
                onTap: onOpenMap,
                borderRadius: BorderRadius.circular(6),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  child: Row(
                    children: [
                      Icon(
                        Icons.map_outlined,
                        size: 15,
                        color: AppColors.primary,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Xem bản đồ',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE2E8F0)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.15),
                      ),
                    ),
                    child: const Icon(
                      Icons.ev_station_rounded,
                      color: AppColors.primary,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          displayName,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          stationAddress,
                          style: const TextStyle(
                            fontSize: 12.5,
                            color: Color(0xFF64748B),
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(height: 1, color: Color(0xFFF1F5F9)),
              const SizedBox(height: 12),
              Material(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(10),
                child: InkWell(
                  onTap: () => _openDirections(context),
                  borderRadius: BorderRadius.circular(10),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.directions_outlined,
                          size: 16,
                          color: Colors.white,
                        ),
                        SizedBox(width: 6),
                        Text(
                          'Chỉ đường qua Google Maps',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
