import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rental_car/app/router/app_routes.dart';
import 'package:rental_car/core/theme/app_colors.dart';
import 'package:rental_car/features/booking/domain/entities/reservation_entity.dart';
import 'package:rental_car/features/booking/presentation/utils/booking_formatters.dart';
import 'package:rental_car/features/booking/presentation/widgets/reservation_status_badge.dart';

/// Thẻ hiển thị Đơn đặt xe trong danh sách (My Reservations)
class ReservationCard extends StatelessWidget {
  const ReservationCard({
    required this.reservation,
    required this.onCancel,
    required this.onResumePayment,
    super.key,
  });

  final ReservationEntity reservation;
  final VoidCallback onCancel;
  final VoidCallback onResumePayment;

  @override
  Widget build(BuildContext context) {
    final isPending = reservation.isPending;
    final isConfirmed = reservation.isConfirmed;
    final isCompleted = reservation.isCompleted;
    final isInactive = reservation.isCancelled || reservation.isFailed || reservation.isOverdue;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          context.pushNamed(
            AppRoute.reservationDetail.name,
            pathParameters: {'id': reservation.id.toString()},
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Card (Code & Status Badge)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.receipt_long,
                            size: 16, color: Color(0xFF2563EB)),
                        const SizedBox(width: 6),
                        Text(
                          '#${reservation.reservationCode}',
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    ReservationStatusBadge(status: reservation.status),
                  ],
                ),
              ),
              const Divider(height: 1),

              // Body Card (Vehicle Image & Schedule Time)
              Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        reservation.vehicle?.imageUrl ??
                            'https://lh3.googleusercontent.com/aida-public/AB6AXuDiVxOjLTj5JjghKDMPBd4UdJ_tVbMRIeMLtOgIdtKfkOojv_PO48hcEhHu1lCas852tOakhx5EzvZJr18RncORxAd4wzE7iOCrGu_pPeT-2UMEUMKEpG3yg41U4Hlgx7U25hQTa-DQRn9VBaL14InoB6SsnBprAJMduwVP7G4v3VwNRuYGwPChVd6ICkoZKdZb8VD9ArMtDvKRmJ_hfeO9hL7cMcvEW-Tl6bD6UBZ3wkMr1XAQC9z4mSM3WB7MLeiiIcw',
                        width: 80,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => Container(
                          width: 80,
                          height: 60,
                          color: Colors.grey.shade200,
                          child: const Icon(Icons.directions_car, color: Colors.grey),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            reservation.vehicle?.name ?? 'Xe điện e-Motion',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.access_time,
                                  size: 13, color: AppColors.textSecondary),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  'Nhận: ${BookingFormatters.formatDateTime(reservation.startDateTime)}',
                                  style: const TextStyle(
                                      fontSize: 11,
                                      color: AppColors.textSecondary),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              const Icon(Icons.event_available,
                                  size: 13, color: AppColors.textSecondary),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  'Trả: ${BookingFormatters.formatDateTime(reservation.endDateTime)}',
                                  style: const TextStyle(
                                      fontSize: 11,
                                      color: AppColors.textSecondary),
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
              const Divider(height: 1),

              // Footer Card (Amounts & Contextual Action Buttons)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Cọc giữ chỗ / Tổng:',
                            style: TextStyle(
                                fontSize: 10, color: AppColors.textSecondary)),
                        Text(
                          isPending
                              ? BookingFormatters.formatCurrency(reservation.depositFee)
                              : BookingFormatters.formatCurrency(reservation.totalAmount),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2563EB),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        // PENDING: Cho phép hủy tức thì & tiếp tục thanh toán
                        if (isPending) ...[
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.error,
                              side: const BorderSide(color: AppColors.error),
                              visualDensity: VisualDensity.compact,
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                            ),
                            onPressed: onCancel,
                            child: const Text('Hủy giữ chỗ',
                                style: TextStyle(fontSize: 11)),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2563EB),
                              foregroundColor: Colors.white,
                              visualDensity: VisualDensity.compact,
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                            ),
                            onPressed: onResumePayment,
                            child: const Text('Thanh toán',
                                style: TextStyle(
                                    fontSize: 11, fontWeight: FontWeight.bold)),
                          ),
                        ],

                        // CONFIRM: Cho phép hủy nếu > 5 ngày, hoặc xem chi tiết
                        if (isConfirmed) ...[
                          if (reservation.canCancel)
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.error,
                                side: const BorderSide(color: AppColors.error),
                                visualDensity: VisualDensity.compact,
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                              ),
                              onPressed: onCancel,
                              child: const Text('Hủy đơn',
                                  style: TextStyle(fontSize: 11)),
                            )
                          else
                            const Text(
                              'Không thể hủy (<5 ngày)',
                              style: TextStyle(
                                fontSize: 10,
                                color: AppColors.textSecondary,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          const SizedBox(width: 8),
                          OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFF2563EB),
                              side: const BorderSide(color: Color(0xFF2563EB)),
                              visualDensity: VisualDensity.compact,
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                            ),
                            onPressed: () {
                              context.pushNamed(
                                AppRoute.reservationDetail.name,
                                pathParameters: {'id': reservation.id.toString()},
                              );
                            },
                            icon: const Icon(Icons.qr_code, size: 14),
                            label: const Text('Mã QR Check-in',
                                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                          ),
                        ],

                        // ACTIVE / IN_PROGRESS: Đang thuê, hiển thị QR / Chi tiết
                        if (reservation.isActive) ...[
                          OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFF2563EB),
                              side: const BorderSide(color: Color(0xFF2563EB)),
                              visualDensity: VisualDensity.compact,
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                            ),
                            onPressed: () {
                              context.pushNamed(
                                AppRoute.reservationDetail.name,
                                pathParameters: {'id': reservation.id.toString()},
                              );
                            },
                            icon: const Icon(Icons.qr_code, size: 14),
                            label: const Text('Mã QR Check-in',
                                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                          ),
                        ],

                        // COMPLETED: Cho phép thuê lại
                        if (isCompleted)
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2563EB),
                              foregroundColor: Colors.white,
                              visualDensity: VisualDensity.compact,
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                            ),
                            onPressed: () => context.goNamed(AppRoute.home.name),
                            child: const Text('Thuê lại xe',
                                style: TextStyle(fontSize: 11)),
                          ),

                        // CANCELLED / FAILED / OVERDUE: Thuê xe khác
                        if (isInactive)
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFF2563EB),
                              side: const BorderSide(color: Color(0xFF2563EB)),
                              visualDensity: VisualDensity.compact,
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                            ),
                            onPressed: () => context.goNamed(AppRoute.home.name),
                            child: const Text('Thuê xe khác',
                                style: TextStyle(fontSize: 11)),
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
