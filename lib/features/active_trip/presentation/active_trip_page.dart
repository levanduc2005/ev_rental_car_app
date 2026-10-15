import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rental_car/app/router/app_routes.dart';
import 'package:rental_car/core/theme/app_spacing.dart';
import 'package:rental_car/core/widgets/widgets.dart';
import 'package:rental_car/features/emergency/presentation/widgets/sos_emergency_button.dart';

/// Flow 3: Active Trip dashboard page (Real-time timer & Remote Lock/Unlock).
class ActiveTripPage extends StatelessWidget {
  const ActiveTripPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chuyến đi đang hoạt động'),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.sos_rounded,
              color: Color(0xFFDC2626),
              size: 28,
            ),
            tooltip: 'Cứu hộ khẩn cấp (SOS)',
            onPressed: () {
              context.push(AppRoute.emergencyReport.path);
            },
          ),
        ],
      ),
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
            const Gap(AppSpacing.lg),

            // Emergency SOS Button
            const SosEmergencyButton(),
            const Gap(AppSpacing.md),

            // End Trip Button
            AppButton(
              label: 'Kết thúc chuyến đi & Trả xe',
              variant: AppButtonVariant.secondary,
              onPressed: () {
                context.pushNamed(AppRoute.returnLocationVerification.name);
              },
            ),
          ],
        ),
      ),
    );
  }
}
