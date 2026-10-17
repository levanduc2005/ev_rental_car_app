import 'package:flutter/material.dart';
import 'package:rental_car/core/theme/app_colors.dart';
import 'package:rental_car/core/widgets/widgets.dart';
import 'package:rental_car/features/booking/presentation/utils/booking_formatters.dart';
import 'package:rental_car/features/staff/presentation/providers/staff_handover_controller.dart';

class StaffStepReservationCheck extends StatelessWidget {
  const StaffStepReservationCheck({
    super.key,
    required this.state,
    required this.staffId,
    required this.onStartHandover,
  });

  final StaffHandoverState state;
  final int staffId;
  final VoidCallback onStartHandover;

  @override
  Widget build(BuildContext context) {
    final res = state.reservation;

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
            'Bước 1: Xác nhận thông tin nhận xe',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _buildDetailRow('Mã đặt trước:', res?.code ?? '--'),
          _buildDetailRow('Khách hàng:', res?.userEmail ?? '--'),
          _buildDetailRow('Xe bàn giao:', res?.vehicleName ?? '--'),
          _buildDetailRow(
            'Thời gian nhận:',
            res?.startTime != null
                ? BookingFormatters.formatDateTime(res!.startTime!)
                : '--',
          ),
          _buildDetailRow(
            'Đã cọc giữ chỗ:',
            res?.depositAmount != null
                ? BookingFormatters.formatCurrency(res!.depositAmount!.round())
                : '--',
          ),
          const Divider(height: 24),
          const Text(
            'Nhân viên kiểm tra CCCD và GPLX của khách hàng đối chiếu với thông tin trên hệ thống trước khi tiến hành tạo đơn thuê.',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          if (res != null &&
              (res.status.toUpperCase() == 'COMPLETED' ||
                  res.status.toUpperCase() == 'DONE'))
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFECFDF5),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFA7F3D0)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle_outline_rounded,
                    size: 18,
                    color: Color(0xFF059669),
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Đơn đặt xe này đã hoàn tất bàn giao',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF059669),
                    ),
                  ),
                ],
              ),
            )
          else
            AppButton(
              label: state.isSubmitting
                  ? 'Đang tạo đơn thuê...'
                  : 'Tiến hành nhận xe & Tạo hợp đồng',
              icon: Icons.assignment_turned_in_rounded,
              isLoading: state.isSubmitting,
              onPressed: onStartHandover,
            ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
