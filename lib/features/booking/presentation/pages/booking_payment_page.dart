import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rental_car/app/router/app_routes.dart';
import 'package:rental_car/core/theme/app_colors.dart';
import 'package:rental_car/features/auth/presentation/providers/auth_controller.dart';
import 'package:rental_car/features/booking/presentation/providers/booking_form_controller.dart';
import 'package:rental_car/features/booking/presentation/providers/booking_providers.dart';
import 'package:rental_car/features/booking/presentation/providers/my_reservations_controller.dart';
import 'package:rental_car/features/booking/presentation/utils/booking_formatters.dart';
import 'package:rental_car/features/booking/presentation/widgets/booking_order_summary_card.dart';
import 'package:rental_car/features/booking/presentation/widgets/vietqr_payment_card.dart';

/// Trang Thanh toán phí giữ chỗ VietQR MBBank (Chuẩn stitch_booking.html 100%)
class BookingPaymentPage extends ConsumerStatefulWidget {
  const BookingPaymentPage({super.key});

  @override
  ConsumerState<BookingPaymentPage> createState() => _BookingPaymentPageState();
}

class _BookingPaymentPageState extends ConsumerState<BookingPaymentPage> {
  Timer? _countdownTimer;
  int _remainingSeconds = 15 * 60; // 15 phút đếm ngược
  bool _isCheckingStatus = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bookingState = ref.read(bookingFormControllerProvider);
      final reservation = bookingState.createdReservation;
      if (bookingState.payosPaymentInfo == null &&
          reservation != null &&
          reservation.id > 0) {
        ref
            .read(bookingFormControllerProvider.notifier)
            .fetchPayOSPaymentLink(reservation.id);
      }
    });
  }

  void _startTimer() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_remainingSeconds > 0) {
        setState(() => _remainingSeconds--);
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  String get _formattedCountdown {
    final minutes = (_remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (_remainingSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  void _copyToClipboard(String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đã sao chép $label: $text'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _handleConfirmPayment() async {
    setState(() => _isCheckingStatus = true);

    final bookingState = ref.read(bookingFormControllerProvider);
    final reservationCode =
        bookingState.createdReservation?.reservationCode ?? '';

    if (reservationCode.isEmpty) {
      if (!mounted) return;
      setState(() => _isCheckingStatus = false);
      context.pushReplacementNamed(AppRoute.bookingSuccess.name);
      return;
    }

    // Gọi API thật tới Spring Boot Backend để xác nhận giao dịch cọc PayOS
    final repo = ref.read(bookingRepositoryProvider);
    final result = await repo.confirmPayOSPayment(reservationCode);

    if (!mounted) return;
    setState(() => _isCheckingStatus = false);

    result.when(
      ok: (_) {
        // Tải lại danh sách đơn chuyến đi ở Tab 2
        ref.read(myReservationsControllerProvider.notifier).loadReservations();
        // Chuyển sang màn hình Thành công
        context.pushReplacementNamed(AppRoute.bookingSuccess.name);
      },
      err: (failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              failure.message.isNotEmpty
                  ? failure.message
                  : 'Hệ thống chưa nhận được thanh toán. Vui lòng kiểm tra lại giao dịch.',
            ),
            backgroundColor: AppColors.error,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bookingState = ref.watch(bookingFormControllerProvider);
    final authState = ref.watch(authControllerProvider);
    final user = authState.user;
    final vehicle = bookingState.vehicle;
    final reservation = bookingState.createdReservation;

    final paymentInfo = bookingState.payosPaymentInfo;

    if (paymentInfo == null) {
      return Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.5,
          leading: IconButton(
            icon: const Icon(Icons.close, color: AppColors.textPrimary),
            onPressed: () => context.pop(),
          ),
          title: const Text(
            'Thanh toán đặt cọc',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(color: AppColors.primary),
              const SizedBox(height: 16),
              const Text(
                'Đang tạo liên kết thanh toán PayOS...',
                style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 12),
              if (reservation != null && reservation.id > 0)
                OutlinedButton(
                  onPressed: () {
                    ref
                        .read(bookingFormControllerProvider.notifier)
                        .fetchPayOSPaymentLink(reservation.id);
                  },
                  child: const Text('Thử lại'),
                ),
            ],
          ),
        ),
      );
    }

    final reservationCode =
        reservation?.reservationCode ?? paymentInfo.orderCode;
    final depositFee = reservation?.depositFee ?? paymentInfo.depositFee;
    final totalRent =
        reservation?.totalAmount ?? bookingState.estimatedTotalRent;
    final collateralFee =
        reservation?.collateralFee ?? vehicle?.depositFee?.toInt() ?? 3000000;

    final renterName =
        (user != null && user.fullName != null && user.fullName!.isNotEmpty)
        ? user.fullName!
        : (user != null && user.email.isNotEmpty ? user.email : 'Khách hàng');
    final renterPhone = (user?.phone != null && user!.phone!.isNotEmpty)
        ? user.phone!
        : 'Chưa cập nhật';

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Đặt xe',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.support_agent_outlined,
              color: Color(0xFF2563EB),
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: 100,
        ),
        child: Column(
          children: [
            // --- 1. Deposit Overview Card ---
            const Text(
              'Thanh toán phí giữ chỗ',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  BookingFormatters.formatCurrency(depositFee),
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Countdown Timer
            const Text(
              'Thời gian giữ chỗ còn lại',
              style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: Text(
                _formattedCountdown,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                  fontFamily: 'monospace',
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Mã đặt xe
            RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
                children: [
                  const TextSpan(text: 'Mã đặt xe của bạn: '),
                  TextSpan(
                    text: reservationCode,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'monospace',
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Brief Rental Summary Card (Amber)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF3C7),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFFDE68A)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Loại xe:',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Text(
                        vehicle?.name ?? 'KIA K3 2024',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Ngày nhận trả xe:',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Text(
                        BookingFormatters.formatDateRange(
                          bookingState.startDateTime,
                          bookingState.endDateTime,
                        ),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // --- 2. Bank Transfer Card (Reusable VietQRPaymentCard) ---
            VietQRPaymentCard(
              paymentInfo: paymentInfo,
              onCopy: _copyToClipboard,
            ),
            const SizedBox(height: 20),

            // --- 3. Order Details Section (Reusable BookingOrderSummaryCard) ---
            BookingOrderSummaryCard(
              reservationCode: reservationCode,
              vehicleName: vehicle?.name ?? 'KIA K3 2024',
              vehicleImageUrl: vehicle?.imageUrl,
              renterName: renterName,
              renterPhone: renterPhone,
              startDateTime: bookingState.startDateTime,
              endDateTime: bookingState.endDateTime,
              totalRent: totalRent,
              depositFee: depositFee,
              collateralFee: collateralFee,
            ),
          ],
        ),
      ),

      // --- 4. Sticky Footer CTA Button ---
      bottomSheet: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey.shade200)),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, -3),
            ),
          ],
        ),
        child: SafeArea(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 2,
            ),
            onPressed: _isCheckingStatus ? null : _handleConfirmPayment,
            child: _isCheckingStatus
                ? const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 12),
                      Text(
                        'Đang kiểm tra giao dịch PayOS...',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  )
                : const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Xác nhận đã thanh toán',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward, size: 18),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
