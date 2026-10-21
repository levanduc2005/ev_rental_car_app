import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rental_car/core/theme/app_colors.dart';
import 'package:rental_car/core/theme/app_spacing.dart';
import 'package:rental_car/features/profile/domain/entities/rental_detail_entity.dart';
import 'package:rental_car/features/staff/presentation/providers/staff_providers.dart';
import 'package:rental_car/features/staff/presentation/widgets/staff_rental_card.dart';
import 'package:rental_car/features/staff/presentation/widgets/staff_station_header_card.dart';

class StaffRentalsTab extends ConsumerStatefulWidget {
  const StaffRentalsTab({
    super.key,
    required this.onOpenDetail,
    required this.onContinueRental,
    this.onCheckoutRental,
    this.onSettleRental,
  });

  final void Function(RentalDetailEntity rental) onOpenDetail;
  final void Function(RentalDetailEntity rental) onContinueRental;
  final void Function(RentalDetailEntity rental)? onCheckoutRental;
  final void Function(RentalDetailEntity rental)? onSettleRental;

  @override
  ConsumerState<StaffRentalsTab> createState() => _StaffRentalsTabState();
}

class _StaffRentalsTabState extends ConsumerState<StaffRentalsTab> {
  String _selectedFilter =
      'ALL'; // ALL, CHECK_IN, CHECK_OUT, PENDING_FEE, COMPLETED

  List<RentalDetailEntity> _filterRentals(List<RentalDetailEntity> rentals) {
    switch (_selectedFilter) {
      case 'CHECK_IN':
        return rentals.where((r) {
          final s = r.status.toUpperCase();
          return s == 'PENDING' || s == 'CONTRACTING' || s == 'CONFIRM';
        }).toList();
      case 'CHECK_OUT':
        return rentals.where((r) {
          final s = r.status.toUpperCase();
          return s == 'ONGOING' || s == 'OVERDUE';
        }).toList();
      case 'PENDING_FEE':
        return rentals
            .where((r) => r.status.toUpperCase() == 'PENDING_FEE')
            .toList();
      case 'COMPLETED':
        return rentals
            .where((r) => r.status.toUpperCase() == 'COMPLETED')
            .toList();
      default:
        return rentals;
    }
  }

  void _handleAction(RentalDetailEntity rental) {
    final status = rental.status.toUpperCase();
    if (status == 'ONGOING' || status == 'OVERDUE') {
      if (widget.onCheckoutRental != null) {
        widget.onCheckoutRental!(rental);
      } else {
        widget.onContinueRental(rental);
      }
    } else if (status == 'PENDING_FEE') {
      if (widget.onSettleRental != null) {
        widget.onSettleRental!(rental);
      } else {
        widget.onContinueRental(rental);
      }
    } else if (status == 'COMPLETED') {
      widget.onOpenDetail(rental);
    } else {
      widget.onContinueRental(rental);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(staffDashboardControllerProvider);
    final controller = ref.read(staffDashboardControllerProvider.notifier);
    final filteredRentals = _filterRentals(state.rentals);

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

            // Thanh lọc theo phân loại đơn (Check-in, Check-out, Quyết toán)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip(
                    label: 'Tất cả (${state.rentals.length})',
                    filterKey: 'ALL',
                  ),
                  const SizedBox(width: 8),
                  _buildFilterChip(label: 'Chờ nhận xe', filterKey: 'CHECK_IN'),
                  const SizedBox(width: 8),
                  _buildFilterChip(
                    label: 'Chờ trả xe (Out)',
                    filterKey: 'CHECK_OUT',
                  ),
                  const SizedBox(width: 8),
                  _buildFilterChip(
                    label: 'Chờ quyết toán',
                    filterKey: 'PENDING_FEE',
                  ),
                  const SizedBox(width: 8),
                  _buildFilterChip(label: 'Hoàn tất', filterKey: 'COMPLETED'),
                ],
              ),
            ),
            const SizedBox(height: 14),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Hợp đồng thuê thực tế (${filteredRentals.length})',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            _buildRentalsList(filteredRentals),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip({required String label, required String filterKey}) {
    final isSelected = _selectedFilter == filterKey;
    return FilterChip(
      selected: isSelected,
      label: Text(label),
      labelStyle: TextStyle(
        fontSize: 12,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        color: isSelected ? const Color(0xFF2563EB) : const Color(0xFF64748B),
      ),
      backgroundColor: Colors.white,
      selectedColor: const Color(0xFFEFF6FF),
      checkmarkColor: const Color(0xFF2563EB),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected ? const Color(0xFF2563EB) : const Color(0xFFE2E8F0),
        ),
      ),
      onSelected: (_) {
        setState(() {
          _selectedFilter = filterKey;
        });
      },
    );
  }

  Widget _buildRentalsList(List<RentalDetailEntity> rentals) {
    if (rentals.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32),
        alignment: Alignment.center,
        child: const Column(
          children: [
            Icon(Icons.car_rental, size: 48, color: Colors.grey),
            SizedBox(height: 10),
            Text(
              'Không có đơn thuê nào theo bộ lọc này',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
          ],
        ),
      );
    }

    return Column(
      children: rentals
          .map(
            (rental) => StaffRentalCard(
              rental: rental,
              onTapDetail: () => widget.onOpenDetail(rental),
              onTapAction: () => _handleAction(rental),
            ),
          )
          .toList(),
    );
  }
}
