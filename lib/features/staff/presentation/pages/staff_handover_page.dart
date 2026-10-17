import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rental_car/core/theme/app_colors.dart';
import 'package:rental_car/core/theme/app_spacing.dart';
import 'package:rental_car/features/booking/domain/entities/reservation_entity.dart';
import 'package:rental_car/features/checkin/presentation/pages/docuseal_sign_page.dart';
import 'package:rental_car/features/profile/domain/entities/rental_detail_entity.dart';
import 'package:rental_car/features/staff/presentation/providers/staff_handover_controller.dart';
import 'package:rental_car/features/staff/presentation/providers/staff_providers.dart';
import 'package:rental_car/features/staff/presentation/widgets/handover/staff_handover_stepper.dart';
import 'package:rental_car/features/staff/presentation/widgets/handover/staff_step_completed.dart';
import 'package:rental_car/features/staff/presentation/widgets/handover/staff_step_contract_signing.dart';
import 'package:rental_car/features/staff/presentation/widgets/handover/staff_step_inspection.dart';
import 'package:rental_car/features/staff/presentation/widgets/handover/staff_step_payment.dart';
import 'package:rental_car/features/staff/presentation/widgets/handover/staff_step_reservation_check.dart';
import 'package:url_launcher/url_launcher.dart';

class StaffHandoverPage extends ConsumerStatefulWidget {
  const StaffHandoverPage({super.key, this.reservation, this.rental});

  final ReservationEntity? reservation;
  final RentalDetailEntity? rental;

  @override
  ConsumerState<StaffHandoverPage> createState() => _StaffHandoverPageState();
}

class _StaffHandoverPageState extends ConsumerState<StaffHandoverPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(staffHandoverControllerProvider.notifier)
          .setup(reservation: widget.reservation, rental: widget.rental);
    });
  }

  void _openDocuSealSigning(String url, int rentalId) {
    Navigator.of(context)
        .push(
          MaterialPageRoute<void>(
            builder: (_) =>
                DocuSealSignPage(rentalId: rentalId, signingUrl: url),
          ),
        )
        .then((_) {
          ref.read(staffHandoverControllerProvider.notifier).onContractSigned();
        });
  }

  Future<void> _openPaymentUrl(String url) async {
    final uri = Uri.tryParse(url);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(staffHandoverControllerProvider);
    final controller = ref.read(staffHandoverControllerProvider.notifier);
    final dashboardState = ref.watch(staffDashboardControllerProvider);
    final staffProfile = dashboardState.staffProfile;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: Text(
          widget.reservation != null
              ? 'Xử lý nhận xe #${widget.reservation!.code}'
              : 'Xử lý đơn thuê #${widget.rental?.id}',
          style: const TextStyle(
            fontSize: 15,
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
            // 1. Stepper Tiến trình
            StaffHandoverStepper(currentStep: state.currentStep),
            const SizedBox(height: 16),

            // Thông báo lỗi nếu có
            if (state.errorMessage != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF1F2),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFFECDD3)),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: AppColors.error,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        state.errorMessage!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF9F1239),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
            ],

            // 2. Nội dung theo từng bước
            switch (state.currentStep) {
              StaffHandoverStep.reservationCheck => StaffStepReservationCheck(
                state: state,
                staffId: staffProfile?.staffId ?? 1,
                onStartHandover: () =>
                    controller.startHandover(staffProfile?.staffId ?? 1),
              ),
              StaffHandoverStep.contractSigning => StaffStepContractSigning(
                state: state,
                onOpenDocuSeal: _openDocuSealSigning,
                onContractSigned: controller.onContractSigned,
                onRequestContract: () =>
                    controller.requestContract(state.rental?.id ?? 0),
              ),
              StaffHandoverStep.payment => StaffStepPayment(
                state: state,
                controller: controller,
                onOpenPaymentUrl: _openPaymentUrl,
              ),
              StaffHandoverStep.inspection => StaffStepInspection(
                state: state,
                controller: controller,
                staffEmail: staffProfile?.email ?? 'staff@emotion.vn',
              ),
              StaffHandoverStep.completed => StaffStepCompleted(
                onDone: () => Navigator.of(context).pop(),
              ),
            },
          ],
        ),
      ),
    );
  }
}
