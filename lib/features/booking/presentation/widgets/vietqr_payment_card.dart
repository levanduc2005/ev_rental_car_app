import 'package:flutter/material.dart';
import 'package:rental_car/core/theme/app_colors.dart';
import 'package:rental_car/features/booking/domain/entities/payos_payment_info_entity.dart';
import 'package:rental_car/features/booking/presentation/utils/booking_formatters.dart';

/// Card hiển thị Mã QR VietQR MBBank và Bảng thông tin chuyển khoản PayOS
/// Được thiết kế dạng Accordion thu gọn mặc định (Phương án 2A)
class VietQRPaymentCard extends StatefulWidget {
  const VietQRPaymentCard({
    required this.paymentInfo,
    required this.onCopy,
    this.beneficiaryBankName,
    this.initiallyExpanded = false,
    super.key,
  });

  final PayOSPaymentInfoEntity paymentInfo;
  final void Function(String text, String label) onCopy;
  final String? beneficiaryBankName;
  final bool initiallyExpanded;

  @override
  State<VietQRPaymentCard> createState() => _VietQRPaymentCardState();
}

class _VietQRPaymentCardState extends State<VietQRPaymentCard> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
          // Accordion Header (Click để đóng/mở)
          InkWell(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: _isExpanded ? const Color(0xFFF8FAFC) : Colors.white,
                borderRadius: _isExpanded
                    ? const BorderRadius.vertical(top: Radius.circular(16))
                    : BorderRadius.circular(16),
                border: _isExpanded
                    ? const Border(bottom: BorderSide(color: Color(0xFFF1F5F9)))
                    : null,
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
                          Icons.qr_code_2,
                          color: Color(0xFF2563EB),
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Quét mã QR / Chuyển thủ công',
                            style: TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _isExpanded
                                ? 'Nhấn để thu gọn'
                                : 'Dùng điện thoại khác quét hoặc sao chép STK',
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  AnimatedRotation(
                    turns: _isExpanded ? 0.5 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    child: Container(
                      width: 26,
                      height: 26,
                      decoration: BoxDecoration(
                        color: _isExpanded
                            ? const Color(0xFF2563EB)
                            : const Color(0xFFF1F5F9),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        color: _isExpanded
                            ? Colors.white
                            : const Color(0xFF64748B),
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Accordion Content: Hiện ra khi người dùng chủ động mở (Phương án 2A)
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text(
                    'Mã VietQR thanh toán PayOS',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Quét mã bằng app ngân hàng bất kỳ để thanh toán',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11.5,
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
                        widget.paymentInfo.qrCodeUrl,
                        width: 240,
                        fit: BoxFit.contain,
                        loadingBuilder: (_, child, progress) {
                          if (progress == null) return child;
                          return const SizedBox(
                            width: 240,
                            height: 240,
                            child: Center(child: CircularProgressIndicator()),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 240,
                          height: 240,
                          color: Colors.grey.shade100,
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.qr_code, size: 70, color: Colors.grey),
                              SizedBox(height: 8),
                              Text(
                                'Mã QR thanh toán PayOS',
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Nút Lưu mã QR
                  TextButton.icon(
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFFEFF6FF),
                      foregroundColor: const Color(0xFF2563EB),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
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
                    icon: const Icon(Icons.download, size: 15),
                    label: const Text(
                      'Lưu mã QR vào máy',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Divider Hoặc
                  const Row(
                    children: [
                      Expanded(child: Divider()),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          'Hoặc chuyển khoản thủ công',
                          style: TextStyle(fontSize: 11, color: Colors.grey),
                        ),
                      ),
                      Expanded(child: Divider()),
                    ],
                  ),
                  const SizedBox(height: 12),

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
                          label: 'Số tiền cọc:',
                          value: BookingFormatters.formatCurrency(
                            widget.paymentInfo.depositFee,
                          ),
                          copyText: widget.paymentInfo.depositFee.toString(),
                          onCopy: () => widget.onCopy(
                            widget.paymentInfo.depositFee.toString(),
                            'Số tiền',
                          ),
                        ),
                        const Divider(height: 14, color: Color(0xFFFEF3C7)),
                        _CopyRow(
                          label: 'Nội dung chuyển khoản (bắt buộc đúng):',
                          value: widget.paymentInfo.description,
                          copyText: widget.paymentInfo.description,
                          isMono: true,
                          valueColor: const Color(0xFFDC2626),
                          onCopy: () => widget.onCopy(
                            widget.paymentInfo.description,
                            'Nội dung chuyển khoản',
                          ),
                        ),
                        const Divider(height: 14, color: Color(0xFFFEF3C7)),
                        _CopyRow(
                          label: 'Số tài khoản thụ hưởng:',
                          value: widget.paymentInfo.accountNumber,
                          copyText: widget.paymentInfo.accountNumber,
                          isMono: true,
                          onCopy: () => widget.onCopy(
                            widget.paymentInfo.accountNumber,
                            'Số tài khoản',
                          ),
                        ),
                        const Divider(height: 14, color: Color(0xFFFEF3C7)),
                        _CopyRow(
                          label: 'Chủ tài khoản:',
                          value: widget.paymentInfo.accountName,
                          copyText: widget.paymentInfo.accountName,
                          onCopy: () => widget.onCopy(
                            widget.paymentInfo.accountName,
                            'Chủ tài khoản',
                          ),
                        ),
                        const Divider(height: 14, color: Color(0xFFFEF3C7)),
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
                                widget.beneficiaryBankName ??
                                    widget.paymentInfo.bankName ??
                                    'Ngân hàng thụ hưởng',
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
            crossFadeState: _isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 250),
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
    this.valueColor,
  });

  final String label;
  final String value;
  final String copyText;
  final VoidCallback onCopy;
  final bool isMono;
  final Color? valueColor;

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
                  color: valueColor ?? AppColors.textPrimary,
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
