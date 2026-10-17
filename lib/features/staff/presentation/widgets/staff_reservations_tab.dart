import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rental_car/core/theme/app_colors.dart';
import 'package:rental_car/core/theme/app_spacing.dart';
import 'package:rental_car/features/booking/domain/entities/reservation_entity.dart';
import 'package:rental_car/features/staff/presentation/providers/staff_dashboard_controller.dart';
import 'package:rental_car/features/staff/presentation/providers/staff_providers.dart';
import 'package:rental_car/features/staff/presentation/widgets/staff_reservation_card.dart';
import 'package:rental_car/features/staff/presentation/widgets/staff_station_header_card.dart';

class StaffReservationsTab extends ConsumerStatefulWidget {
  const StaffReservationsTab({super.key, required this.onStartHandover});

  final void Function(ReservationEntity reservation) onStartHandover;

  @override
  ConsumerState<StaffReservationsTab> createState() =>
      _StaffReservationsTabState();
}

class _StaffReservationsTabState extends ConsumerState<StaffReservationsTab> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            _buildSearchBar(controller, state),
            const SizedBox(height: 14),
            if (state.searchQuery.isNotEmpty)
              _buildSearchResults(state)
            else
              _buildReservationsList(state),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(
    StaffDashboardController controller,
    StaffDashboardState state,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x06000000),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        onChanged: controller.search,
        decoration: InputDecoration(
          hintText: 'Tìm theo mã đơn (VD: 790123, 444220)...',
          hintStyle: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
          prefixIcon: const Icon(Icons.search, color: Color(0xFF2563EB)),
          suffixIcon: state.searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, size: 18),
                  onPressed: () {
                    _searchController.clear();
                    controller.clearSearch();
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildSearchResults(StaffDashboardState state) {
    if (state.isSearching) {
      return const Padding(
        padding: EdgeInsets.all(24),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (state.searchResults.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        alignment: Alignment.center,
        child: Column(
          children: [
            const Icon(Icons.search_off, size: 48, color: Colors.grey),
            const SizedBox(height: 8),
            Text(
              'Không tìm thấy đơn nào khớp mã "${state.searchQuery}"',
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Kết quả tìm kiếm (${state.searchResults.length} đơn):',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),
        const SizedBox(height: 10),
        ...state.searchResults.map(
          (res) => StaffReservationCard(
            reservation: res,
            onStartHandover: () => widget.onStartHandover(res),
          ),
        ),
      ],
    );
  }

  Widget _buildReservationsList(StaffDashboardState state) {
    if (state.reservations.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32),
        alignment: Alignment.center,
        child: const Column(
          children: [
            Icon(Icons.inbox_outlined, size: 48, color: Colors.grey),
            SizedBox(height: 10),
            Text(
              'Hiện không có đơn đặt trước nào tại trạm',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
          ],
        ),
      );
    }

    return Column(
      children: state.reservations
          .map(
            (res) => StaffReservationCard(
              reservation: res,
              onStartHandover: () => widget.onStartHandover(res),
            ),
          )
          .toList(),
    );
  }
}
