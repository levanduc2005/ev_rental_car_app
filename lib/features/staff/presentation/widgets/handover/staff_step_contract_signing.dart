import 'package:flutter/material.dart';
import 'package:rental_car/core/theme/app_colors.dart';
import 'package:rental_car/core/widgets/widgets.dart';
import 'package:rental_car/features/staff/presentation/providers/staff_handover_controller.dart';

class StaffStepContractSigning extends StatelessWidget {
  const StaffStepContractSigning({
    super.key,
    required this.state,
    required this.onOpenDocuSeal,
    required this.onContractSigned,
    required this.onRequestContract,
  });

  final StaffHandoverState state;
  final void Function(String url, int rentalId) onOpenDocuSeal;
  final VoidCallback onContractSigned;
  final VoidCallback onRequestContract;

  @override
  Widget build(BuildContext context) {
    final rental = state.rental;
    final hasUrl = state.contractUrl != null && state.contractUrl!.isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Bước 2: Ký hợp đồng số DocuSeal',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Đơn thuê #${rental?.id ?? "--"} đã khởi tạo. Vui lòng cho khách hàng xem và ký số trực tiếp trên màn hình.',
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),

          if (state.isLoading) ...[
            const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: CircularProgressIndicator(),
              ),
            ),
          ] else if (hasUrl) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFBFDBFE)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.draw_rounded, color: Color(0xFF2563EB), size: 24),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Hợp đồng DocuSeal đã sẵn sàng. Nhấn nút bên dưới để mở giao diện ký số.',
                      style: TextStyle(fontSize: 12, color: Color(0xFF1E40AF)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            AppButton(
              label: 'Mở hợp đồng cho khách ký trực tiếp',
              icon: Icons.open_in_new_rounded,
              onPressed: () =>
                  onOpenDocuSeal(state.contractUrl!, rental?.id ?? 0),
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: onContractSigned,
              child: const Text('Bỏ qua / Đã ký hợp đồng xong'),
            ),
          ] else ...[
            OutlinedButton.icon(
              onPressed: onRequestContract,
              icon: const Icon(Icons.refresh),
              label: const Text('Tải lại link hợp đồng DocuSeal'),
            ),
          ],
        ],
      ),
    );
  }
}
