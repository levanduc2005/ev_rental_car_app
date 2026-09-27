import 'package:flutter/material.dart';
import 'package:rental_car/core/theme/app_colors.dart';
import 'package:rental_car/features/booking/presentation/utils/booking_formatters.dart';

/// Card bảng chi tiết thanh toán và chi phí thuê xe
class BookingPaymentBreakdownCard extends StatelessWidget {
  const BookingPaymentBreakdownCard({
    required this.depositFee,
    required this.totalRent,
    required this.collateralFee,
    this.paymentMethod = 'PayOS (VietQR MBBank)',
    this.isDepositPhase = true,
    super.key,
  });

  final int depositFee;
  final int totalRent;
  final int collateralFee;
  final String paymentMethod;
  final bool isDepositPhase;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.payments_outlined, size: 18, color: Color(0xFF2563EB)),
              SizedBox(width: 8),
              Text(
                'Chi tiết chi phí',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const Divider(height: 20),
          _FeeRow(
            label: 'Phí cọc giữ chỗ (thanh toán ngay):',
            amount: BookingFormatters.formatCurrency(depositFee),
            isHighlight: isDepositPhase,
            highlightColor: const Color(0xFF2563EB),
          ),
          const SizedBox(height: 8),
          _FeeRow(
            label: 'Tổng tiền thuê xe dự tính:',
            amount: BookingFormatters.formatCurrency(totalRent),
          ),
          const SizedBox(height: 8),
          _FeeRow(
            label: 'Cọc tài sản thế chấp (khi nhận xe):',
            amount: BookingFormatters.formatCurrency(collateralFee),
            subtitle: 'Hoàn trả 100% sau khi kết thúc chuyến đi',
          ),
          const SizedBox(height: 8),
          _FeeRow(
            label: 'Phương thức thanh toán:',
            amount: paymentMethod,
          ),
          const Divider(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isDepositPhase ? 'Cần thanh toán ngay:' : 'Tổng chi phí chuyến đi:',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                isDepositPhase
                    ? BookingFormatters.formatCurrency(depositFee)
                    : BookingFormatters.formatCurrency(totalRent),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF2563EB),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FeeRow extends StatelessWidget {
  const _FeeRow({
    required this.label,
    required this.amount,
    this.subtitle,
    this.isHighlight = false,
    this.highlightColor,
  });

  final String label;
  final String amount;
  final String? subtitle;
  final bool isHighlight;
  final Color? highlightColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isHighlight ? FontWeight.w600 : FontWeight.normal,
                  color: isHighlight ? AppColors.textPrimary : AppColors.textSecondary,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              amount,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isHighlight ? FontWeight.bold : FontWeight.w600,
                color: isHighlight
                    ? (highlightColor ?? const Color(0xFF2563EB))
                    : AppColors.textPrimary,
              ),
            ),
          ],
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 2),
          Text(
            subtitle!,
            style: const TextStyle(
              fontSize: 10,
              fontStyle: FontStyle.italic,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ],
    );
  }
}
