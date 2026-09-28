import 'package:flutter/material.dart';
import 'package:rental_car/core/theme/app_colors.dart';
import 'package:rental_car/features/booking/presentation/utils/booking_formatters.dart';

/// Card tóm tắt đơn thuê & lộ trình thanh toán 2 bước (Chuẩn stitch_booking.html)
class BookingOrderSummaryCard extends StatelessWidget {
  const BookingOrderSummaryCard({
    required this.reservationCode,
    required this.vehicleName,
    this.vehicleImageUrl,
    required this.renterName,
    required this.renterPhone,
    required this.startDateTime,
    required this.endDateTime,
    required this.totalRent,
    required this.depositFee,
    required this.collateralFee,
    super.key,
  });

  final String reservationCode;
  final String vehicleName;
  final String? vehicleImageUrl;
  final String renterName;
  final String renterPhone;
  final DateTime startDateTime;
  final DateTime endDateTime;
  final int totalRent;
  final int depositFee;
  final int collateralFee;

  static const String _defaultCarImage =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuDiVxOjLTj5JjghKDMPBd4UdJ_tVbMRIeMLtOgIdtKfkOojv_PO48hcEhHu1lCas852tOakhx5EzvZJr18RncORxAd4wzE7iOCrGu_pPeT-2UMEUMKEpG3yg41U4Hlgx7U25hQTa-DQRn9VBaL14InoB6SsnBprAJMduwVP7G4v3VwNRuYGwPChVd6ICkoZKdZb8VD9ArMtDvKRmJ_hfeO9hL7cMcvEW-Tl6bD6UBZ3wkMr1XAQC9z4mSM3WB7MLeiiIcw';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'Thông tin đơn thuê',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),

          // Car Photo with Name Badge
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  vehicleImageUrl ?? _defaultCarImage,
                  width: double.infinity,
                  height: 160,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => Container(
                    height: 160,
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.directions_car, size: 60),
                  ),
                ),
              ),
              Positioned(
                bottom: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    vehicleName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Rental Attributes List
          _AttributeRow(
            label: 'Mã đặt xe',
            value: reservationCode,
            isMono: true,
          ),
          const Divider(height: 16),
          _AttributeRow(label: 'Tên khách thuê', value: renterName),
          const Divider(height: 16),
          _AttributeRow(label: 'Số điện thoại', value: renterPhone),
          const Divider(height: 16),
          _AttributeRow(
            label: 'Ngày nhận',
            value: BookingFormatters.formatDateTime(startDateTime),
          ),
          const Divider(height: 16),
          _AttributeRow(
            label: 'Ngày trả',
            value: BookingFormatters.formatDateTime(endDateTime),
          ),
          const Divider(height: 16),
          _AttributeRow(label: 'Loại xe', value: vehicleName, isBold: true),
          const Divider(height: 20, thickness: 1.5),

          // Total Rental Price to pay upon pick-up
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tổng cộng tiền thuê xe',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    'Bạn sẽ thanh toán khi nhận xe',
                    style: TextStyle(
                      fontSize: 10,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              Text(
                BookingFormatters.formatCurrency(totalRent),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 2-Step Payment Schedule Roadmap
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFBEB),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFFDE68A)),
            ),
            child: Column(
              children: [
                // Step 1: Deposit
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 22,
                      height: 22,
                      decoration: const BoxDecoration(
                        color: Color(0xFF2563EB),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text(
                          '1',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Thanh toán giữ chỗ qua e-Motion',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              Text(
                                BookingFormatters.formatCurrency(depositFee),
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2563EB),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'Tiền này để xác nhận đơn thuê và giữ xe, sẽ được trừ vào tiền thế chấp khi nhận xe.',
                            style: TextStyle(
                              fontSize: 10,
                              color: AppColors.textSecondary,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      height: 16,
                      child: VerticalDivider(
                        color: Color(0xFFCBD5E1),
                        thickness: 1.5,
                      ),
                    ),
                  ),
                ),

                // Step 2: Final Payment Upon Pick-up
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 22,
                      height: 22,
                      decoration: const BoxDecoration(
                        color: Color(0xFF2563EB),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text(
                          '2',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Thanh toán khi nhận xe',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              Text(
                                BookingFormatters.formatCurrency(
                                  totalRent + collateralFee - depositFee,
                                ),
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                '• Tiền thuê:',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              Text(
                                BookingFormatters.formatCurrency(totalRent),
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                '• Tiền thế chấp:',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              Text(
                                BookingFormatters.formatCurrency(collateralFee),
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AttributeRow extends StatelessWidget {
  const _AttributeRow({
    required this.label,
    required this.value,
    this.isMono = false,
    this.isBold = false,
  });

  final String label;
  final String value;
  final bool isMono;
  final bool isBold;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            fontFamily: isMono ? 'monospace' : null,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
