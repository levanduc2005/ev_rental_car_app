import 'package:flutter/material.dart';
import 'package:rental_car/features/staff/presentation/controllers/staff_handover_state.dart';

class StaffHandoverStepper extends StatelessWidget {
  const StaffHandoverStepper({super.key, required this.currentStep});

  final StaffHandoverStep currentStep;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildStepDot(
            '1',
            'Tạo đơn',
            currentStep.index >= 0,
            currentStep == StaffHandoverStep.reservationCheck,
          ),
          Container(width: 14, height: 1, color: const Color(0xFFCBD5E1)),
          _buildStepDot(
            '2',
            'Ký HĐ',
            currentStep.index >= 1,
            currentStep == StaffHandoverStep.contractSigning,
          ),
          Container(width: 14, height: 1, color: const Color(0xFFCBD5E1)),
          _buildStepDot(
            '3',
            'Thanh toán',
            currentStep.index >= 2,
            currentStep == StaffHandoverStep.payment,
          ),
          Container(width: 14, height: 1, color: const Color(0xFFCBD5E1)),
          _buildStepDot(
            '4',
            'Kiểm tra',
            currentStep.index >= 3,
            currentStep == StaffHandoverStep.inspection,
          ),
          Container(width: 14, height: 1, color: const Color(0xFFCBD5E1)),
          _buildStepDot(
            '5',
            'Giao xe',
            currentStep.index >= 4,
            currentStep == StaffHandoverStep.completed,
          ),
        ],
      ),
    );
  }

  Widget _buildStepDot(
    String number,
    String label,
    bool isDone,
    bool isCurrent,
  ) {
    final bgColor = isDone
        ? (isCurrent ? const Color(0xFF2563EB) : const Color(0xFF10B981))
        : const Color(0xFFE2E8F0);
    final textColor = isDone ? Colors.white : const Color(0xFF64748B);

    return Column(
      children: [
        Container(
          width: 22,
          height: 22,
          alignment: Alignment.center,
          decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
          child: isDone && !isCurrent
              ? const Icon(Icons.check, size: 14, color: Colors.white)
              : Text(
                  number,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
            color: isCurrent
                ? const Color(0xFF2563EB)
                : const Color(0xFF64748B),
          ),
        ),
      ],
    );
  }
}
