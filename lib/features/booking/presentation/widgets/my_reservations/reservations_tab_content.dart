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
import 'package:rental_car/features/booking/presentation/utils/booking_formatters.dart';
import 'package:rental_car/features/booking/presentation/widgets/my_reservations/my_reservations_status_views.dart';
import 'package:rental_car/features/booking/presentation/widgets/reservation_card.dart';

/// Giao diện danh sách Đơn đặt trước (Reservations)
class ReservationsTabContent extends StatelessWidget {
  const ReservationsTabContent({
    super.key,
    required this.state,
    required this.controller,
  });

  final MyReservationsState state;
  final MyReservationsController controller;

  Future<void> _showCancelConfirmDialog(
    BuildContext context,
    ReservationEntity reservation,
  ) async {
    final isPending = reservation.isPending;
    final isEligibleForRefund = reservation.isEligibleForRefund;
    final depositFormatted = BookingFormatters.formatCurrency(
      reservation.depositFee,
    );

    String title;
    String message;
    String confirmLabel;

    if (isPending) {
      title = 'Hủy giữ chỗ tức thì?';
      message =
          'Bạn đang hủy đơn giữ chỗ #${reservation.reservationCode}. Thao tác này sẽ hủy đơn ngay lập tức và giải phóng xe để bạn có thể đặt xe khác.';
      confirmLabel = 'Hủy giữ xe ngay';
    } else if (isEligibleForRefund) {
      title = 'Xác nhận hủy & Hoàn cọc';
      message =
          'Thời gian nhận xe còn từ 5 ngày trở lên. Bạn sẽ được HOÀN 100% TIỀN CỌC ($depositFormatted) về tài khoản thanh toán của bạn.\n\nBạn có chắc chắn muốn hủy đơn #${reservation.reservationCode} không?';
      confirmLabel = 'Xác nhận hủy & Hoàn cọc';
    } else {
      title = 'Cảnh báo hủy đơn - MẤT TIỀN CỌC';
      message =
          'Thời gian nhận xe còn DƯỚI 5 NGÀY. Theo chính sách của hệ thống, bạn sẽ KHÔNG ĐƯỢC HOÀN LẠI số tiền cọc ($depositFormatted) nếu hủy đơn lúc này.\n\nBạn có chắc chắn muốn chấp nhận mất cọc để hủy đơn #${reservation.reservationCode} không?';
      confirmLabel = 'Đồng ý hủy & Mất cọc';
    }

    final confirmed = await showConfirmDialog(
      context,
      title: title,
      message: message,
      confirmLabel: confirmLabel,
      cancelLabel: 'Quay lại',
      isDestructive: true,
    );

    if (confirmed) {
      final success = await controller.cancelReservation(
        reservation.reservationCode,
      );
      if (success && context.mounted) {
        if (!isPending && isEligibleForRefund) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Hủy đơn thành công! Đã hoàn $depositFormatted về tài khoản thanh toán.',
              ),
              backgroundColor: AppColors.success,
            ),
          );
        } else if (!isPending) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Đã hủy đơn đặt xe (Mất tiền cọc theo quy định < 5 ngày).',
              ),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final trips = state.filteredReservations;

    return Column(
      children: [
        // Thanh bộ lọc trạng thái đơn đặt trước
        Container(
          color: Colors.white,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                BookingFilterChip(
                  label: 'Tất cả (${state.reservations.length})',
                  isSelected: state.selectedFilter == ReservationTabFilter.all,
                  onTap: () => controller.setFilter(ReservationTabFilter.all),
                ),
                const SizedBox(width: 8),
                BookingFilterChip(
                  label: 'Chờ thanh toán',
                  isSelected:
                      state.selectedFilter == ReservationTabFilter.pending,
                  onTap: () =>
                      controller.setFilter(ReservationTabFilter.pending),
                ),
                const SizedBox(width: 8),
                BookingFilterChip(
                  label: 'Đã xác nhận',
                  isSelected:
                      state.selectedFilter == ReservationTabFilter.confirmed,
                  onTap: () =>
                      controller.setFilter(ReservationTabFilter.confirmed),
                ),
                const SizedBox(width: 8),
                BookingFilterChip(
                  label: 'Đang thuê',
                  isSelected:
                      state.selectedFilter == ReservationTabFilter.active,
                  onTap: () =>
                      controller.setFilter(ReservationTabFilter.active),
                ),
                const SizedBox(width: 8),
                BookingFilterChip(
                  label: 'Hoàn tất',
                  isSelected:
                      state.selectedFilter == ReservationTabFilter.completed,
                  onTap: () =>
                      controller.setFilter(ReservationTabFilter.completed),
                ),
                const SizedBox(width: 8),
                BookingFilterChip(
                  label: 'Đã hủy (${state.cancelledTrips.length})',
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

        // Danh sách đơn đặt trước
        Expanded(
          child: _buildBody(context, trips),
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context, List<ReservationEntity> trips) {
    if (state.isLoading && state.reservations.isEmpty) {
      return const BookingLoadingView();
    }
    if (state.errorMessage != null && state.reservations.isEmpty) {
      return BookingErrorView(
        errorMessage: state.errorMessage!,
        onRetry: controller.loadReservations,
      );
    }

    if (trips.isEmpty) {
      final isCancelledFilter =
          state.selectedFilter == ReservationTabFilter.cancelled;
      return RefreshIndicator(
        onRefresh: controller.loadReservations,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.5,
              child: BookingEmptyView(
                title: isCancelledFilter
                    ? 'Không có đơn đã hủy'
                    : 'Chưa có đơn đặt trước nào trong mục này',
                subtitle: isCancelledFilter
                    ? 'Bạn chưa có đơn đặt trước nào bị hủy hoặc quá hạn.'
                    : 'Hãy khám phá danh sách xe và đặt chuyến đi đầu tiên!',
                buttonText:
                    isCancelledFilter ? 'Khám phá xe ngay' : 'Tìm xe ngay',
                icon: isCancelledFilter
                    ? Icons.check_circle_outline
                    : Icons.no_crash_outlined,
                onButtonPressed: () => context.goNamed(AppRoute.home.name),
              ),
            ),
          ],
        ),
      );
    }

    return Consumer(
      builder: (context, ref, _) {
        return RefreshIndicator(
          onRefresh: controller.loadReservations,
          child: ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: trips.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = trips[index];
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
      },
    );
  }
}
