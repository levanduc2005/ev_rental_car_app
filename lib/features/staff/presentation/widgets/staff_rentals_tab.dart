import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rental_car/core/theme/app_colors.dart';
import 'package:rental_car/core/theme/app_spacing.dart';
import 'package:rental_car/features/profile/domain/entities/rental_detail_entity.dart';
import 'package:rental_car/features/staff/presentation/providers/staff_dashboard_controller.dart';
import 'package:rental_car/features/staff/presentation/providers/staff_providers.dart';
import 'package:rental_car/features/staff/presentation/widgets/staff_rental_card.dart';
import 'package:rental_car/features/staff/presentation/widgets/staff_station_header_card.dart';

class StaffRentalsTab extends ConsumerWidget {
  const StaffRentalsTab({
    super.key,
    required this.onOpenDetail,
    required this.onContinueRental,
  });

  final void Function(RentalDetailEntity rental) onOpenDetail;
  final void Function(RentalDetailEntity rental) onContinueRental;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(staffDashboardControllerProvider);
    final controller = ref.read(staffDashboardControllerProvider.notifier);

    return RefreshIndicator(
      onRefresh: controller.refreshData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (state.staffProfile != null)
              StaffStationHeaderCard(
                profile: state.staffProfile!,
                onRefresh: controller.init,
              ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Hợp đồng thuê thực tế (${state.rentals.length})',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            _buildRentalsList(state),
          ],
        ),
      ),
    );
  }

  Widget _buildRentalsList(StaffDashboardState state) {
    if (state.rentals.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32),
        alignment: Alignment.center,
        child: const Column(
          children: [
            Icon(Icons.car_rental, size: 48, color: Colors.grey),
            SizedBox(height: 10),
            Text(
              'Chưa có đơn thuê nào đang diễn ra tại trạm',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
          ],
        ),
      );
    }

    return Column(
      children: state.rentals
          .map(
            (rental) => StaffRentalCard(
              rental: rental,
              onTapDetail: () => onOpenDetail(rental),
              onTapAction: () => onContinueRental(rental),
            ),
          )
          .toList(),
    );
  }
}
