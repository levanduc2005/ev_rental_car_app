import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rental_car/app/router/app_routes.dart';
import 'package:rental_car/core/theme/app_colors.dart';
import 'package:rental_car/core/theme/app_spacing.dart';
import 'package:rental_car/core/widgets/gap.dart';
import 'package:rental_car/features/emergency/presentation/widgets/sos_emergency_button.dart';
import 'package:rental_car/features/emergency/presentation/widgets/sos_hotline_card.dart';
import 'package:rental_car/features/profile/domain/entities/rental_item_entity.dart';
import 'package:rental_car/features/profile/presentation/providers/profile_providers.dart';

/// Trang Chuyến đi & Cứu hộ khẩn cấp SOS (Dữ liệu thật, loại bỏ hoàn toàn mock data và nút mở/khóa cửa giả lập)
class ActiveTripPage extends ConsumerWidget {
  const ActiveTripPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rentalState = ref.watch(rentalHistoryControllerProvider);
    RentalItemEntity? activeRental;
    for (final item in rentalState.items) {
      if (item.status.toUpperCase() == 'ONGOING') {
        activeRental = item;
        break;
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: const Text(
          'Chuyến đi & Cứu hộ',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.sos_rounded,
              color: Color(0xFFDC2626),
              size: 28,
            ),
            tooltip: 'Cứu hộ khẩn cấp (SOS)',
            onPressed: () {
              context.push(
                AppRoute.emergencyReport.path,
                extra: activeRental?.id,
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () =>
            ref.read(rentalHistoryControllerProvider.notifier).refresh(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (activeRental != null) ...[
                // Thẻ thông tin chuyến đi đang hoạt động thực tế từ API
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFECFDF5),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: const Color(0xFFA7F3D0),
                              ),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.fiber_manual_record,
                                  color: Color(0xFF059669),
                                  size: 10,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'ĐANG DI CHUYỂN',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF065F46),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            'Đơn thuê #${activeRental.id}',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        activeRental.vehicleName,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      if (activeRental.stationName != null &&
                          activeRental.stationName!.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.ev_station,
                              size: 15,
                              color: Color(0xFF2563EB),
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                activeRental.stationName!,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                      const SizedBox(height: 14),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF2563EB),
                            side: const BorderSide(color: Color(0xFF2563EB)),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          icon: const Icon(
                            Icons.description_outlined,
                            size: 18,
                          ),
                          label: const Text(
                            'Xem chi tiết hợp đồng & Trả xe',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            context.pushNamed(
                              AppRoute.rentalDetail.name,
                              pathParameters: {
                                'id': activeRental!.id.toString(),
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(AppSpacing.lg),
              ] else ...[
                // Khi không có chuyến đi nào đang hoạt động
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.directions_car_outlined,
                        size: 48,
                        color: Color(0xFF94A3B8),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Chưa có chuyến đi nào',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Khi bạn nhận xe và bắt đầu hành trình, thông tin chuyến đi sẽ xuất hiện tại đây.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 14),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2563EB),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () => context.goNamed(AppRoute.home.name),
                        child: const Text('Khám phá & Thuê xe'),
                      ),
                    ],
                  ),
                ),
                const Gap(AppSpacing.lg),
              ],

              // Nút Báo cáo sự cố khẩn cấp (SOS) - Task của user
              SosEmergencyButton(rentalId: activeRental?.id),
              const Gap(AppSpacing.lg),

              // Tổng đài cứu hộ 24/7 (Gọi ngay hotline)
              const SosHotlineCard(),
            ],
          ),
        ),
      ),
    );
  }
}
