import 'package:flutter/material.dart';
import 'package:rental_car/core/theme/app_spacing.dart';
import 'package:rental_car/core/widgets/widgets.dart';

/// Flow 3: Active Trip dashboard page (Real-time timer & Remote Lock/Unlock).
class ActiveTripPage extends StatelessWidget {
  const ActiveTripPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chuyến đi đang hoạt động')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            // Timer & Status Card
            AppCard(
              child: Column(
                children: [
                  Text(
                    '01:45:20',
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const Text('Thời gian đã di chuyển'),
                  const Divider(),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Số tiền hiện tại:'),
                      Text(
                        '262.500 VNĐ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Gap(AppSpacing.lg),

            // Remote Control Buttons
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    label: 'Mở cửa xe',
                    icon: Icons.lock_open,
                    onPressed: () {
                      context.showSnackBar(
                        'Đã gửi lệnh MỞ KHÓA xe qua Bluetooth/IoT',
                      );
                    },
                  ),
                ),
                const Gap(AppSpacing.md),
                Expanded(
                  child: AppButton(
                    label: 'Khóa cửa xe',
                    icon: Icons.lock,
                    variant: AppButtonVariant.outline,
                    onPressed: () {
                      context.showSnackBar(
                        'Đã gửi lệnh KHÓA xe qua Bluetooth/IoT',
                      );
                    },
                  ),
                ),
              ],
            ),
            const Gap(AppSpacing.xl),

            // End Trip Button
            AppButton(
              label: 'Kết thúc chuyến đi & Trả xe',
              onPressed: () {
                context.showSnackBar('Chuyển sang màn hình Thanh toán');
              },
            ),
          ],
        ),
      ),
    );
  }
}
