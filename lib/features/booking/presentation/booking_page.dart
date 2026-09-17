import 'package:flutter/material.dart';
import 'package:rental_car/core/theme/app_spacing.dart';
import 'package:rental_car/core/widgets/widgets.dart';

/// Flow 2: Booking page for selecting times and confirming rental.
class BookingPage extends StatelessWidget {
  const BookingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Xác nhận Đặt xe')),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Thông tin lịch thuê:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Gap(AppSpacing.xs),
                  Text('Bắt đầu: Hôm nay 14:00'),
                  Text('Kết thúc: Hôm nay 18:00 (4 tiếng)'),
                  Divider(),
                  Text('Tổng chi phí dự kiến: 600.000 VNĐ'),
                ],
              ),
            ),
            const Spacer(),
            AppButton(
              label: 'Xác nhận Đặt xe',
              onPressed: () {
                context.showSnackBar(
                  'Đã đặt xe thành công! Hãy tới vị trí xe để mở khóa.',
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
