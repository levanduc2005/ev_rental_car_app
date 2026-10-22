import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rental_car/core/widgets/widgets.dart';
import 'package:rental_car/features/booking/domain/entities/payos_payment_info_entity.dart';
import 'package:rental_car/features/booking/presentation/utils/booking_formatters.dart';

class StaffPayOSPaymentCard extends StatelessWidget {
  const StaffPayOSPaymentCard({
    super.key,
    required this.payos,
    required this.isSubmitting,
    required this.onRegenerateQr,
    required this.onConfirmPayment,
    required this.onOpenPaymentUrl,
  });

  final PayOSPaymentInfoEntity payos;
  final bool isSubmitting;
  final VoidCallback onRegenerateQr;
  final VoidCallback onConfirmPayment;
  final void Function(String url) onOpenPaymentUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDF4),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFBBF7D0)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF16A34A),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'PayOS VietQR 24/7',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.refresh,
                  size: 20,
                  color: Color(0xFF16A34A),
                ),
                tooltip: 'Tạo lại mã QR',
                onPressed: onRegenerateQr,
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Mã QR VietQR Image
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Builder(
                builder: (context) {
                  var url = payos.qrCodeUrl;
                  if (url.contains('/null-')) {
                    final bin =
                        (payos.bin != null &&
                            payos.bin!.isNotEmpty &&
                            payos.bin != 'null')
                        ? payos.bin!
                        : '970422';
                    url = url.replaceAll('/null-', '/$bin-');
                  }

                  final isSvg = url.endsWith('.svg') || url.contains('.svg?');

                  Widget fallback() => const SizedBox(
                    width: 200,
                    height: 200,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.qr_code_rounded,
                            size: 64,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Mã QR PayOS',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  );

                  if (isSvg) {
                    return SvgPicture.network(
                      url,
                      width: 200,
                      height: 200,
                      placeholderBuilder: (_) => const SizedBox(
                        width: 200,
                        height: 200,
                        child: Center(child: CircularProgressIndicator()),
                      ),
                      errorBuilder: (context, error, stackTrace) => fallback(),
                    );
                  }

                  return Image.network(
                    url,
                    width: 200,
                    height: 200,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      final fallbackData = payos.checkoutUrl;
                      if (fallbackData != null && fallbackData.isNotEmpty) {
                        final qrServerUrl =
                            'https://api.qrserver.com/v1/create-qr-code/?size=200x200&data=${Uri.encodeComponent(fallbackData)}';
                        return Image.network(
                          qrServerUrl,
                          width: 200,
                          height: 200,
                          fit: BoxFit.contain,
                          errorBuilder: (_, _, _) => fallback(),
                        );
                      }
                      return fallback();
                    },
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Khách hàng quét mã trên bất kỳ ứng dụng ngân hàng nào',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11, color: Color(0xFF15803D)),
          ),
          const Divider(height: 20),

          // Chi tiết chuyển khoản
          _buildCopyableRow(
            context,
            'Ngân hàng',
            payos.bankName ?? 'MBBank (Quân Đội)',
          ),
          _buildCopyableRow(
            context,
            'Số tài khoản',
            payos.accountNumber,
            isCopyable: true,
          ),
          _buildCopyableRow(context, 'Chủ tài khoản', payos.accountName),
          _buildCopyableRow(
            context,
            'Số tiền',
            BookingFormatters.formatCurrency(payos.amount.round()),
            highlight: true,
          ),
          _buildCopyableRow(
            context,
            'Nội dung CK',
            payos.description,
            isCopyable: true,
          ),

          if (payos.checkoutUrl != null && payos.checkoutUrl!.isNotEmpty) ...[
            const SizedBox(height: 6),
            TextButton.icon(
              onPressed: () => onOpenPaymentUrl(payos.checkoutUrl!),
              icon: const Icon(Icons.open_in_browser_rounded, size: 16),
              label: const Text(
                'Mở trang thanh toán Web PayOS',
                style: TextStyle(fontSize: 12),
              ),
            ),
          ],

          const SizedBox(height: 12),

          // Nút xác nhận thanh toán PayOS
          AppButton(
            label: isSubmitting
                ? 'Đang xác nhận...'
                : 'Xác nhận khách đã chuyển khoản PayOS',
            icon: Icons.check_circle_outline,
            isLoading: isSubmitting,
            onPressed: onConfirmPayment,
          ),
        ],
      ),
    );
  }

  Widget _buildCopyableRow(
    BuildContext context,
    String label,
    String value, {
    bool isCopyable = false,
    bool highlight = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Color(0xFF475569)),
          ),
          Row(
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: highlight
                      ? const Color(0xFF16A34A)
                      : const Color(0xFF0F172A),
                ),
              ),
              if (isCopyable) ...[
                const SizedBox(width: 4),
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: value));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Đã sao chép $label'),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                  child: const Icon(
                    Icons.copy,
                    size: 14,
                    color: Color(0xFF2563EB),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
