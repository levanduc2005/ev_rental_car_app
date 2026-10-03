import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rental_car/app/router/app_routes.dart';
import 'package:rental_car/core/theme/app_colors.dart';
import 'package:rental_car/features/auth/presentation/providers/auth_controller.dart';
import 'package:rental_car/features/booking/domain/entities/payos_payment_info_entity.dart';
import 'package:rental_car/features/booking/presentation/models/bank_app_item.dart';
import 'package:rental_car/features/booking/presentation/providers/booking_form_controller.dart';
import 'package:rental_car/features/booking/presentation/providers/booking_providers.dart';
import 'package:rental_car/features/booking/presentation/providers/my_reservations_controller.dart';
import 'package:rental_car/features/booking/presentation/providers/supported_banks_provider.dart';
import 'package:rental_car/features/booking/presentation/utils/booking_formatters.dart';
import 'package:rental_car/features/booking/presentation/widgets/bank_app_selector_grid.dart';
import 'package:rental_car/features/booking/presentation/widgets/booking_order_summary_card.dart';
import 'package:rental_car/features/booking/presentation/widgets/vietqr_payment_card.dart';
import 'package:url_launcher/url_launcher.dart';

/// Trang Thanh toán phí giữ chỗ qua App-to-App Deeplink hoặc VietQR PayOS
/// Hỗ trợ chọn nhanh App Ngân hàng (1A) & Accordion QR thu gọn (2A)
class BookingPaymentPage extends ConsumerStatefulWidget {
  const BookingPaymentPage({super.key});

  @override
  ConsumerState<BookingPaymentPage> createState() => _BookingPaymentPageState();
}

class _BookingPaymentPageState extends ConsumerState<BookingPaymentPage> {
  Timer? _countdownTimer;
  int _remainingSeconds = 15 * 60; // 15 phút đếm ngược
  bool _isCheckingStatus = false;
  BankAppItem? _selectedBank;

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

