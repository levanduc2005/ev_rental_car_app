import 'package:flutter/material.dart';
import 'package:rental_car/core/theme/app_colors.dart';
import 'package:rental_car/core/widgets/widgets.dart';
import 'package:rental_car/features/booking/presentation/utils/booking_formatters.dart';
import 'package:rental_car/features/staff/presentation/controllers/staff_handover_controller.dart';
import 'package:rental_car/features/staff/presentation/controllers/staff_handover_state.dart';
import 'package:rental_car/features/staff/presentation/widgets/handover/staff_payos_payment_card.dart';

class StaffStepPayment extends StatelessWidget {
  const StaffStepPayment({
    super.key,
    required this.state,
    required this.controller,
    required this.onOpenPaymentUrl,
  });

  final StaffHandoverState state;
  final StaffHandoverController controller;
  final void Function(String url) onOpenPaymentUrl;

  @override
  Widget build(BuildContext context) {
    final rentFee = (state.rental?.rentFee ?? 0).round();
    final depositAmount = (state.rental?.rentalDepositAmount ?? 0).round();
    final totalAmount = (rentFee + depositAmount) > 0
        ? (rentFee + depositAmount)
        : 500000;
    final isCash = state.paymentMethod == 'CASH';

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
            'Bước 3: Quyết toán thanh toán Check-in',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          const Text(
            'Thu tiền thuê chuyến đi và tiền cọc xe còn lại trước khi bàn giao xe.',
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 14),

          // Bảng tính tiền chi tiết
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Tiền thuê xe:',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      BookingFormatters.formatCurrency(rentFee),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Tiền cọc xe tại trạm:',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      BookingFormatters.formatCurrency(depositAmount),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const Divider(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Tổng cần thu:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    Text(
                      BookingFormatters.formatCurrency(totalAmount),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2563EB),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Chọn phương thức thanh toán
          const Text(
            'Phương thức thanh toán:',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => controller.setPaymentMethod('CASH'),
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isCash ? const Color(0xFFEFF6FF) : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isCash
                            ? const Color(0xFF2563EB)
                            : const Color(0xFFE2E8F0),
                        width: isCash ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.payments_outlined,
                          size: 18,
                          color: isCash
                              ? const Color(0xFF2563EB)
                              : const Color(0xFF64748B),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Tiền mặt tại quầy',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: isCash
                                ? FontWeight.bold
                                : FontWeight.w500,
                            color: isCash
                                ? const Color(0xFF2563EB)
                                : const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: InkWell(
                  onTap: () => controller.setPaymentMethod('PAYOS'),
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 8,
                    ),
                    decoration: BoxDecoration(
                      color: !isCash ? const Color(0xFFEFF6FF) : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: !isCash
                            ? const Color(0xFF2563EB)
                            : const Color(0xFFE2E8F0),
                        width: !isCash ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.qr_code_2_rounded,
                          size: 18,
                          color: !isCash
                              ? const Color(0xFF2563EB)
                              : const Color(0xFF64748B),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Mã QR PayOS',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: !isCash
                                ? FontWeight.bold
                                : FontWeight.w500,
                            color: !isCash
                                ? const Color(0xFF2563EB)
                                : const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Nội dung theo từng phương thức
          if (isCash) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFBEB),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFFDE68A)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline,
                    color: Color(0xFFD97706),
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Nhân viên trực tiếp kiểm đếm đủ ${BookingFormatters.formatCurrency(totalAmount)} tiền mặt từ khách hàng trước khi xác nhận.',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF92400E),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            AppButton(
              label: state.isSubmitting
                  ? 'Đang cập nhật trạng thái...'
                  : 'Xác nhận đã thu tiền mặt tại quầy',
              icon: Icons.payments_outlined,
              isLoading: state.isSubmitting,
              onPressed: controller.confirmCashPayment,
            ),
          ] else ...[
            // Giao diện tạo mã QR PayOS
            if (state.isGeneratingPayOS) ...[
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Column(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 12),
                      Text(
                        'Đang tạo mã thanh toán PayOS VietQR...',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ] else if (state.payosPaymentInfo != null) ...[
              StaffPayOSPaymentCard(
                payos: state.payosPaymentInfo!,
                isSubmitting: state.isSubmitting,
                onRegenerateQr: controller.generatePayOSQr,
                onConfirmPayment: controller.confirmCashPayment,
                onOpenPaymentUrl: onOpenPaymentUrl,
              ),
            ] else ...[
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: controller.generatePayOSQr,
                icon: const Icon(Icons.qr_code_2_rounded),
                label: const Text('Tạo mã thanh toán PayOS VietQR'),
              ),
            ],
          ],

          // Cổng phụ VNPay nếu có URL
          if (state.paymentUrl != null && state.paymentUrl!.isNotEmpty) ...[
            const SizedBox(height: 10),
            Center(
              child: TextButton.icon(
                onPressed: () => onOpenPaymentUrl(state.paymentUrl!),
                icon: const Icon(Icons.open_in_new_rounded, size: 16),
                label: const Text(
                  'Hoặc mở cổng VNPay dự phòng',
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
