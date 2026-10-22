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
              Expanded(
                child: Text(
                  isRefund ? 'TIỀN CỌC HOÀN LẠI:' : 'TIỀN PHẢI ĐỀN BÙ:',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: isRefund
                        ? const Color(0xFF065F46)
                        : const Color(0xFFDC2626),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                currencyFormat.format(balance.abs()),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isRefund
                      ? const Color(0xFF065F46)
                      : const Color(0xFFDC2626),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            isRefund
                ? 'Hệ thống sẽ hoàn trả tự động số tiền cọc còn lại sau khi khấu trừ về tài khoản ngân hàng của bạn.'
                : 'Tiền cọc bị khấu trừ âm do chi phí hư hại xe và phụ phí trả xe vượt quá tiền cọc. Vui lòng thanh toán số tiền đền bù bên dưới.',
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
