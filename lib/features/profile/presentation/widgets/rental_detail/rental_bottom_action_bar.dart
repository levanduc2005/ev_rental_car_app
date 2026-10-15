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
    final isOngoing = rental.isOngoing;
    final isOverdue = rental.isOverdue || rental.isOverdueTime;
    final isChecking = rental.isChecking;
    final isPendingFee = rental.isPendingFee;
    final isCompleted = rental.isCompleted;

    if (!isOngoing && !isOverdue && !isChecking && !isPendingFee && !isCompleted) {
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
            // 1. Giai đoạn ONGOING / OVERDUE -> Cứu hộ SOS, Điều khiển xe & Nút trả xe
            if (isOngoing || isOverdue) ...[
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFFDC2626),
                        side: const BorderSide(color: Color(0xFFDC2626), width: 1.5),
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
                        side: const BorderSide(color: Color(0xFF2563EB), width: 1.5),
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
                  ),
                ],
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
                        style: TextStyle(fontSize: 12, color: Color(0xFF92400E)),
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
              if (rental.vehicleDamages.isNotEmpty || rental.vehicleDamageCost > 0) ...[
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
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],

            // 4. Giai đoạn COMPLETED -> Xem bảng kê quyết toán & Tiền hoàn cọc
            if (isCompleted) ...[
              if (rental.vehicleDamages.isNotEmpty || rental.vehicleDamageCost > 0) ...[
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
