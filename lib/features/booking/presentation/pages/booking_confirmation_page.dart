import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rental_car/app/router/app_routes.dart';
import 'package:rental_car/core/theme/app_colors.dart';
import 'package:rental_car/core/theme/app_spacing.dart';
import 'package:rental_car/features/auth/presentation/providers/auth_controller.dart';
import 'package:rental_car/features/booking/presentation/providers/booking_form_controller.dart';
import 'package:rental_car/features/booking/presentation/widgets/booking_payment_breakdown_card.dart';
import 'package:rental_car/features/booking/presentation/widgets/booking_schedule_card.dart';
import 'package:rental_car/features/booking/presentation/widgets/booking_vehicle_summary_card.dart';

/// Trang Xác nhận đặt xe - Tổng hợp thông tin trước khi chuyển sang thanh toán
class BookingConfirmationPage extends ConsumerStatefulWidget {
  final int? vehicleId;
  const BookingConfirmationPage({super.key, this.vehicleId});

  @override
  ConsumerState<BookingConfirmationPage> createState() =>
      _BookingConfirmationPageState();
}

class _BookingConfirmationPageState
    extends ConsumerState<BookingConfirmationPage> {
  bool _agreedToTerms = true;
  final TextEditingController _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.vehicleId != null &&
          ref.read(bookingFormControllerProvider).vehicle == null) {
        ref
            .read(bookingFormControllerProvider.notifier)
            .loadVehicleById(widget.vehicleId!);
      }
    });
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _handleConfirmBooking() async {
    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng đồng ý với điều khoản dịch vụ để tiếp tục.'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final authUser = ref.read(authControllerProvider).user;
    if (authUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Vui lòng đăng nhập để tiến hành đặt xe.'),
          backgroundColor: AppColors.error,
          action: SnackBarAction(
            label: 'Đăng nhập',
            textColor: Colors.white,
            onPressed: () => context.pushNamed(AppRoute.login.name),
          ),
        ),
      );
      return;
    }

    final controller = ref.read(bookingFormControllerProvider.notifier);
    final reservation = await controller.submitReservation(
      note: _noteController.text.trim().isNotEmpty
          ? _noteController.text.trim()
          : null,
    );

    if (!mounted) return;

    if (reservation != null) {
      // Đặt xe thành công -> Chuyển sang màn hình thanh toán VietQR MBBank
      context.pushNamed(AppRoute.payment.name);
    } else {
      final error = ref.read(bookingFormControllerProvider).errorMessage;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error ?? 'Đặt xe thất bại. Vui lòng thử lại.'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bookingState = ref.watch(bookingFormControllerProvider);
    final authState = ref.watch(authControllerProvider);
    final user = authState.user;
    final vehicle = bookingState.vehicle;
    final fee = bookingState.feeBreakdown;
    final totalRent = bookingState.estimatedTotalRent;

    if (vehicle == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Xác nhận đặt xe')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Chưa có thông tin xe được chọn.'),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => context.pop(),
                child: const Text('Quay lại chọn xe'),
              ),
            ],
          ),
        ),
      );
    }

    final pickupLoc = bookingState.pickupAddress;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Xác nhận thông tin đặt xe',
          style: TextStyle(
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
            // --- 1. Vehicle Summary Card (Reusable BookingVehicleSummaryCard) ---
            BookingVehicleSummaryCard(
              name: vehicle.name,
              imageUrl: vehicle.imageUrl,
              plateNumber: vehicle.plateNumber,
              specs:
                  '${vehicle.seats} chỗ • ${vehicle.transmission} • ${vehicle.fuelType}',
            ),
            const SizedBox(height: 16),

            // --- 2. Renter Driver Info Card ---
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Thông tin người lái xe',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Icon(Icons.person_outline,
                          size: 18, color: Color(0xFF2563EB)),
                    ],
                  ),
                  const Divider(height: 16),
                  _InfoItem(
                    label: 'Họ và tên:',
                    value:
                        (user?.fullName != null && user!.fullName!.isNotEmpty)
                            ? user.fullName!
                            : 'Khách hàng e-Motion',
                  ),
                  const SizedBox(height: 8),
                  _InfoItem(
                    label: 'Số điện thoại:',
                    value: user?.phone?.isNotEmpty == true
                        ? user!.phone!
                        : '0838780005',
                  ),
                  const SizedBox(height: 8),
                  _InfoItem(
                    label: 'Email tài khoản:',
                    value: user?.email ?? 'khang@gmail.com',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // --- 3. Schedule & Location (Reusable BookingScheduleCard) ---
            BookingScheduleCard(
              startDateTime: bookingState.startDateTime,
              endDateTime: bookingState.endDateTime,
              pickupLocation: pickupLoc,
              returnLocation: pickupLoc,
              title: 'Lịch trình & Địa điểm',
            ),
            const SizedBox(height: 16),

            // --- 4. Cost Breakdown (Reusable BookingPaymentBreakdownCard) ---
            BookingPaymentBreakdownCard(
              depositFee: fee?.holdDepositFee ?? 500000,
              totalRent: totalRent,
              collateralFee: fee?.collateralFee ?? vehicle.depositFee?.toInt() ?? 3000000,
            ),
            const SizedBox(height: 16),

            // --- 5. Payment Method & Note ---
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Phương thức thanh toán giữ chỗ',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                      border: Border.all(color: const Color(0xFF2563EB)),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.qr_code_2, color: Color(0xFF2563EB)),
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Chuyển khoản VietQR MBBank (PayOS)',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              Text(
                                'Quét mã VietQR Napas247 hoặc chuyển khoản ngân hàng',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.check_circle,
                            color: Color(0xFF2563EB), size: 20),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: _noteController,
                    decoration: InputDecoration(
                      labelText: 'Ghi chú cho e-Motion (Tùy chọn)',
                      hintText: 'Ví dụ: Cần hỗ trợ ghế trẻ em...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                    ),
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // --- 6. Terms Checkbox ---
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Checkbox(
                  value: _agreedToTerms,
                  activeColor: const Color(0xFF2563EB),
                  onChanged: (val) {
                    setState(() => _agreedToTerms = val ?? false);
                  },
                ),
                const Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text(
                      'Tôi đã đọc, hiểu và đồng ý với Điều khoản thuê xe tự lái và Chính sách hoàn tiền cọc giữ chỗ của e-Motion.',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // --- 7. Confirm Button ---
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                elevation: 2,
              ),
              onPressed: bookingState.isCreatingReservation
                  ? null
                  : _handleConfirmBooking,
              child: bookingState.isCreatingReservation
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
                          'Đang khởi tạo đơn trên hệ thống...',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ],
                    )
                  : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Xác nhận & Giữ xe ngay',
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
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  const _InfoItem({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style:
                const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary),
          ),
        ),
      ],
    );
  }
}
