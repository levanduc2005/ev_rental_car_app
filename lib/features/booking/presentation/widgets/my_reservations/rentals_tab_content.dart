import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rental_car/app/router/app_routes.dart';
import 'package:rental_car/core/theme/app_spacing.dart';
import 'package:rental_car/features/booking/presentation/widgets/my_reservations/my_reservations_status_views.dart';
import 'package:rental_car/features/booking/presentation/widgets/my_reservations/rental_item_card.dart';
import 'package:rental_car/features/profile/presentation/controllers/rental_history_controller.dart';
import 'package:rental_car/features/profile/presentation/controllers/rental_history_state.dart';
import 'package:rental_car/features/profile/presentation/providers/profile_providers.dart';

/// Giao diện danh sách các Đơn thuê xe thực tế (Rental)
class RentalsTabContent extends ConsumerWidget {
  const RentalsTabContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(rentalHistoryControllerProvider);
    final controller = ref.read(rentalHistoryControllerProvider.notifier);

    return Column(
      children: [
        // Sub-filter chips (Tất cả, Đang thuê, Hoàn thành, Đã hủy)
        Container(
          color: Colors.white,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: RentalHistoryTab.values.map((tab) {
                final isSelected = state.selectedTab == tab;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: BookingFilterChip(
                    label: tab.label,
                    isSelected: isSelected,
                    onTap: () => controller.changeTab(tab),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        const Divider(height: 1),

        // Danh sách đơn thuê
        Expanded(
          child: RefreshIndicator(
            onRefresh: controller.refresh,
            child: _buildBody(context, state, controller),
          ),
        ),
      ],
    );
  }

  Widget _buildBody(
    BuildContext context,
    RentalHistoryState state,
    RentalHistoryController controller,
  ) {
    if (state.isLoading && state.items.isEmpty) {
      return const BookingLoadingView(
        message: 'Đang tải danh sách đơn thuê từ máy chủ...',
      );
    }

    if (state.errorMessage != null && state.items.isEmpty) {
      return BookingErrorView(
        errorMessage: state.errorMessage!,
        onRetry: controller.refresh,
      );
    }

    if (state.items.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: BookingEmptyView(
              title: 'Chưa có đơn thuê nào (${state.selectedTab.label})',
              subtitle:
                  'Các đơn thuê xe của bạn sẽ xuất hiện tại đây khi bắt đầu chuyến đi.',
              buttonText: 'Khám phá xe ngay',
              icon: Icons.car_rental_outlined,
              onButtonPressed: () => context.goNamed(AppRoute.home.name),
            ),
          ),
        ],
      );
    }

    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: state.items.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return RentalItemCard(item: state.items[index]);
      },
    );
  }
}
