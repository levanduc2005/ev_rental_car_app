import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:rental_car/app/router/app_routes.dart';
import 'package:rental_car/core/theme/app_colors.dart';
import 'package:rental_car/features/profile/domain/entities/rental_item_entity.dart';

class RentalItemCard extends StatelessWidget {
  const RentalItemCard({
    super.key,
    required this.item,
  });

  final RentalItemEntity item;

  @override
  Widget build(BuildContext context) {
    final isOngoing = item.status.toUpperCase() == 'ONGOING';
    final isCompleted = item.status.toUpperCase() == 'COMPLETED';
    final isPendingFee = item.status.toUpperCase() == 'PENDING_FEE';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          context.pushNamed(
            AppRoute.rentalDetail.name,
            pathParameters: {'id': item.id.toString()},
          );
        },
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE2E8F0)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Mã đơn thuê & Badge trạng thái
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.car_rental_outlined,
                        size: 16,
                        color: Color(0xFF2563EB),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Đơn thuê #${item.id}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 10,
                        color: AppColors.textSecondary,
                      ),
                    ],
                  ),
                  _buildStatusBadge(item.status),
                ],
              ),
              const Divider(height: 16),

              // Car Image + Name + Station
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: (item.vehicleImage != null &&
                            item.vehicleImage!.startsWith('http'))
                        ? Image.network(
                            item.vehicleImage!,
                            width: 80,
                            height: 56,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                _buildCarPlaceholder(),
                          )
                        : _buildCarPlaceholder(),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.vehicleName,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        if (item.stationName != null &&
                            item.stationName!.isNotEmpty)
                          Row(
                            children: [
                              const Icon(
                                Icons.ev_station,
                                size: 13,
                                color: Color(0xFF2563EB),
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  item.stationName!,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: AppColors.textSecondary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        const SizedBox(height: 2),
                        if (item.createdAt != null)
                          Text(
                            'Tạo ngày: ${DateFormat('dd/MM/yyyy HH:mm').format(item.createdAt!)}',
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Footer Actions
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (isOngoing) ...[
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        context.pushNamed(
                          AppRoute.returnLocationVerification.name,
                          extra: item.id,
                        );
                      },
                      icon: const Icon(
                        Icons.assignment_return_rounded,
                        size: 16,
                      ),
                      label: const Text(
                        'Trả xe & Quyết toán',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                  if (isCompleted) ...[
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF2563EB),
                        side: const BorderSide(color: Color(0xFF2563EB)),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        context.pushNamed(
                          AppRoute.checkoutSummary.name,
                          extra: item.id,
                        );
                      },
                      icon: const Icon(Icons.receipt_long_outlined, size: 16),
                      label: const Text(
                        'Bảng kê quyết toán',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                  if (isPendingFee &&
                      item.paymentUrl != null &&
                      item.paymentUrl!.isNotEmpty) ...[
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD97706),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        context.pushNamed(
                          AppRoute.checkoutSummary.name,
                          extra: item.id,
                        );
                      },
                      icon: const Icon(Icons.payment_rounded, size: 16),
                      label: const Text(
                        'Thanh toán phát sinh',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCarPlaceholder() {
    return Container(
      width: 80,
      height: 56,
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(
        child: Icon(
          Icons.directions_car_rounded,
          color: Color(0xFF2563EB),
          size: 28,
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    final (label, bgColor, textColor) = switch (status.toUpperCase()) {
      'ONGOING' => (
        'Đang thuê',
        const Color(0xFFEFF6FF),
        const Color(0xFF2563EB),
      ),
      'CONFIRM' => (
        'Đã xác nhận',
        const Color(0xFFECFDF5),
        const Color(0xFF059669),
      ),
      'PENDING_FEE' => (
        'Chờ quyết toán phí',
        const Color(0xFFFFFBEB),
        const Color(0xFFD97706),
      ),
      'OVERDUE' => (
        'Quá hạn trả',
        const Color(0xFFFEF2F2),
        const Color(0xFFDC2626),
      ),
      'COMPLETED' => (
        'Đã hoàn thành',
        const Color(0xFFF0FDF4),
        const Color(0xFF16A34A),
      ),
      'CANCELLED' => (
        'Đã hủy',
        const Color(0xFFF1F5F9),
        const Color(0xFF64748B),
      ),
      _ => (status, const Color(0xFFF1F5F9), const Color(0xFF64748B)),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
    );
  }
}