  /// Kích hoạt App-to-App Deeplink mở trực tiếp App Ngân hàng người dùng chọn
  Future<void> _handleOpenBankApp(PayOSPaymentInfoEntity paymentInfo) async {
    final allBanks = ref.read(supportedBanksProvider).value ?? [];
    final targetBank =
        _selectedBank ?? (allBanks.isNotEmpty ? allBanks.first : null);
    if (targetBank == null) return;

    // Tìm mã ngân hàng thụ hưởng động theo mã BIN nhận từ PayOS
    final receivingBank = allBanks
        .where((b) => b.bin == paymentInfo.bin)
        .firstOrNull;
    final beneficiaryBankCode = receivingBank?.code ?? (paymentInfo.bin ?? '');

    final deeplink = targetBank.buildDeeplink(
      beneficiaryAccountNumber: paymentInfo.accountNumber,
      beneficiaryBankCode: beneficiaryBankCode,
      amount: paymentInfo.depositFee,
      description: paymentInfo.description,
      beneficiaryAccountName: paymentInfo.accountName,
    );

    try {
      final uri = Uri.parse(deeplink);
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched) {
        if (!mounted) return;
        _showBankLaunchFailedDialog(paymentInfo, targetBank);
      }
    } catch (_) {
      if (!mounted) return;
      _showBankLaunchFailedDialog(paymentInfo, targetBank);
    }
  }

  /// Thông báo khi thiết bị chưa cài đặt ứng dụng ngân hàng đó
  void _showBankLaunchFailedDialog(
    PayOSPaymentInfoEntity paymentInfo,
    BankAppItem targetBank,
  ) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.info_outline, color: Color(0xFF2563EB)),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Mở app ${targetBank.shortName}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          'Không thể khởi động ứng dụng ${targetBank.name} trên máy của bạn. Vui lòng đảm bảo đã cài đặt app ngân hàng, hoặc bạn có thể mở rộng mục "Quét mã QR / Chuyển khoản thủ công" bên dưới.',
          style: const TextStyle(fontSize: 13, height: 1.4),
        ),
        actions: [
          if (paymentInfo.checkoutUrl != null &&
              paymentInfo.checkoutUrl!.startsWith('http'))
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                launchUrl(
                  Uri.parse(paymentInfo.checkoutUrl!),
                  mode: LaunchMode.externalApplication,
                );
              },
              child: const Text('Mở trang PayOS Web'),
            ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Đã hiểu'),
          ),
        ],
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
    final useCase = ref.read(confirmPayOSPaymentUseCaseProvider);
    final result = await useCase(reservationCode);

    if (!mounted) return;
    setState(() => _isCheckingStatus = false);

    result.when(
      ok: (isConfirmed) {
        if (!isConfirmed) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Hệ thống chưa nhận được thanh toán từ ngân hàng. Vui lòng hoàn tất chuyển khoản trước khi bấm xác nhận.',
              ),
              backgroundColor: AppColors.error,
            ),
          );
          return;
        }
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
    final banksAsync = ref.watch(supportedBanksProvider);
    final allBanks = banksAsync.value ?? [];
    final currentSelectedBank =
        _selectedBank ?? (allBanks.isNotEmpty ? allBanks.first : null);

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
    final depositFee = paymentInfo.depositFee > 0
        ? paymentInfo.depositFee
        : (reservation?.depositFee ?? 0);
    final totalRent =
        reservation?.totalAmount ?? bookingState.estimatedTotalRent;
    final collateralFee =
        reservation?.collateralFee ?? vehicle?.depositFee?.toInt() ?? 0;

    final renterName =
        (user != null && user.fullName != null && user.fullName!.isNotEmpty)
        ? user.fullName!
        : (user != null && user.email.isNotEmpty ? user.email : 'Khách hàng');
    final renterPhone = (user?.phone != null && user!.phone!.isNotEmpty)
        ? user.phone!
        : 'Chưa cập nhật';

    final vehicleDisplayName =
        (vehicle?.name != null && vehicle!.name.isNotEmpty)
        ? vehicle.name
        : (reservation?.vehicleName != null &&
                  reservation!.vehicleName!.isNotEmpty
              ? reservation.vehicleName!
              : 'Phương tiện thuê');
    final vehicleImageUrl =
        (vehicle?.imageUrl != null && vehicle!.imageUrl!.isNotEmpty)
        ? vehicle.imageUrl
        : reservation?.vehicleImageUrl;

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
          bottom: 110,
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
                        vehicleDisplayName,
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
            const SizedBox(height: 16),

            // --- 2. Bank App Selector Grid (Phương án 1 & 1A) ---
            BankAppSelectorGrid(
              selectedBank: currentSelectedBank,
              onBankSelected: (bank) {
                setState(() => _selectedBank = bank);
              },
            ),
            const SizedBox(height: 14),

            // --- 3. Nút CTA mở trực tiếp App Ngân hàng (1-Chạm Deeplink) ---
            if (currentSelectedBank != null) ...[
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF2563EB).withValues(alpha: 0.35),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => _handleOpenBankApp(paymentInfo),
                    borderRadius: BorderRadius.circular(16),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: Image.network(
                                currentSelectedBank.logoUrl,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(
                                      Icons.account_balance,
                                      color: Color(0xFF2563EB),
                                      size: 24,
                                    ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Mở app ${currentSelectedBank.shortName} để thanh toán',
                                  style: const TextStyle(
                                    fontSize: 14.5,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Tự động điền ${BookingFormatters.formatCurrency(depositFee)} & nội dung',
                                  style: TextStyle(
                                    fontSize: 11.5,
                                    color: Colors.white.withValues(alpha: 0.85),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.open_in_new_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ] else ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Đang tải ứng dụng ngân hàng...',
                        style: TextStyle(fontSize: 13, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 18),

            // --- 4. Mục Accordion thu gọn: Quét QR hoặc Chuyển khoản thủ công (Phương án 2A) ---
            VietQRPaymentCard(
              paymentInfo: paymentInfo,
              beneficiaryBankName: allBanks
                  .where((b) => b.bin == paymentInfo.bin)
                  .firstOrNull
                  ?.name,
              onCopy: _copyToClipboard,
            ),
            const SizedBox(height: 18),

            // --- 5. Order Details Section (Reusable BookingOrderSummaryCard) ---
            BookingOrderSummaryCard(
              reservationCode: reservationCode,
              vehicleName: vehicleDisplayName,
              vehicleImageUrl: vehicleImageUrl,
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

      // --- 6. Sticky Footer CTA Button: Xác nhận thanh toán ---
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
                        'Tôi đã chuyển khoản thành công',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.check_circle_outline, size: 18),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
