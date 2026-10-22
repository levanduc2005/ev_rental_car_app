import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rental_car/core/theme/app_colors.dart';
import 'package:rental_car/core/theme/app_spacing.dart';
import 'package:rental_car/features/booking/presentation/widgets/vietqr_payment_card.dart';
import 'package:rental_car/features/checkout/presentation/providers/checkout_controller.dart';
import 'package:rental_car/features/checkout/presentation/widgets/checkout_completion_dialog.dart';
import 'package:rental_car/features/checkout/presentation/widgets/checkout_vehicle_header_card.dart';
import 'package:rental_car/features/checkout/presentation/widgets/settlement_breakdown_card.dart';
import 'package:url_launcher/url_launcher.dart';

class CheckoutSummaryPage extends ConsumerStatefulWidget {
  const CheckoutSummaryPage({super.key, this.rentalId});

  final int? rentalId;

  @override
  ConsumerState<CheckoutSummaryPage> createState() =>
      _CheckoutSummaryPageState();
}

class _CheckoutSummaryPageState extends ConsumerState<CheckoutSummaryPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final id =
          widget.rentalId ?? ref.read(checkoutControllerProvider).rentalId;
      if (id != null && id > 0) {
        await ref
            .read(checkoutControllerProvider.notifier)
            .loadRentalOverview(id);
        final state = ref.read(checkoutControllerProvider);
        final overview = state.overview;
        final totalDeposits = overview?.totalDeposits ?? 0.0;
        final checkOutFee =
            overview?.checkListFee ?? (state.checkOutChecklist?.fee ?? 0.0);
        final vehicleDamageFee =
            (overview?.vehicleDamageFee != null &&
                overview!.vehicleDamageFee > 0)
            ? overview.vehicleDamageFee
            : (state.vehicleLog?.cost ??
                  (state.totalDamageCost > 0 ? state.totalDamageCost : 0.0));
        final totalCharges = checkOutFee + vehicleDamageFee;
        final balance = totalDeposits - totalCharges;
        if (balance < 0) {
          ref
              .read(checkoutControllerProvider.notifier)
              .fetchPayOSPaymentInfo(amount: balance.abs());
        }
      }
    });
  }

  void _showCompletionDialog() {
    final targetRentalId =
        widget.rentalId ?? ref.read(checkoutControllerProvider).rentalId;
    CheckoutCompletionDialog.show(context, rentalId: targetRentalId);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(checkoutControllerProvider);
    final controller = ref.read(checkoutControllerProvider.notifier);
    final overview = state.overview;

    if (state.isLoading && overview == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Hóa đơn quyết toán')),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 12),
              Text('Đang tính toán bảng kê tài chính...'),
            ],
          ),
        ),
      );
    }

    final totalDeposits = overview?.totalDeposits ?? 0.0;
    final checkOutFee =
        overview?.checkListFee ?? (state.checkOutChecklist?.fee ?? 0.0);
    final vehicleDamageFee =
        (overview?.vehicleDamageFee != null && overview!.vehicleDamageFee > 0)
        ? overview.vehicleDamageFee
        : (state.vehicleLog?.cost ??
              (state.totalDamageCost > 0 ? state.totalDamageCost : 0.0));
    final damages = (overview != null && overview.vehicleDamages.isNotEmpty)
        ? overview.vehicleDamages
        : (state.vehicleLog?.repairItems.isNotEmpty == true
              ? state.vehicleLog!.repairItems
              : state.damageItems);
    final totalCharges = checkOutFee + vehicleDamageFee;
    final balance = totalDeposits - totalCharges;
    final isRefund = balance >= 0;

    final targetRentalId = widget.rentalId ?? state.rentalId ?? 0;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: const Text(
          'Hóa đơn quyết toán cọc',
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
            // 1. Thông tin xe & trạm
            CheckoutVehicleHeaderCard(
              vehicleName: overview?.vehicleName ?? 'N/A',
              plateNumber: overview?.vehiclePlateNumber ?? 'N/A',
              stationName: overview?.stationName ?? 'N/A',
            ),
            const SizedBox(height: 16),

            // 2. Bảng kê chi tiết tài chính
            SettlementBreakdownCard(
              overview: overview,
              checkOutFee: checkOutFee,
              vehicleDamageFee: vehicleDamageFee,
              vehicleDamages: damages,
              totalDeposits: totalDeposits,
              balance: balance,
            ),
            const SizedBox(height: 16),

            // 3. Hiển thị mã QR VietQR từ booking nếu có tiền cần đền bù thêm
            if (!isRefund && balance.abs() > 0 && targetRentalId > 0) ...[
              if (state.isLoadingPayOS)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: const Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        SizedBox(width: 12),
                        Text(
                          'Đang tải thông tin chuyển khoản từ máy chủ...',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else if (state.payosPaymentInfo != null) ...[
                VietQRPaymentCard(
                  paymentInfo: state.payosPaymentInfo!,
                  initiallyExpanded: true,
                  headerTitle: 'Mã QR thanh toán tiền đền bù',
                  headerSubtitle:
                      'Quét mã VietQR hoặc sao chép thông tin chuyển khoản',
                  title: 'Mã VietQR thanh toán đền bù',
                  amountLabel: 'Số tiền cần đền bù:',
                  onCopy: (text, label) {
                    Clipboard.setData(ClipboardData(text: text));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Đã sao chép $label'),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF16A34A),
                          side: const BorderSide(color: Color(0xFF16A34A)),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: state.isLoadingPayOS
                            ? null
                            : () async {
                                final isPaid = await controller
                                    .checkCompensationPayment();
                                if (!context.mounted) return;
                                if (isPaid) {
                                  _showCompletionDialog();
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Chưa ghi nhận thanh toán PayOS. Nếu bạn đã chuyển khoản, vui lòng đợi 5-10 giây rồi thử lại.',
                                      ),
                                      backgroundColor: Color(0xFFD97706),
                                    ),
                                  );
                                }
                              },
                        icon: state.isLoadingPayOS
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Color(0xFF16A34A),
                                ),
                              )
                            : const Icon(Icons.sync_rounded, size: 18),
                        label: const Text(
                          'Kiểm tra thanh toán',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    if (state.payosPaymentInfo?.checkoutUrl != null &&
                        state.payosPaymentInfo!.checkoutUrl!.isNotEmpty) ...[
                      const SizedBox(width: 8),
                      IconButton.outlined(
                        style: IconButton.styleFrom(
                          foregroundColor: const Color(0xFF2563EB),
                          side: const BorderSide(color: Color(0xFF2563EB)),
                          padding: const EdgeInsets.all(12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        tooltip: 'Mở trang thanh toán web PayOS',
                        onPressed: () async {
                          final uri = Uri.parse(
                            state.payosPaymentInfo!.checkoutUrl!,
                          );
                          await launchUrl(
                            uri,
                            mode: LaunchMode.externalApplication,
                          );
                        },
                        icon: const Icon(Icons.open_in_new_rounded, size: 18),
                      ),
                    ],
                  ],
                ),
              ] else
                OutlinedButton.icon(
                  onPressed: () =>
                      controller.fetchPayOSPaymentInfo(amount: balance.abs()),
                  icon: const Icon(Icons.qr_code_2),
                  label: const Text('Tải mã QR thanh toán PayOS'),
                ),
              const SizedBox(height: 16),
            ],

            // 4. Nút xác nhận quyết toán
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: isRefund
                    ? const Color(0xFF2563EB)
                    : const Color(0xFFDC2626),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: state.isSubmitting
                  ? null
                  : () async {
                      final ok = await controller.confirmCheckoutAndSettle();
                      if (context.mounted && ok) {
                        final currentPaymentUrl = ref
                            .read(checkoutControllerProvider)
                            .paymentUrl;
                        if (currentPaymentUrl != null &&
                            currentPaymentUrl.isNotEmpty) {
                          await launchUrl(
                            Uri.parse(currentPaymentUrl),
                            mode: LaunchMode.externalApplication,
                          );
                        } else {
                          _showCompletionDialog();
                        }
                      } else if (context.mounted) {
                        final currentError = ref
                            .read(checkoutControllerProvider)
                            .errorMessage;
                        if (currentError != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(currentError),
                              backgroundColor: AppColors.error,
                            ),
                          );
                        }
                      }
                    },
              child: state.isSubmitting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      isRefund
                          ? 'Xác nhận trả xe & Nhận lại tiền cọc'
                          : 'Thanh toán tiền đền bù & Hoàn tất trả xe',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
