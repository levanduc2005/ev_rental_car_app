import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rental_car/app/router/app_routes.dart';
import 'package:rental_car/core/theme/app_colors.dart';
import 'package:rental_car/core/theme/app_spacing.dart';
import 'package:rental_car/core/widgets/confirm_dialog.dart';
import 'package:rental_car/features/booking/domain/entities/reservation_entity.dart';
import 'package:rental_car/features/booking/presentation/providers/booking_form_controller.dart';
import 'package:rental_car/features/booking/presentation/providers/my_reservations_controller.dart';
import 'package:rental_car/features/booking/presentation/providers/my_reservations_state.dart';
import 'package:rental_car/features/booking/presentation/widgets/reservation_card.dart';

/// Tab 2: Quản lý Đơn thuê xe e-Motion (Được chia làm 2 mục: Chuyến đi & Đã hủy)
class MyReservationsPage extends ConsumerWidget {
  const MyReservationsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(myReservationsControllerProvider);
    final controller = ref.read(myReservationsControllerProvider.notifier);

    // Lắng nghe thông báo action (vd: hủy đơn thành công)
    ref.listen<MyReservationsState>(myReservationsControllerProvider, (
      previous,
      next,
    ) {
      if (next.actionMessage != null &&
          next.actionMessage != previous?.actionMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.actionMessage!),
            backgroundColor: AppColors.success,
          ),
        );
      }
    });

    final activeCount = state.activeTrips.length;
    final cancelledCount = state.cancelledTrips.length;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.5,
          title: const Text(
            'Lịch sử & Đơn thuê',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh, color: AppColors.textPrimary),
              onPressed: () => controller.loadReservations(),
            ),
          ],
          bottom: TabBar(
            labelColor: const Color(0xFF2563EB),
            unselectedLabelColor: AppColors.textSecondary,
            indicatorColor: const Color(0xFF2563EB),
            indicatorWeight: 3,
            labelStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            tabs: [
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.directions_car_outlined, size: 18),
                    const SizedBox(width: 6),
                    Text(
                      activeCount > 0
                          ? 'Chuyến đi ($activeCount)'
                          : 'Chuyến đi',
                    ),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.cancel_outlined, size: 18),
                    const SizedBox(width: 6),
                    Text(
                      cancelledCount > 0
                          ? 'Đã hủy ($cancelledCount)'
                          : 'Đã hủy',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Tab 1: Các chuyến đi (đang hiệu lực / hoàn thành)
            _ActiveTripsTab(state: state, controller: controller),

            // Tab 2: Các đơn đã hủy / hết hạn
            _CancelledTripsTab(state: state, controller: controller),
          ],
        ),
      ),
    );
  }
}

/// Tab hiển thị các Chuyến đi đang đặt, đã cọc, đang thuê hoặc đã hoàn tất
class _ActiveTripsTab extends StatelessWidget {
  const _ActiveTripsTab({required this.state, required this.controller});

  final MyReservationsState state;
  final MyReservationsController controller;

  @override
  Widget build(BuildContext context) {
    if (state.isLoading) {
      return const _LoadingView();
    }
    if (state.errorMessage != null) {
      return _ErrorView(
        errorMessage: state.errorMessage!,
        onRetry: controller.loadReservations,
      );
    }

    final trips = state.filteredActiveTrips;

    return Column(
      children: [
        // Sub-filter chips cho chuyến đi
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _FilterChip(
                  label: 'Tất cả (${state.activeTrips.length})',
                  isSelected: state.selectedFilter == ReservationTabFilter.all,
                  onTap: () => controller.setFilter(ReservationTabFilter.all),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Chờ thanh toán',
                  isSelected:
                      state.selectedFilter == ReservationTabFilter.pending,
                  onTap: () =>
                      controller.setFilter(ReservationTabFilter.pending),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Đã xác nhận',
                  isSelected:
                      state.selectedFilter == ReservationTabFilter.confirmed,
                  onTap: () =>
                      controller.setFilter(ReservationTabFilter.confirmed),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Đang thuê',
                  isSelected:
                      state.selectedFilter == ReservationTabFilter.active,
                  onTap: () =>
                      controller.setFilter(ReservationTabFilter.active),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Hoàn tất',
                  isSelected:
                      state.selectedFilter == ReservationTabFilter.completed,
                  onTap: () =>
                      controller.setFilter(ReservationTabFilter.completed),
                ),
              ],
            ),
          ),
        ),
        const Divider(height: 1),

        Expanded(
          child: trips.isEmpty
              ? _EmptyView(
                  title: 'Chưa có chuyến đi nào trong mục này',
                  subtitle:
                      'Hãy khám phá danh sách xe và đặt chuyến đi đầu tiên!',
                  buttonText: 'Tìm xe ngay',
                  onButtonPressed: () => context.goNamed(AppRoute.home.name),
                )
              : _ReservationListView(
                  reservations: trips,
                  onRefresh: controller.loadReservations,
                  controller: controller,
                ),
        ),
      ],
    );
  }
}

