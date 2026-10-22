import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:rental_car/core/theme/app_colors.dart';
import 'package:rental_car/features/booking/presentation/utils/booking_formatters.dart';
import 'package:rental_car/features/profile/domain/entities/rental_detail_entity.dart';

class RentalFinancialCard extends StatelessWidget {
  const RentalFinancialCard({required this.rental, super.key});

  final RentalDetailEntity rental;

  @override
  Widget build(BuildContext context) {
    final checkOut = rental.checkOutChecklist;
    final checkIn = rental.checkInChecklist;
    final checkOutFee = checkOut?.fee ?? 0.0;

    // Tính toán chi tiết phạt pin và trễ giờ nếu có biên bản trả xe
    double batteryFee = 0.0;
    int batteryDeficit = 0;
    if (checkOut != null && checkIn != null) {
      final batteryDiff = checkOut.currentBattery - checkIn.currentBattery;
      if (batteryDiff < 0) {
        batteryDeficit = batteryDiff.abs().toInt();
        batteryFee = batteryDeficit * 12000.0;
      }
    }
    if (batteryFee > checkOutFee) {
      batteryFee = checkOutFee;
    }
    final lateFee = math.max(0.0, checkOutFee - batteryFee);

    final vehicleDamageCost = rental.vehicleDamageCost;
    final totalDeductions = checkOutFee + vehicleDamageCost;
    final totalDeposit = rental.totalDeposit;
    final remainingDeposit = totalDeposit - totalDeductions;
    final isNegative = remainingDeposit < 0;

    final hasDeductions =
        totalDeductions > 0 ||
        rental.isChecking ||
        rental.isPendingFee ||
        rental.isCompleted;

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Chi phí & Quyết toán cọc',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: rental.isCompleted
                      ? (isNegative
                            ? const Color(0xFFFEF2F2)
                            : const Color(0xFFF0FDF4))
                      : const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  rental.isCompleted
                      ? (isNegative
                            ? 'Đã quyết toán (Đền bù)'
                            : 'Đã quyết toán hoàn cọc')
                      : (rental.isPendingFee
                            ? 'Chờ thanh toán phụ phí'
                            : 'Đang giữ cọc'),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: rental.isCompleted
                        ? (isNegative
                              ? const Color(0xFFDC2626)
                              : const Color(0xFF16A34A))
                        : (rental.isPendingFee
                              ? const Color(0xFFD97706)
                              : const Color(0xFF2563EB)),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // 1. Tiền thuê xe
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Tiền thuê xe',
                style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
              Text(
                BookingFormatters.formatCurrency(rental.rentFee.toInt()),
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),

          if (rental.discountPoint > 0) ...[
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Giảm giá tích điểm',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  '-${rental.discountPoint} điểm',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF16A34A),
                  ),
                ),
              ],
            ),
          ],

          const Divider(height: 20),

          // 2. Tiền cọc ban đầu
          if (rental.reservationDepositAmount > 0) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Tiền cọc giữ chỗ',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  BookingFormatters.formatCurrency(
                    rental.reservationDepositAmount.toInt(),
                  ),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
          ],

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Tiền cọc nhận xe (Collateral)',
                style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
              Text(
                BookingFormatters.formatCurrency(
                  rental.rentalDepositAmount.toInt(),
                ),
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Tổng tiền cọc ban đầu',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              Text(
                BookingFormatters.formatCurrency(totalDeposit.toInt()),
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2563EB),
                ),
              ),
            ],
          ),

          // 3. Các khoản phạt & Khấu trừ từ tiền cọc
          if (hasDeductions) ...[
            const Divider(height: 24),
            const Text(
              'Các khoản phạt & Khấu trừ từ cọc:',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 8),

            if (lateFee > 0) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '• Phạt trả xe trễ giờ:',
                    style: TextStyle(fontSize: 13, color: Color(0xFFDC2626)),
                  ),
                  Text(
                    '-${BookingFormatters.formatCurrency(lateFee.toInt())}',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFDC2626),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
            ],

            if (batteryFee > 0) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '• Phạt hao hụt pin ($batteryDeficit%):',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFFDC2626),
                    ),
                  ),
                  Text(
                    '-${BookingFormatters.formatCurrency(batteryFee.toInt())}',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFDC2626),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
            ],

            if (checkOutFee > 0 && lateFee == 0 && batteryFee == 0) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '• Phụ phí biên bản trả xe:',
                    style: TextStyle(fontSize: 13, color: Color(0xFFDC2626)),
                  ),
                  Text(
                    '-${BookingFormatters.formatCurrency(checkOutFee.toInt())}',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFDC2626),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
            ],

            if (vehicleDamageCost > 0) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '• Phí sự cố hư hại (VehicleLog):',
                    style: TextStyle(fontSize: 13, color: Color(0xFFDC2626)),
                  ),
                  Text(
                    '-${BookingFormatters.formatCurrency(vehicleDamageCost.toInt())}',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFDC2626),
                    ),
                  ),
                ],
              ),
              if (rental.vehicleDamages.isNotEmpty) ...[
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF2F2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFFECDD3)),
                  ),
                  child: Column(
                    children: rental.vehicleDamages.map((item) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                '- ${item.description}',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF991B1B),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              '-${BookingFormatters.formatCurrency(item.cost.toInt())}',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFDC2626),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
              const SizedBox(height: 6),
            ],

            if (totalDeductions == 0 && rental.isCompleted) ...[
              const Text(
                'Không phát sinh phụ phí trễ giờ, pin hay hư hại xe.',
                style: TextStyle(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                  color: Color(0xFF16A34A),
                ),
              ),
              const SizedBox(height: 6),
            ],

            const SizedBox(height: 8),

            // 4. Kết quả quyết toán cọc
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isNegative
                    ? const Color(0xFFFEF2F2)
                    : const Color(0xFFECFDF5),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isNegative
                      ? const Color(0xFFFECACA)
                      : const Color(0xFFA7F3D0),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isNegative ? 'TIỀN PHẢI ĐỀN BÙ:' : 'TIỀN CỌC HOÀN LẠI:',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: isNegative
                              ? const Color(0xFFDC2626)
                              : const Color(0xFF065F46),
                        ),
                      ),
                      Text(
                        isNegative
                            ? BookingFormatters.formatCurrency(
                                remainingDeposit.abs().toInt(),
                              )
                            : '+${BookingFormatters.formatCurrency(remainingDeposit.toInt())}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isNegative
                              ? const Color(0xFFDC2626)
                              : const Color(0xFF065F46),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isNegative
                        ? 'Tiền cọc bị khấu trừ âm do chi phí sự cố hư hại & phụ phí vượt quá tiền cọc. Vui lòng thanh toán số tiền đền bù.'
                        : 'Tiền cọc sau khi trừ các phụ phí (nếu có) được hoàn trả tự động về tài khoản ngân hàng.',
                    style: TextStyle(
                      fontSize: 11,
                      color: isNegative
                          ? const Color(0xFFB91C1C)
                          : const Color(0xFF047857),
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
