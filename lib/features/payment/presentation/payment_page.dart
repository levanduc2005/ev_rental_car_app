import 'package:flutter/material.dart';
import 'package:flutter_template/core/theme/app_spacing.dart';
import 'package:flutter_template/core/widgets/widgets.dart';

/// Flow 3: Payment page for final invoice checkout.
class PaymentPage extends StatelessWidget {
  const PaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thanh toán Hóa đơn'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Chi tiết hóa đơn #INV-8829', style: TextStyle(fontWeight: FontWeight.bold)),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Tiền thuê xe (2h 15m):'),
                      Text('337.500 VNĐ'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Bảo hiểm chuyến đi:'),
                      Text('30.000 VNĐ'),
                    ],
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Tổng cộng:', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('367.500 VNĐ', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                    ],
                  ),
                ],
              ),
            ),
            const Spacer(),
            AppButton(
              label: 'Thanh toán qua Ví MoMo / VNPay',
              onPressed: () {
                context.showSnackBar('Thanh toán thành công! Cảm ơn bạn đã sử dụng dịch vụ.');
              },
            ),
          ],
        ),
      ),
    );
  }
}
