import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:rental_car/app/router/app_routes.dart';
import 'package:rental_car/core/theme/app_colors.dart';
import 'package:rental_car/features/profile/domain/entities/rental_item_entity.dart';
import 'package:url_launcher/url_launcher.dart';

class RentalItemCard extends StatelessWidget {
  const RentalItemCard({super.key, required this.item, this.onRefresh});

  final RentalItemEntity item;
  final VoidCallback? onRefresh;

  @override
  Widget build(BuildContext context) {
    final isConfirmed =
        item.status.toUpperCase() == 'CONFIRM' ||
        item.status.toUpperCase() == 'DEPOSITED';
    final isOngoing = item.status.toUpperCase() == 'ONGOING';
    final isCompleted = item.status.toUpperCase() == 'COMPLETED';
    final isPendingFee = item.status.toUpperCase() == 'PENDING_FEE';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () async {
          if (isOngoing) {
            await context.pushNamed(AppRoute.activeTrip.name, extra: item.id);
          } else {
            await context.pushNamed(
              AppRoute.rentalDetail.name,
              pathParameters: {'id': item.id.toString()},
            );
          }
          onRefresh?.call();
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
                    child:
                        (item.vehicleImage != null &&
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
                  if (isConfirmed) ...[
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF2563EB),
                        side: const BorderSide(color: Color(0xFF2563EB)),
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
                          AppRoute.rentalDetail.name,
                          pathParameters: {'id': item.id.toString()},
                        );
                      },
                      icon: const Icon(Icons.receipt_long_rounded, size: 16),
                      label: const Text(
                        'Xem chi tiết',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                  if (isOngoing) ...[
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF059669),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 1,
                      ),
                      onPressed: () {
                        context.pushNamed(
                          AppRoute.activeTrip.name,
                          extra: item.id,
                        );
                      },
                      icon: const Icon(Icons.navigation_rounded, size: 16),
                      label: const Text(
                        'Vào chuyến đi',
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
                          AppRoute.rentalDetail.name,
                          pathParameters: {'id': item.id.toString()},
                        );
                      },
                      icon: const Icon(Icons.receipt_long_outlined, size: 16),
                      label: const Text(
                        'Xem chi tiết',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                  if (isPendingFee) ...[
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
                      onPressed: () async {
                        if (item.paymentUrl != null &&
                            item.paymentUrl!.isNotEmpty) {
                          final uri = Uri.tryParse(item.paymentUrl!);
                          if (uri != null && await canLaunchUrl(uri)) {
                            await launchUrl(
                              uri,
                              mode: LaunchMode.externalApplication,
                            );
                            return;
                          }
                        }
                        if (!context.mounted) return;
                        context.pushNamed(
                          AppRoute.rentalDetail.name,
                          pathParameters: {'id': item.id.toString()},
                        );
                      },
                      icon: const Icon(Icons.payment_rounded, size: 16),
                      label: const Text(
                        'Thanh toán phụ phí',
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
      'PENDING' => (
        'Chờ ký HĐ',
        const Color(0xFFFEF3C7),
        const Color(0xFFD97706),
      ),
      'CONTRACTING' => (
        'Đang ký HĐ',
        const Color(0xFFEDE9FE),
        const Color(0xFF7C3AED),
      ),
      'CONFIRM' => (
        'Đã xác nhận',
        const Color(0xFFECFDF5),
        const Color(0xFF059669),
      ),
      'ONGOING' => (
        'Đang thuê',
        const Color(0xFFEFF6FF),
        const Color(0xFF2563EB),
      ),
      'CHECKING' => (
        'Đang kiểm tra xe',
        const Color(0xFFFFFBEB),
        const Color(0xFFD97706),
      ),
      'PENDING_FEE' => (
        'Chờ quyết toán',
        const Color(0xFFFFFBEB),
        const Color(0xFFD97706),
      ),
      'PENDING_EXTEND_FEE' => (
        'Chờ phí gia hạn',
        const Color(0xFFFFFBEB),
        const Color(0xFFD97706),
      ),
      'OVERDUE' => (
        'Quá hạn trả',
        const Color(0xFFFEF2F2),
        const Color(0xFFDC2626),
      ),
      'COMPLETED' => (
        'Hoàn thành',
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
