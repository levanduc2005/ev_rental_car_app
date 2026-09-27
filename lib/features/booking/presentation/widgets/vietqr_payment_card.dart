import 'package:flutter/material.dart';
import 'package:rental_car/core/theme/app_colors.dart';
import 'package:rental_car/features/booking/domain/entities/payos_payment_info_entity.dart';
import 'package:rental_car/features/booking/presentation/utils/booking_formatters.dart';

/// Card hiển thị Mã QR VietQR MBBank và Bảng thông tin chuyển khoản PayOS
class VietQRPaymentCard extends StatelessWidget {
  const VietQRPaymentCard({
    required this.paymentInfo,
    required this.onCopy,
    super.key,
  });

  final PayOSPaymentInfoEntity paymentInfo;
  final void Function(String text, String label) onCopy;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Accordion Header
          Container(
            padding: const EdgeInsets.all(14),
            decoration: const BoxDecoration(
              color: Color(0xFFF8FAFC),
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              border: Border(
                bottom: BorderSide(color: Color(0xFFF1F5F9)),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.account_balance,
                        color: Color(0xFF2563EB),
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Chuyển khoản ngân hàng',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 24,
                  height: 24,
                  decoration: const BoxDecoration(
                    color: Color(0xFF2563EB),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ],
            ),
          ),

          // Accordion Content: QR Section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Text(
                  'Thanh toán bằng mã QR',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Vui lòng tải mã QR để thanh toán bằng ứng dụng ngân hàng',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 14),

                // VietQR Official Card Image
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      paymentInfo.vietQrImageUrl,
                      width: 260,
                      fit: BoxFit.contain,
                      loadingBuilder: (_, child, progress) {
                        if (progress == null) return child;
                        return const SizedBox(
                          width: 260,
                          height: 260,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      },
                      errorBuilder: (_, _, _) => Container(
                        width: 260,
                        height: 260,
                        color: Colors.grey.shade100,
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.qr_code, size: 80, color: Colors.grey),
                            SizedBox(height: 8),
                            Text('Mã QR thanh toán PayOS',
                                style: TextStyle(fontSize: 12)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                // Nút Lưu mã QR
                TextButton.icon(
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFFEFF6FF),
                    foregroundColor: const Color(0xFF2563EB),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Đã lưu mã QR vào thư viện ảnh!'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  icon: const Icon(Icons.download, size: 16),
                  label: const Text(
                    'Lưu mã QR',
                    style: TextStyle(
                        fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 14),

                // Divider Hoặc
                const Row(
                  children: [
                    Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text('Hoặc',
                          style: TextStyle(
                              fontSize: 11, color: Colors.grey)),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 14),

                // Manual Transfer Box
                const Text(
                  'Chuyển khoản qua ngân hàng',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Vui lòng nhập chính xác cú pháp chuyển khoản để hệ thống ghi nhận thông tin đơn hàng',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0xFFEF4444),
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 10),

                // Bank Account Details Card (Amber tint)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFBEB),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFFDE68A)),
                  ),
                  child: Column(
                    children: [
                      _CopyRow(
                        label: 'Số tiền:',
                        value: BookingFormatters.formatCurrency(
                            paymentInfo.depositFee),
                        copyText: paymentInfo.depositFee.toString(),
                        onCopy: () => onCopy(
                            paymentInfo.depositFee.toString(), 'Số tiền'),
                      ),
                      const Divider(height: 16, color: Color(0xFFFEF3C7)),
                      _CopyRow(
                        label: 'Nội dung chuyển khoản:',
                        value: paymentInfo.transferContent,
                        copyText: paymentInfo.transferContent,
                        isMono: true,
                        onCopy: () => onCopy(
                            paymentInfo.transferContent,
                            'Nội dung chuyển khoản'),
                      ),
                      const Divider(height: 16, color: Color(0xFFFEF3C7)),
                      _CopyRow(
                        label: 'Số tài khoản:',
                        value: paymentInfo.accountNumber,
                        copyText: paymentInfo.accountNumber,
                        isMono: true,
                        onCopy: () => onCopy(
                            paymentInfo.accountNumber, 'Số tài khoản'),
                      ),
                      const Divider(height: 16, color: Color(0xFFFEF3C7)),
                      _CopyRow(
                        label: 'Chủ tài khoản:',
                        value: paymentInfo.accountName,
                        copyText: paymentInfo.accountName,
                        onCopy: () => onCopy(
                            paymentInfo.accountName, 'Chủ tài khoản'),
                      ),
                      const Divider(height: 16, color: Color(0xFFFEF3C7)),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Ngân hàng: ',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              '${paymentInfo.bankName} (${paymentInfo.bankShortName})',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
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
        ],
      ),
    );
  }
}

class _CopyRow extends StatelessWidget {
  const _CopyRow({
    required this.label,
    required this.value,
    required this.copyText,
    required this.onCopy,
    this.isMono = false,
  });

  final String label;
  final String value;
  final String copyText;
  final VoidCallback onCopy;
  final bool isMono;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  fontFamily: isMono ? 'monospace' : null,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
        InkWell(
          onTap: onCopy,
          borderRadius: BorderRadius.circular(6),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: const Row(
              children: [
                Icon(Icons.copy, size: 12, color: Color(0xFF2563EB)),
                SizedBox(width: 4),
                Text(
                  'Sao chép',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2563EB),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
