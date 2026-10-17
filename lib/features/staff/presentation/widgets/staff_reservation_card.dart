import 'package:flutter/material.dart';
import 'package:rental_car/core/theme/app_colors.dart';
import 'package:rental_car/features/booking/domain/entities/reservation_entity.dart';
import 'package:rental_car/features/booking/presentation/utils/booking_formatters.dart';

class StaffReservationCard extends StatelessWidget {
  const StaffReservationCard({
    super.key,
    required this.reservation,
    required this.onStartHandover,
  });

  final ReservationEntity reservation;
  final VoidCallback onStartHandover;

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'CONFIRM':
      case 'CONFIRMED':
      case 'DEPOSITED':
        return const Color(0xFF16A34A);
      case 'COMPLETED':
      case 'DONE':
        return const Color(0xFF059669);
      case 'CANCELLED':
      case 'CANCEL':
      case 'OVERDUE':
        return const Color(0xFFDC2626);
      default:
        return const Color(0xFF2563EB);
    }
  }

  String _getStatusLabel(String status) {
    switch (status.toUpperCase()) {
      case 'CONFIRM':
      case 'CONFIRMED':
      case 'DEPOSITED':
        return 'Sẵn sàng giao';
      case 'COMPLETED':
      case 'DONE':
        return 'Đã hoàn thành';
      case 'CANCELLED':
      case 'CANCEL':
        return 'Đã hủy';
      case 'OVERDUE':
        return 'Quá giờ nhận';
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(reservation.status);
    final statusLabel = _getStatusLabel(reservation.status);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x06000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Mã đơn + Badge
          // Header: Mã đơn + Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '#${reservation.code}',
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Color(0xFF2563EB),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  statusLabel,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
          if (reservation.userEmail != null &&
              reservation.userEmail!.isNotEmpty) ...[
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(
                  Icons.person_outline_rounded,
                  size: 14,
                  color: Color(0xFF64748B),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    'Khách hàng: ${reservation.userEmail!}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF475569),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
          const Divider(height: 16),

          // Xe + Lịch trình
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child:
                    (reservation.vehicleImageUrl != null &&
                        reservation.vehicleImageUrl!.startsWith('http'))
                    ? Image.network(
                        reservation.vehicleImageUrl!,
                        width: 76,
                        height: 58,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => _buildPlaceholder(),
                      )
                    : _buildPlaceholder(),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reservation.vehicleName ?? 'Xe điện e-Motion',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (reservation.startTime != null)
                      Text(
                        'Nhận xe: ${BookingFormatters.formatDateTime(reservation.startTime!)}',
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    if (reservation.endTime != null)
                      Text(
                        'Dự kiến trả: ${BookingFormatters.formatDateTime(reservation.endTime!)}',
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    if (reservation.stationName != null &&
                        reservation.stationName!.isNotEmpty)
                      Text(
                        'Trạm: ${reservation.stationName!}',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    const SizedBox(height: 2),
                    Wrap(
                      spacing: 8,
                      runSpacing: 2,
                      children: [
                        if (reservation.depositAmount != null)
                          Text(
                            'Đã cọc: ${BookingFormatters.formatCurrency(reservation.depositAmount!.round())}',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF16A34A),
                            ),
                          ),
                        if (reservation.totalAmount > 0)
                          Text(
                            'Tiền thuê: ${BookingFormatters.formatCurrency(reservation.totalAmount)}',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2563EB),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Trạng thái / Nút nhận xe
          if (reservation.status.toUpperCase() == 'CANCELLED' ||
              reservation.status.toUpperCase() == 'CANCEL') ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF2F2),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFFECACA)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.cancel_rounded,
                    size: 16,
                    color: Color(0xFFDC2626),
                  ),
                  SizedBox(width: 6),
                  Text(
                    'Đơn đặt xe này đã bị hủy',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFDC2626),
                    ),
                  ),
                ],
              ),
            ),
          ] else if (reservation.status.toUpperCase() == 'COMPLETED' ||
              reservation.status.toUpperCase() == 'DONE') ...[
            // Đã hoàn thành: chỉ hiển thị thông tin đơn cơ bản, status badge ở header đã thể hiện rõ
          ] else ...[
            const SizedBox(height: 12),
            // Nút nhận xe
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: onStartHandover,
                icon: const Icon(Icons.key_rounded, size: 16),
                label: const Text(
                  'Tiến hành nhận xe',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: 70,
      height: 52,
      color: const Color(0xFFEFF6FF),
      child: const Center(
        child: Icon(Icons.directions_car_rounded, color: Color(0xFF2563EB)),
      ),
    );
  }
}
