import 'package:flutter/material.dart';
import 'package:rental_car/core/theme/app_colors.dart';
import 'package:rental_car/features/profile/domain/entities/rental_detail_entity.dart';

class RentalVehicleStationCard extends StatelessWidget {
  const RentalVehicleStationCard({required this.rental, super.key});

  final RentalDetailEntity rental;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Phương tiện & Điểm giao nhận',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Ảnh xe
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: 90,
                  height: 65,
                  color: const Color(0xFFF1F5F9),
                  child:
                      rental.vehicleImage != null &&
                          rental.vehicleImage!.startsWith('http')
                      ? Image.network(
                          rental.vehicleImage!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => const Icon(
                            Icons.directions_car,
                            color: Color(0xFF2563EB),
                          ),
                        )
                      : const Icon(
                          Icons.directions_car,
                          color: Color(0xFF2563EB),
                          size: 32,
                        ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      rental.vehicleName,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (rental.vehiclePlateNumber != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: const Color(0xFFCBD5E1)),
                        ),
                        child: Text(
                          rental.vehiclePlateNumber!,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.battery_charging_full_rounded,
                          size: 15,
                          color: (rental.currentBattery ?? 100) > 20
                              ? const Color(0xFF16A34A)
                              : Colors.red,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Pin: ${rental.currentBattery?.toInt() ?? 100}%',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        if (rental.seatCapacity != null) ...[
                          const SizedBox(width: 12),
                          const Icon(
                            Icons.airline_seat_recline_normal,
                            size: 15,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            '${rental.seatCapacity} chỗ',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.ev_station_rounded,
                size: 20,
                color: Color(0xFF2563EB),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      rental.stationName ?? 'Trạm xe e-Motion',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    if (rental.stationAddress != null)
                      Text(
                        rental.stationAddress!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
