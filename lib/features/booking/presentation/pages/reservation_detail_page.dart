import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rental_car/app/router/app_routes.dart';
import 'package:rental_car/core/theme/app_colors.dart';
import 'package:rental_car/core/theme/app_spacing.dart';
import 'package:rental_car/core/widgets/confirm_dialog.dart';
import 'package:rental_car/features/booking/domain/entities/reservation_entity.dart';
import 'package:rental_car/features/booking/presentation/providers/booking_form_controller.dart';
import 'package:rental_car/features/booking/presentation/providers/booking_providers.dart';
import 'package:rental_car/features/booking/presentation/providers/my_reservations_controller.dart';
import 'package:rental_car/features/booking/presentation/utils/booking_formatters.dart';
import 'package:rental_car/features/booking/presentation/widgets/booking_payment_breakdown_card.dart';
import 'package:rental_car/features/booking/presentation/widgets/booking_schedule_card.dart';
import 'package:rental_car/features/booking/presentation/widgets/booking_vehicle_summary_card.dart';
import 'package:rental_car/features/booking/presentation/widgets/checkin_qr_card.dart';
import 'package:rental_car/features/booking/presentation/widgets/reservation_status_badge.dart';

/// Trang xem Chi tiết Đơn đặt xe (Gọi API GET /api/reservations/me/{id})
class ReservationDetailPage extends ConsumerStatefulWidget {
  const ReservationDetailPage({required this.reservationId, super.key});

  final int reservationId;

  @override
  ConsumerState<ReservationDetailPage> createState() =>
      _ReservationDetailPageState();
}

class _ReservationDetailPageState
    extends ConsumerState<ReservationDetailPage> {
  ReservationEntity? _reservation;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchDetail();
  }

  Future<void> _fetchDetail() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final repo = ref.read(bookingRepositoryProvider);
    final result = await repo.getReservationDetail(widget.reservationId);

    if (!mounted) return;

    result.when(
      ok: (item) {
        setState(() {
          _reservation = item;
          _isLoading = false;
        });
      },
      err: (failure) {
        setState(() {
          _isLoading = false;
          _errorMessage = failure.message;
        });
      },
    );
  }

  Future<void> _handleCancel(ReservationEntity res) async {
    final isPending = res.isPending;
    final confirmed = await showConfirmDialog(
      context,
      title: isPending ? 'Hủy giữ chỗ tức thì?' : 'Xác nhận hủy đơn đặt xe?',
      message: isPending
          ? 'Bạn đang hủy đơn giữ chỗ #${res.reservationCode}. Thao tác này sẽ giải phóng xe ngay lập tức để bạn có thể chọn xe khác.'
          : 'Bạn đang hủy đơn đã xác nhận cọc #${res.reservationCode}. Đơn sẽ được hoàn cọc theo chính sách (hủy trước ngày nhận xe từ 5 ngày trở lên).',
      confirmLabel: isPending ? 'Hủy giữ xe ngay' : 'Xác nhận hủy',
      cancelLabel: 'Quay lại',
      isDestructive: true,
    );

    if (!confirmed) return;

    final controller = ref.read(myReservationsControllerProvider.notifier);
    final success = await controller.cancelReservation(res.reservationCode);

    if (success && mounted) {
      _fetchDetail();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Chi tiết đơn thuê')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_errorMessage != null || _reservation == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Chi tiết đơn thuê')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: AppColors.error),
              const SizedBox(height: 12),
              Text(_errorMessage ?? 'Không tìm thấy thông tin đơn đặt xe.'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _fetchDetail,
                child: const Text('Thử lại'),
              ),
            ],
          ),
        ),
      );
    }

    final res = _reservation!;
    final isPending = res.isPending;
    final isConfirmed = res.isConfirmed;
    final isCompleted = res.isCompleted;
    final isInactive = res.isCancelled || res.isFailed || res.isOverdue;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: Text(
          'Đơn #${res.reservationCode}',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Vehicle Summary Card with Reusable Status Badge
            BookingVehicleSummaryCard(
              name: res.vehicle?.name ?? 'Xe điện e-Motion',
              imageUrl: res.vehicle?.imageUrl,
              plateNumber: res.vehicle?.plateNumber,
              badge: ReservationStatusBadge(status: res.status),
            ),
            const SizedBox(height: 16),

            // Check-in QR Card for Confirmed / Active reservations
            if (isConfirmed || res.isActive) ...[
              CheckinQrCard(
                reservationCode: res.reservationCode,
                vehicleName: res.vehicle?.name,
                stationName: res.vehicle?.stationName,
                stationAddress:
                    res.vehicle?.stationAddress ?? res.pickupLocation,
              ),
              const SizedBox(height: 16),
            ],

            // Reusable Rental Schedule Card
            BookingScheduleCard(
              startDateTime: res.startDateTime,
              endDateTime: res.endDateTime,
              pickupLocation: res.pickupLocation,
              returnLocation: res.returnLocation,
            ),
            const SizedBox(height: 16),

            // Reusable Payment Breakdown Card
            BookingPaymentBreakdownCard(
              depositFee: res.depositFee,
              totalRent: res.totalAmount,
              collateralFee: res.collateralFee,
              paymentMethod: res.paymentMethod.isNotEmpty
                  ? res.paymentMethod
                  : 'PayOS (VietQR MBBank)',
              isDepositPhase: isPending,
            ),
            const SizedBox(height: 24),

            // Contextual Actions for PENDING
            if (isPending) ...[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  ref
                      .read(bookingFormControllerProvider.notifier)
                      .setPaymentReservation(res);
                  context.pushNamed(AppRoute.payment.name);
                },
                child: Text(
                  'Tiếp tục thanh toán cọc ${BookingFormatters.formatCurrency(res.depositFee)}',
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.error,
                  side: const BorderSide(color: AppColors.error),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () => _handleCancel(res),
                child: const Text('Hủy giữ chỗ tức thì (đổi xe khác)',
                    style: TextStyle(fontSize: 14)),
              ),
            ],

            // Contextual Actions for CONFIRMED
            if (isConfirmed) ...[
              if (res.canCancel) ...[
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.error,
                    side: const BorderSide(color: AppColors.error),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () => _handleCancel(res),
                  child: const Text('Hủy đơn đặt xe (Trước 5 ngày)',
                      style: TextStyle(fontSize: 14)),
                ),
              ] else ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade50,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.amber.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline,
                          color: Colors.amber.shade800, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Theo quy định, đơn không thể hủy khi thời gian nhận xe còn dưới 5 ngày.',
                          style: TextStyle(
                              fontSize: 12, color: Colors.amber.shade900),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],

            // Contextual Actions for COMPLETED
            if (isCompleted)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () => context.goNamed(AppRoute.home.name),
                child: const Text('Thuê lại chuyến xe này',
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              ),

            // Contextual Actions for CANCELLED / FAILED / OVERDUE
            if (isInactive)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () => context.goNamed(AppRoute.home.name),
                child: const Text('Tìm và thuê xe khác',
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
