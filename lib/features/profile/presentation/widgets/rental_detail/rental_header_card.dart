import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rental_car/core/theme/app_colors.dart';
import 'package:rental_car/features/profile/domain/entities/rental_detail_entity.dart';
import 'package:rental_car/features/profile/presentation/widgets/rental_detail/rental_status_badge.dart';

class RentalHeaderCard extends StatelessWidget {
  const RentalHeaderCard({required this.rental, super.key});

  final RentalDetailEntity rental;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'MÃ ĐƠN: #RENTAL-${rental.id}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              if (rental.createdAt != null)
                Text(
                  'Tạo lúc: ${DateFormat('dd/MM/yyyy HH:mm').format(rental.createdAt!)}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              if (rental.reservationCode != null &&
                  rental.reservationCode!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    'Đơn đặt trước: #${rental.reservationCode}',
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF2563EB),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
          RentalStatusBadge(status: rental.status),
        ],
      ),
    );
  }
}
