import 'package:flutter/material.dart';
import 'package:flutter_template/core/theme/app_spacing.dart';
import 'package:flutter_template/core/widgets/widgets.dart';

/// Flow 2: Map Search page displaying EV cars and charging stations.
class MapSearchPage extends StatelessWidget {
  const MapSearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bản đồ Xe điện & Trạm sạc'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              context.showSnackBar('Bộ lọc: Pin > 80%, Loại xe SUV');
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Map Placeholder
          Container(
            color: Colors.blueGrey.shade100,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.map_outlined, size: 64, color: Colors.blueGrey),
                  const Gap(AppSpacing.sm),
                  Text(
                    'Khu vực hiển thị Bản đồ (Google Maps / Flutter Map)',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),
          ),
          // Floating Info Sheet at the bottom
          Positioned(
            left: AppSpacing.md,
            right: AppSpacing.md,
            bottom: AppSpacing.md,
            child: AppCard(
              child: Row(
                children: [
                  const Icon(Icons.electric_car, size: 40, color: Colors.green),
                  const Gap(AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'VF e34 - Xe điện 5 chỗ',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        Text(
                          'Pin: 88% SoC (Chạy được ~280 km)',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  AppButton(
                    label: 'Xem xe',
                    onPressed: () {
                      context.showSnackBar('Xem chi tiết xe VF e34');
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
