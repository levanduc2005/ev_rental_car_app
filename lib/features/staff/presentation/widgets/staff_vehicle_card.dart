import 'package:flutter/material.dart';
import 'package:rental_car/core/theme/app_colors.dart';
import 'package:rental_car/features/vehicles/domain/entities/vehicle_entity.dart';

class StaffVehicleCard extends StatelessWidget {
  const StaffVehicleCard({required this.vehicle, this.onTap, super.key});

  final VehicleEntity vehicle;
  final VoidCallback? onTap;

  (String label, Color color, Color bg) _getStatusMeta(String status) {
    final s = status.trim().toUpperCase();
    if (s == 'AVAILABLE' || s == 'SẴN SÀNG' || s == 'SAN SANG') {
      return ('Sẵn sàng', const Color(0xFF059669), const Color(0xFFECFDF5));
    }
    if (s == 'RENTING' ||
        s == 'ONGOING' ||
        s == 'ĐANG THUÊ' ||
        s == 'DANG THUE') {
      return ('Đang thuê', const Color(0xFF2563EB), const Color(0xFFEFF6FF));
    }
    if (s == 'RESERVED' || s == 'PENDING' || s == 'ĐÃ ĐẶT' || s == 'DA DAT') {
      return ('Đã đặt', const Color(0xFFD97706), const Color(0xFFFFFBEB));
    }
    if (s.contains('BẢO') ||
        s.contains('BAO') ||
        s == 'MAINTAINED' ||
        s == 'MAINTENANCE') {
      return ('Bảo dưỡng', const Color(0xFFDC2626), const Color(0xFFFEF2F2));
    }
    return (status, const Color(0xFF64748B), const Color(0xFFF1F5F9));
  }

  @override
  Widget build(BuildContext context) {
    final statusMeta = _getStatusMeta(vehicle.status);
    final battery = vehicle.batteryLevel;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x06000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Vehicle Image
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 86,
                  height: 72,
                  color: const Color(0xFFF1F5F9),
                  child:
                      vehicle.mainImage != null && vehicle.mainImage!.isNotEmpty
                      ? Image.network(
                          vehicle.mainImage!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Center(
                                child: Icon(
                                  Icons.directions_car,
                                  color: Colors.grey,
                                  size: 32,
                                ),
                              ),
                        )
                      : const Center(
                          child: Icon(
                            Icons.directions_car,
                            color: Colors.grey,
                            size: 32,
                          ),
                        ),
                ),
              ),
              const SizedBox(width: 12),

              // Vehicle Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            vehicle.name,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: statusMeta.$3,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: statusMeta.$2.withAlpha(50),
                            ),
                          ),
                          child: Text(
                            statusMeta.$1,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: statusMeta.$2,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),

                    // License Plate
                    if (vehicle.plateNumber != null &&
                        vehicle.plateNumber!.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: const Color(0xFFCBD5E1)),
                        ),
                        child: Text(
                          vehicle.plateNumber!,
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                      ),
                    const SizedBox(height: 6),

                    // Battery & seats
                    Row(
                      children: [
                        Icon(
                          Icons.battery_charging_full,
                          size: 14,
                          color: battery > 20
                              ? const Color(0xFF10B981)
                              : const Color(0xFFEF4444),
                        ),
                        const SizedBox(width: 3),
                        Text(
                          '$battery%',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: battery > 20
                                ? const Color(0xFF10B981)
                                : const Color(0xFFEF4444),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Icon(
                          Icons.airline_seat_recline_normal,
                          size: 14,
                          color: Color(0xFF94A3B8),
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '${vehicle.seats} chỗ',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF64748B),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          vehicle.brand,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
