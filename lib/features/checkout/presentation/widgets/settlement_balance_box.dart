import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SettlementBalanceBox extends StatelessWidget {
  const SettlementBalanceBox({super.key, required this.balance});

  final double balance;

  @override
  Widget build(BuildContext context) {
    final isRefund = balance >= 0;
    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isRefund ? const Color(0xFFECFDF5) : const Color(0xFFFEF2F2),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isRefund ? const Color(0xFFA7F3D0) : const Color(0xFFFECACA),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isRefund
                    ? 'TIỀN CỌC HOÀN LẠI THỰC NHẬN:'
                    : 'SỐ TIỀN CẦN THANH TOÁN THÊM:',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: isRefund
                      ? const Color(0xFF065F46)
                      : const Color(0xFF991B1B),
                ),
              ),
              Text(
                currencyFormat.format(balance.abs()),
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: isRefund
                      ? const Color(0xFF065F46)
                      : const Color(0xFF991B1B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            isRefund
                ? 'Hệ thống sẽ hoàn trả tự động số tiền cọc còn lại về tài khoản ngân hàng của bạn.'
                : 'Phụ phí phát sinh vượt quá tiền cọc, vui lòng bấm bên dưới để thanh toán nốt phần chênh lệch.',
            style: TextStyle(
              fontSize: 11,
              color: isRefund
                  ? const Color(0xFF047857)
                  : const Color(0xFFB91C1C),
            ),
          ),
        ],
      ),
    );
  }
}
