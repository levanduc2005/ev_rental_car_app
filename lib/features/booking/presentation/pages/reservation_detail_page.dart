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

class _ReservationDetailPageState extends ConsumerState<ReservationDetailPage> {
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

    final useCase = ref.read(getReservationDetailUseCaseProvider);
    final result = await useCase(widget.reservationId);

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
    final isEligibleForRefund = res.isEligibleForRefund;
    final depositFormatted = BookingFormatters.formatCurrency(res.depositFee);

    String title;
    String message;
    String confirmLabel;

    if (isPending) {
      title = 'Hủy giữ chỗ tức thì?';
      message =
          'Bạn đang hủy đơn giữ chỗ #${res.reservationCode}. Thao tác này sẽ giải phóng xe ngay lập tức để bạn có thể chọn xe khác.';
      confirmLabel = 'Hủy giữ xe ngay';
    } else if (isEligibleForRefund) {
      title = 'Xác nhận hủy & Hoàn cọc';
      message =
          'Thời gian nhận xe còn từ 5 ngày trở lên. Bạn sẽ được HOÀN 100% TIỀN CỌC ($depositFormatted) về tài khoản thanh toán của bạn.\n\nBạn có chắc chắn muốn hủy đơn #${res.reservationCode} không?';
      confirmLabel = 'Xác nhận hủy & Hoàn cọc';
    } else {
      title = 'Cảnh báo hủy đơn - MẤT TIỀN CỌC';
      message =
          'Thời gian nhận xe còn DƯỚI 5 NGÀY. Theo chính sách của hệ thống, bạn sẽ KHÔNG ĐƯỢC HOÀN LẠI số tiền cọc ($depositFormatted) nếu hủy đơn lúc này.\n\nBạn có chắc chắn muốn chấp nhận mất cọc để hủy đơn #${res.reservationCode} không?';
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

    if (!confirmed) return;

    final controller = ref.read(myReservationsControllerProvider.notifier);
    final success = await controller.cancelReservation(res.reservationCode);

    if (success && mounted) {
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
                    borderRadius: BorderRadius.circular(12),
                  ),
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
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.error,
                  side: const BorderSide(color: AppColors.error),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => _handleCancel(res),
                child: const Text(
                  'Hủy giữ chỗ tức thì (đổi xe khác)',
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ],

            // Contextual Actions for CONFIRMED
            if (isConfirmed) ...[
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.error,
                  side: const BorderSide(color: AppColors.error),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => _handleCancel(res),
                child: Text(
                  res.isEligibleForRefund
                      ? 'Hủy đơn đặt xe (Được hoàn cọc)'
                      : 'Hủy đơn đặt xe (Mất tiền cọc)',
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                res.isEligibleForRefund
                    ? '• Đang trong thời hạn > 5 ngày: Được hoàn trả 100% tiền cọc.'
                    : '• Đang trong thời hạn < 5 ngày: Hủy đơn sẽ không được hoàn cọc.',
                style: TextStyle(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                  color: res.isEligibleForRefund
                      ? AppColors.textSecondary
                      : Colors.orange.shade800,
                ),
                textAlign: TextAlign.center,
              ),
            ],

            // Contextual Actions for COMPLETED
            if (isCompleted)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => context.goNamed(AppRoute.home.name),
                child: const Text(
                  'Thuê lại chuyến xe này',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),

            // Contextual Actions for CANCELLED / FAILED / OVERDUE
            if (isInactive)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => context.goNamed(AppRoute.home.name),
                child: const Text(
                  'Tìm và thuê xe khác',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
