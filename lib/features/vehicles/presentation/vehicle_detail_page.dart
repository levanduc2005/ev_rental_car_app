import 'package:flutter/material.dart';
import 'package:flutter_template/core/theme/app_spacing.dart';
import 'package:flutter_template/core/widgets/widgets.dart';

/// Flow 2: EV Vehicle detail page.
class VehicleDetailPage extends StatelessWidget {
  const VehicleDetailPage({required this.vehicleId, super.key});

  final String vehicleId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết xe #$vehicleId'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Vehicle Image Header
            Container(
              height: 180,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: const Icon(Icons.electric_car, size: 80, color: Colors.blue),
            ),
            const Gap(AppSpacing.md),
            Text(
              'VinFast VF 8 - EV SUV',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const Gap(AppSpacing.xs),
            const Text('Giá thuê: 150.000 VNĐ / giờ'),
            const Gap(AppSpacing.md),

            // Battery Status Card
            AppCard(
              child: Row(
                children: [
                  const Icon(Icons.battery_charging_full, size: 36, color: Colors.green),
                  const Gap(AppSpacing.sm),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Dung lượng Pin hiện tại: 92%',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const Text('Quãng đường di chuyển tối đa: ~350 km'),
                    ],
                  ),
                ],
              ),
            ),
            const Gap(AppSpacing.lg),

            AppButton(
              label: 'Đặt thuê xe ngay',
              onPressed: () {
                context.showSnackBar('Chuyển tới màn hình đặt xe');
              },
            ),
          ],
        ),
      ),
    );
  }
}
