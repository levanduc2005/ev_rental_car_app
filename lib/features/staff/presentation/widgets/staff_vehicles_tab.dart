import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rental_car/core/theme/app_colors.dart';
import 'package:rental_car/core/theme/app_spacing.dart';
import 'package:rental_car/features/staff/presentation/providers/staff_providers.dart';
import 'package:rental_car/features/staff/presentation/widgets/staff_vehicle_card.dart';

class StaffVehiclesTab extends ConsumerWidget {
  const StaffVehiclesTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(staffDashboardControllerProvider);
    final controller = ref.read(staffDashboardControllerProvider.notifier);

    final availableCount = state.vehicles
        .where((v) => v.status == 'AVAILABLE')
        .length;
    final rentingCount = state.vehicles
        .where((v) => v.status == 'RENTING' || v.status == 'ONGOING')
        .length;

    return RefreshIndicator(
      onRefresh: controller.fetchStationVehicles,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Station summary cards
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem(
                    'Tổng xe',
                    '${state.vehicles.length}',
                    const Color(0xFF2563EB),
                  ),
                  Container(
                    height: 32,
                    width: 1,
                    color: const Color(0xFFE2E8F0),
                  ),
                  _buildStatItem(
                    'Sẵn sàng',
                    '$availableCount',
                    const Color(0xFF059669),
                  ),
                  Container(
                    height: 32,
                    width: 1,
                    color: const Color(0xFFE2E8F0),
                  ),
                  _buildStatItem(
                    'Đang thuê',
                    '$rentingCount',
                    const Color(0xFFD97706),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            if (state.isLoadingVehicles)
              const Padding(
                padding: EdgeInsets.all(32),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (state.vehicles.isEmpty)
              Container(
                padding: const EdgeInsets.all(32),
                alignment: Alignment.center,
                child: const Column(
                  children: [
                    Icon(
                      Icons.directions_car_filled_outlined,
                      size: 48,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Hiện không có thông tin xe tại trạm này',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              )
            else
              ...state.vehicles.map((v) => StaffVehicleCard(vehicle: v)),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
        ),
      ],
    );
  }
}
