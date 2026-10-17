import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rental_car/core/theme/app_colors.dart';
import 'package:rental_car/features/profile/domain/entities/rental_detail_entity.dart';

class RentalScheduleCard extends StatelessWidget {
  const RentalScheduleCard({required this.rental, super.key});

  final RentalDetailEntity rental;

  @override
  Widget build(BuildContext context) {
    final startStr = rental.startTime != null
        ? DateFormat('HH:mm - dd/MM/yyyy').format(rental.startTime!)
        : 'Chưa xác định';
    final endStr = rental.endTime != null
        ? DateFormat('HH:mm - dd/MM/yyyy').format(rental.endTime!)
        : 'Chưa xác định';

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
            'Lịch trình thuê xe',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(
                Icons.access_time_rounded,
                size: 16,
                color: Color(0xFF16A34A),
              ),
              const SizedBox(width: 8),
              const Text(
                'Nhận xe: ',
                style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
              Text(
                startStr,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(
                Icons.event_available_rounded,
                size: 16,
                color: Color(0xFFDC2626),
              ),
              const SizedBox(width: 8),
              const Text(
                'Hẹn trả: ',
                style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
              Text(
                endStr,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          if (rental.isOverdueTime || rental.isOverdue) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF2F2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFFECACA)),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: Color(0xFFDC2626),
                    size: 18,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Đơn thuê đã quá hạn trả xe! Vui lòng hoàn tất trả xe tại trạm sớm nhất để tránh phát sinh thêm phí phạt trễ giờ.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFFB91C1C),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