/// Tab hiển thị các đơn đã hủy hoặc hết hạn
class _CancelledTripsTab extends StatelessWidget {
  const _CancelledTripsTab({required this.state, required this.controller});

  final MyReservationsState state;
  final MyReservationsController controller;

  @override
  Widget build(BuildContext context) {
    if (state.isLoading) {
      return const _LoadingView();
    }
    if (state.errorMessage != null) {
      return _ErrorView(
        errorMessage: state.errorMessage!,
        onRetry: controller.loadReservations,
      );
    }

    final cancelledList = state.cancelledTrips;

    return Column(
      children: [
        // Thông tin ghi chú
        Container(
          width: double.infinity,
          margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: const Row(
            children: [
              Icon(
                Icons.info_outline,
                size: 16,
                color: AppColors.textSecondary,
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Danh sách lưu trữ các đơn đặt xe đã bị hủy hoặc hết hạn thanh toán.',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),

        Expanded(
          child: cancelledList.isEmpty
              ? _EmptyView(
                  title: 'Không có đơn đã hủy',
                  subtitle: 'Bạn chưa có đơn đặt xe nào bị hủy hoặc quá hạn.',
                  icon: Icons.check_circle_outline,
                  buttonText: 'Xem danh sách xe',
                  onButtonPressed: () => context.goNamed(AppRoute.home.name),
                )
              : _ReservationListView(
                  reservations: cancelledList,
                  onRefresh: controller.loadReservations,
                  controller: controller,
                ),
        ),
      ],
    );
  }
}

/// Danh sách hiển thị các thẻ đơn đặt xe
class _ReservationListView extends ConsumerWidget {
  const _ReservationListView({
    required this.reservations,
    required this.onRefresh,
    required this.controller,
  });

  final List<ReservationEntity> reservations;
  final Future<void> Function() onRefresh;
  final MyReservationsController controller;

  Future<void> _showCancelConfirmDialog(
    BuildContext context,
    ReservationEntity reservation,
  ) async {
    final isPending = reservation.isPending;
    final confirmed = await showConfirmDialog(
      context,
      title: isPending ? 'Hủy giữ chỗ tức thì?' : 'Xác nhận hủy đơn đặt xe?',
      message: isPending
          ? 'Bạn đang hủy đơn giữ chỗ #${reservation.reservationCode}. Thao tác này sẽ hủy đơn ngay lập tức và giải phóng xe để bạn có thể đặt xe khác.'
          : 'Bạn đang hủy đơn đã xác nhận cọc #${reservation.reservationCode}. Đơn sẽ được xử lý hoàn trả cọc theo chính sách (hủy trước ngày nhận xe từ 5 ngày trở lên).',
      confirmLabel: isPending ? 'Hủy giữ xe ngay' : 'Xác nhận hủy',
      cancelLabel: 'Quay lại',
      isDestructive: true,
    );

    if (confirmed) {
      controller.cancelReservation(reservation.reservationCode);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.separated(
        padding: const EdgeInsets.all(AppSpacing.md),
        itemCount: reservations.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final item = reservations[index];
          return ReservationCard(
            reservation: item,
            onCancel: () => _showCancelConfirmDialog(context, item),
            onResumePayment: () {
              ref
                  .read(bookingFormControllerProvider.notifier)
                  .setPaymentReservation(item);
              context.pushNamed(AppRoute.payment.name);
            },
          );
        },
      ),
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 12),
          Text(
            'Đang tải danh sách đơn thuê từ máy chủ...',
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.errorMessage, required this.onRetry});

  final String errorMessage;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: AppColors.error),
            const SizedBox(height: 12),
            Text(
              errorMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textPrimary),
            ),
            const SizedBox(height: 16),
            if (errorMessage.contains('đăng nhập'))
              ElevatedButton.icon(
                icon: const Icon(Icons.login),
                onPressed: () => context.pushNamed(AppRoute.login.name),
                label: const Text('Đăng nhập ngay'),
              )
            else
              ElevatedButton(onPressed: onRetry, child: const Text('Tải lại')),
          ],
        ),
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView({
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.onButtonPressed,
    this.icon,
  });

  final String title;
  final String subtitle;
  final String buttonText;
  final VoidCallback onButtonPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon ?? Icons.no_crash_outlined,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
              foregroundColor: Colors.white,
            ),
            onPressed: onButtonPressed,
            child: Text(buttonText),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2563EB) : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
