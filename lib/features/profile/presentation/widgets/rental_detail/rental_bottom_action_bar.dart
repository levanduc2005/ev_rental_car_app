import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rental_car/app/router/app_routes.dart';
import 'package:rental_car/features/profile/domain/entities/rental_detail_entity.dart';

class RentalBottomActionBar extends StatelessWidget {
  const RentalBottomActionBar({
    required this.rental,
    required this.onRefresh,
    super.key,
  });

  final RentalDetailEntity rental;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    final isConfirm = rental.isConfirm || rental.isDeposited;
    final isOngoing = rental.isOngoing;
    final isOverdue = rental.isOverdue || rental.isOverdueTime;
    final isChecking = rental.isChecking;
    final isPendingFee = rental.isPendingFee;
    final isCompleted = rental.isCompleted;

    if (!isConfirm &&
        !isOngoing &&
        !isOverdue &&
        !isChecking &&
        !isPendingFee &&
        !isCompleted) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(top: BorderSide(color: Color(0xFFE2E8F0))),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
<<<<<<< HEAD
            // 0. Giai đoạn CONFIRM / DEPOSITED -> Hướng dẫn gặp nhân viên trạm
            if (isConfirm) ...[
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFBFDBFE)),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.storefront_rounded,
                      color: Color(0xFF2563EB),
                      size: 22,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Vui lòng gặp nhân viên tại trạm để nhận xe và làm thủ tục kiểm tra bàn giao.',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF1D4ED8),
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // 1. Giai đoạn ONGOING / OVERDUE -> Cứu hộ SOS, Điều khiển xe & Nút trả xe
            if (isOngoing || isOverdue) ...[
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFFDC2626),
                        side: const BorderSide(
                          color: Color(0xFFDC2626),
                          width: 1.5,
                        ),
                        backgroundColor: const Color(0xFFFEF2F2),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        context.pushNamed(
                          AppRoute.emergencyReport.name,
                          extra: rental.id,
                        );
                      },
                      icon: const Icon(Icons.emergency_rounded, size: 20),
                      label: const Text(
                        'Cứu hộ SOS',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF2563EB),
                        side: const BorderSide(
                          color: Color(0xFF2563EB),
                          width: 1.5,
                        ),
                        backgroundColor: const Color(0xFFEFF6FF),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        context.pushNamed(AppRoute.control.name);
                      },
                      icon: const Icon(Icons.key_rounded, size: 20),
                      label: const Text(
                        'Điều khiển xe',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
=======
            // 1. Giai đoạn ONGOING / OVERDUE -> Cứu hộ SOS & Nút trả xe
            if (isOngoing || isOverdue) ...[
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFDC2626),
                  side: const BorderSide(color: Color(0xFFDC2626), width: 1.5),
                  backgroundColor: const Color(0xFFFEF2F2),
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  context.pushNamed(
                    AppRoute.emergencyReport.name,
                    extra: rental.id,
                  );
                },
                icon: const Icon(Icons.emergency_rounded, size: 20),
                label: const Text(
                  'Báo cáo cứu hộ khẩn cấp (SOS)',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
>>>>>>> 7c39fc5b174291fbc49582032f5d081202f6b4e3
                  ),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  context.pushNamed(
                    AppRoute.returnLocationVerification.name,
                    extra: rental,
                  );
                },
                icon: const Icon(Icons.assignment_return_rounded, size: 20),
                label: const Text(
                  'Tiến hành trả xe & Kiểm tra',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
            ],

            // 2. Giai đoạn CHECKING -> Thông báo chờ nhân viên duyệt
            if (isChecking) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFBEB),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFFDE68A)),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.hourglass_top_rounded,
                      color: Color(0xFFD97706),
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        'Đã nộp biên bản trả xe. Nhân viên trạm đang kiểm tra và lập bảng kê quyết toán...',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF92400E),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: onRefresh,
                      child: const Text(
                        'Làm mới',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // 3. Giai đoạn PENDING_FEE -> Thanh toán phụ phí phát sinh
            if (isPendingFee) ...[
              if (rental.vehicleDamages.isNotEmpty ||
                  rental.vehicleDamageCost > 0) ...[
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF2563EB),
                          side: const BorderSide(color: Color(0xFF2563EB)),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          context.pushNamed(
                            AppRoute.returnVehicleLog.name,
                            extra: rental.id,
                          );
                        },
                        icon: const Icon(Icons.car_repair_rounded, size: 18),
                        label: const Text(
                          'Biên bản hư hại',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD97706),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          context.pushNamed(
                            AppRoute.checkoutSummary.name,
                            extra: rental.id,
                          );
                        },
                        icon: const Icon(Icons.receipt_long_rounded, size: 18),
                        label: const Text(
                          'Bảng quyết toán',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ] else ...[
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD97706),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    context.pushNamed(
                      AppRoute.checkoutSummary.name,
                      extra: rental.id,
                    );
                  },
                  icon: const Icon(Icons.receipt_long_rounded, size: 18),
                  label: const Text(
                    'Bảng quyết toán cọc',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ],

            // 4. Giai đoạn COMPLETED -> Xem bảng kê quyết toán & Tiền hoàn cọc
            if (isCompleted) ...[
              if (rental.vehicleDamages.isNotEmpty ||
                  rental.vehicleDamageCost > 0) ...[
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFFDC2626),
                          side: const BorderSide(color: Color(0xFFDC2626)),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          context.pushNamed(
                            AppRoute.returnVehicleLog.name,
                            extra: rental.id,
                          );
                        },
                        icon: const Icon(Icons.car_repair_rounded, size: 18),
                        label: const Text(
                          'Biên bản hư hại',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF16A34A),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          context.pushNamed(
                            AppRoute.checkoutSummary.name,
                            extra: rental.id,
                          );
                        },
                        icon: const Icon(Icons.receipt_long_rounded, size: 18),
                        label: const Text(
                          'Hóa đơn quyết toán',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ] else ...[
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF16A34A),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    context.pushNamed(
                      AppRoute.checkoutSummary.name,
                      extra: rental.id,
                    );
                  },
                  icon: const Icon(Icons.receipt_long_rounded, size: 20),
                  label: const Text(
                    'Xem bảng kê quyết toán & Hoàn cọc',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}
