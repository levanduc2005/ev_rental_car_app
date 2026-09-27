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

/// Tab 2: Quản lý Đơn thuê xe e-Motion (Gọi API Spring Boot thực tế)
class MyReservationsPage extends ConsumerWidget {
  const MyReservationsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(myReservationsControllerProvider);
    final controller = ref.read(myReservationsControllerProvider.notifier);

    // Lắng nghe thông báo action (vd hủy đơn thành công)
    ref.listen<MyReservationsState>(myReservationsControllerProvider,
        (previous, next) {
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

    final reservations = state.filteredReservations;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: const Text(
          'Đơn thuê của tôi',
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
      ),
      body: Column(
        children: [
          // Filter Tabs (Horizontal Scroll)
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _FilterChip(
                    label: 'Tất cả',
                    isSelected:
                        state.selectedFilter == ReservationTabFilter.all,
                    onTap: () =>
                        controller.setFilter(ReservationTabFilter.all),
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
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: 'Đã hủy',
                    isSelected:
                        state.selectedFilter == ReservationTabFilter.cancelled,
                    onTap: () =>
                        controller.setFilter(ReservationTabFilter.cancelled),
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 1),

          // Main List View with Pull-to-refresh
          Expanded(
            child: state.isLoading
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 12),
                        Text(
                          'Đang tải danh sách đơn thuê từ máy chủ...',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  )
                : state.errorMessage != null
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(AppSpacing.lg),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.error_outline,
                                  size: 48, color: AppColors.error),
                              const SizedBox(height: 12),
                              Text(
                                state.errorMessage!,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    color: AppColors.textPrimary),
                              ),
                              const SizedBox(height: 16),
                              if (state.errorMessage!.contains('đăng nhập'))
                                ElevatedButton.icon(
                                  icon: const Icon(Icons.login),
                                  onPressed: () =>
                                      context.pushNamed(AppRoute.login.name),
                                  label: const Text('Đăng nhập ngay'),
                                )
                              else
                                ElevatedButton(
                                  onPressed: () =>
                                      controller.loadReservations(),
                                  child: const Text('Tải lại'),
                                ),
                            ],
                          ),
                        ),
                      )
                    : reservations.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.no_crash_outlined,
                                    size: 64, color: Colors.grey.shade400),
                                const SizedBox(height: 12),
                                const Text(
                                  'Chưa có đơn thuê nào trong danh mục này',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'Hãy khám phá danh sách xe và đặt chuyến đi đầu tiên!',
                                  style: TextStyle(
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
                                  onPressed: () {
                                    context.goNamed(AppRoute.home.name);
                                  },
                                  child: const Text('Tìm xe ngay'),
                                ),
                              ],
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: () => controller.loadReservations(),
                            child: ListView.separated(
                              padding: const EdgeInsets.all(AppSpacing.md),
                              itemCount: reservations.length,
                              separatorBuilder: (_, _) =>
                                  const SizedBox(height: 12),
                              itemBuilder: (context, index) {
                                final item = reservations[index];
                                return ReservationCard(
                                  reservation: item,
                                  onCancel: () {
                                    _showCancelConfirmDialog(
                                        context, item, controller);
                                  },
                                  onResumePayment: () {
                                    ref
                                        .read(bookingFormControllerProvider
                                            .notifier)
                                        .setPaymentReservation(item);
                                    context.pushNamed(AppRoute.payment.name);
                                  },
                                );
                              },
                            ),
                          ),
          ),
        ],
      ),
    );
  }

  Future<void> _showCancelConfirmDialog(
    BuildContext context,
    ReservationEntity reservation,
    MyReservationsController controller,
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

