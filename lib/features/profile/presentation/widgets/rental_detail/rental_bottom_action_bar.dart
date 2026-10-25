import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rental_car/features/active_trip/presentation/providers/active_rental_providers.dart';
import 'package:rental_car/features/active_trip/presentation/widgets/extend_trip_bottom_sheet.dart';
import 'package:rental_car/features/profile/domain/entities/rental_detail_entity.dart';
import 'package:url_launcher/url_launcher.dart';

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
    final isChecking = rental.isChecking;
    final isPendingFee = rental.isPendingFee;
    final isPendingExtendFee = rental.isPendingExtendFee;
    final isCompleted = rental.isCompleted;
    final canExtend = rental.canExtend;

    if (!isConfirm &&
        !isChecking &&
        !isPendingFee &&
        !isPendingExtendFee &&
        !isCompleted &&
        !canExtend) {
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
              const SizedBox(height: 10),
            ],

            // 1. Nút Gia hạn hợp đồng (nếu đủ điều kiện canExtend)
            if (canExtend) ...[
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF2563EB),
                  side: const BorderSide(color: Color(0xFF2563EB)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  if (rental.vehicleId != null && rental.endTime != null) {
                    double hourlyRate = rental.pricePerHour ?? 225000;
                    if (rental.rentFee > 0 && rental.startTime != null) {
                      final h = rental.endTime!
                          .difference(rental.startTime!)
                          .inHours;
                      if (h > 0) {
                        hourlyRate = rental.rentFee / h;
                      }
                    }
                    showExtendTripBottomSheet(
                      context: context,
                      rentalId: rental.id,
                      vehicleId: rental.vehicleId!,
                      vehicleName: rental.vehicleName,
                      currentEndTime: rental.endTime!,
                      pricePerHour: hourlyRate,
                      onSuccess: onRefresh,
                    );
                  }
                },
                icon: const Icon(Icons.more_time_rounded, size: 18),
                label: const Text(
                  'Gia hạn hợp đồng',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10),
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

            // 3. Giai đoạn PENDING_FEE hoặc PENDING_EXTEND_FEE -> Thanh toán phụ phí phát sinh
            if (isPendingFee || isPendingExtendFee) ...[
              if (rental.paymentUrl != null &&
                  rental.paymentUrl!.isNotEmpty) ...[
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD97706),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                    final uri = Uri.tryParse(rental.paymentUrl!);
                    if (uri != null && await canLaunchUrl(uri)) {
                      await launchUrl(
                        uri,
                        mode: LaunchMode.externalApplication,
                      );
                    }
                  },
                  icon: const Icon(Icons.payment_rounded, size: 18),
                  label: Text(
                    isPendingExtendFee
                        ? 'Mở trang thanh toán PayOS'
                        : 'Thanh toán phụ phí qua PayOS',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (isPendingExtendFee) ...[
                  const SizedBox(height: 8),
                  Consumer(
                    builder: (context, ref, _) {
                      return OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: const BorderSide(color: Color(0xFF16A34A)),
                          foregroundColor: const Color(0xFF16A34A),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () async {
                          final useCase = ref.read(
                            checkExtendPaymentUseCaseProvider,
                          );
                          final result = await useCase(rental.id);
                          if (!context.mounted) return;
                          result.when(
                            ok: (isPaid) {
                              if (isPaid) {
                                onRefresh();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Thanh toán gia hạn thành công! Chuyến đi đã được cập nhật.',
                                    ),
                                    backgroundColor: Color(0xFF16A34A),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Hệ thống chưa nhận được thanh toán. Vui lòng thử lại sau vài giây.',
                                    ),
                                    backgroundColor: Color(0xFFD97706),
                                  ),
                                );
                              }
                            },
                            err: (failure) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(failure.message),
                                  backgroundColor: const Color(0xFFDC2626),
                                ),
                              );
                            },
                          );
                        },
                        icon: const Icon(Icons.refresh_rounded, size: 18),
                        label: const Text(
                          'Kiểm tra trạng thái thanh toán',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ] else ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFBEB),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFFDE68A)),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.pending_actions_rounded,
                        color: Color(0xFFD97706),
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          isPendingExtendFee
                              ? 'Đơn thuê đang chờ thanh toán tiền gia hạn.'
                              : 'Đơn thuê đang chờ xử lý phụ phí phát sinh. Vui lòng liên hệ nhân viên trạm.',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF92400E),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],

            // 4. Giai đoạn COMPLETED -> Trạng thái hoàn tất quyết toán
            if (isCompleted) ...[
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0FDF4),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFBBF7D0)),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.check_circle_rounded,
                      color: Color(0xFF16A34A),
                      size: 20,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Đơn thuê đã hoàn tất và kết thúc quyết toán.',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF15803D),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
