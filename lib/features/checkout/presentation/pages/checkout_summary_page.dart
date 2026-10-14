import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rental_car/app/router/app_routes.dart';
import 'package:rental_car/core/theme/app_colors.dart';
import 'package:rental_car/core/theme/app_spacing.dart';
import 'package:rental_car/features/checkout/presentation/providers/checkout_controller.dart';
import 'package:rental_car/features/checkout/presentation/widgets/checkout_completion_dialog.dart';
import 'package:rental_car/features/checkout/presentation/widgets/checkout_vehicle_header_card.dart';
import 'package:rental_car/features/checkout/presentation/widgets/settlement_breakdown_card.dart';
import 'package:url_launcher/url_launcher.dart';

class CheckoutSummaryPage extends ConsumerStatefulWidget {
  const CheckoutSummaryPage({super.key, this.rentalId});

  final int? rentalId;

  @override
  ConsumerState<CheckoutSummaryPage> createState() => _CheckoutSummaryPageState();
}

class _CheckoutSummaryPageState extends ConsumerState<CheckoutSummaryPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final id = widget.rentalId ?? ref.read(checkoutControllerProvider).rentalId;
      if (id != null && id > 0) {
        ref.read(checkoutControllerProvider.notifier).loadRentalOverview(id);
      }
    });
  }

  void _showCompletionDialog() {
    final targetRentalId = widget.rentalId ?? ref.read(checkoutControllerProvider).rentalId;
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
    final checkOutFee = overview?.checkListFee ?? (state.checkOutChecklist?.fee ?? 0.0);
    final vehicleDamageFee = overview?.vehicleDamageFee ?? 0.0;
    final totalCharges = checkOutFee + vehicleDamageFee;
    final balance = totalDeposits - totalCharges;
    final isRefund = balance >= 0;

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
              totalDeposits: totalDeposits,
              balance: balance,
              onViewDamageDetail: () {
                final targetRentalId = widget.rentalId ?? state.rentalId;
                context.pushNamed(
                  AppRoute.returnVehicleLog.name,
                  extra: targetRentalId,
                );
              },
            ),
            const SizedBox(height: 24),

            // 3. Nút xác nhận quyết toán
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
                        if (state.paymentUrl != null &&
                            state.paymentUrl!.isNotEmpty) {
                          launchUrl(
                            Uri.parse(state.paymentUrl!),
                            mode: LaunchMode.externalApplication,
                          );
                        } else {
                          _showCompletionDialog();
                        }
                      } else if (context.mounted && state.errorMessage != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(state.errorMessage!),
                            backgroundColor: AppColors.error,
                          ),
                        );
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
                          : 'Thanh toán phụ phí còn thiếu & Trả xe',
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
